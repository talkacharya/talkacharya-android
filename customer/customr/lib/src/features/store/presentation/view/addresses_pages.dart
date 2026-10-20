import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/async_value.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/models/address.dart';
import '../../data/store_repository.dart';
import '../cubit/order_cubits.dart';
import '../widgets/order_widgets.dart';
import '../widgets/store_ui.dart';
import 'map_picker_page.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// `/store/addresses` — manage saved delivery addresses.
class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  Future<void> _edit(BuildContext context, [Address? a]) async {
    final cubit = context.read<AddressesCubit>();
    final saved = await context.push<Address>(
      a == null ? Routes.storeAddressNew : Routes.storeAddressEdit(a.id),
      extra: a,
    );
    if (saved != null) await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.storeAddressesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context),
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(l.storeAddAddress),
      ),
      body: BlocBuilder<AddressesCubit, AsyncValue<List<Address>>>(
        builder: (context, state) {
          final cubit = context.read<AddressesCubit>();
          final list = state.value;
          if (state.isError && list == null) {
            return ErrorView(message: state.error ?? '', onRetry: cubit.load);
          }
          if (list == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.location_on_outlined,
              title: l.storeNoAddressesTitle,
              message: l.storeNoAddressesBody,
            );
          }
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final a = list[i];
                return AddressCard(
                  address: a,
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'edit') return _edit(context, a);
                      final messenger = ScaffoldMessenger.of(context);
                      final err = v == 'default'
                          ? await cubit.makeDefault(a)
                          : await cubit.delete(a);
                      if (err != null) {
                        messenger.showSnackBar(SnackBar(content: Text(err)));
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'edit', child: Text(l.storeEdit)),
                      if (!a.isDefault)
                        PopupMenuItem(
                          value: 'default',
                          child: Text(l.storeMakeDefault),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l.storeDelete),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// One address, used by the address book and the checkout picker.
class AddressCard extends StatelessWidget {
  const AddressCard({
    required this.address,
    this.selected,
    this.onTap,
    this.trailing,
    super.key,
  });

  final Address address;

  /// Non-null renders a radio (checkout picker).
  final bool? selected;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final a = address;
    final isSelected = selected ?? false;
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? AstroPalette.money.end : brand.hairline,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selected != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 2),
                  child: Icon(
                    isSelected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: isSelected ? AstroPalette.money.end : brand.inkMuted,
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: HueIcon(
                    hue: AstroPalette.money,
                    icon: Icons.location_on_rounded,
                    size: 38,
                    iconSize: 20,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          a.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (a.label.isNotEmpty)
                          StoreStatusChip(label: a.label, tone: 'neutral'),
                        if (a.isDefault)
                          StoreStatusChip(label: l.storeDefault, tone: 'info'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a.singleLine,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      a.phone,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// `/store/addresses/new` and `/store/addresses/:id/edit`. Pops the saved [Address].
///
/// A new address starts on the map ([MapPickerPage]): the pin's address fills
/// the form, and the customer adds what a map can't know — the house or flat
/// number. Typing everything by hand still works (back out of the map). The
/// mobile number can be typed or picked from contacts.
class AddressFormPage extends StatefulWidget {
  const AddressFormPage({this.initial, this.addressId, super.key});

  final Address? initial;

  /// Set when opened by URL without [initial]; the address is fetched.
  final String? addressId;

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _landmark = TextEditingController();
  final _city = TextEditingController();
  final _pin = TextEditingController();
  final _gstin = TextEditingController();
  final _houseFocus = FocusNode();
  String? _state;
  String _label = '';
  bool _isDefault = false;
  String _id = '';
  bool _loading = false;
  bool _saving = false;
  double? _lat;
  double? _lng;
  String _pinnedAt = '';
  bool _filledFromMap = false;

  @override
  void initState() {
    super.initState();
    final a = widget.initial;
    if (a != null) {
      _fill(a);
    } else if (widget.addressId != null) {
      _fetch(widget.addressId!);
    } else {
      _prefillMe();
      // A new address starts on the map.
      WidgetsBinding.instance.addPostFrameCallback((_) => _openMap());
    }
  }

  /// The account's own name and number — most orders are for oneself.
  void _prefillMe() {
    try {
      final me = context.read<AuthBloc>().state.user;
      if (me == null) return;
      _name.text = me.fullName.isNotEmpty ? me.fullName : me.displayName;
      _phone.text = me.phone;
    } catch (_) {}
  }

  Future<void> _fetch(String id) async {
    setState(() => _loading = true);
    try {
      final list = await getIt<StoreRepository>().addresses();
      final a = list.where((x) => x.id == id).firstOrNull;
      if (a != null) _fill(a);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  void _fill(Address a) {
    _id = a.id;
    _name.text = a.name;
    _phone.text = a.phone;
    _line1.text = a.line1;
    _line2.text = a.line2;
    _landmark.text = a.landmark;
    _city.text = a.city;
    _pin.text = a.postalCode;
    _gstin.text = a.gstin;
    _state = _matchState(a.state);
    _label = a.label;
    _isDefault = a.isDefault;
    _lat = a.latitude;
    _lng = a.longitude;
    _pinnedAt = a.hasPin ? a.singleLine : '';
  }

  /// A state name from the map → the one in our list ("NCT of Delhi" → "Delhi").
  static String? _matchState(String raw) {
    final want = raw.toLowerCase().replaceAll('&', 'and').trim();
    if (want.isEmpty) return null;
    for (final s in Address.indianStates) {
      if (s.toLowerCase() == want) return s;
    }
    for (final s in Address.indianStates) {
      if (want.contains(s.toLowerCase())) return s;
    }
    return null;
  }

  Future<void> _openMap() async {
    final found = await MapPickerPage.open(
      context,
      initial: _lat != null && _lng != null ? LatLng(_lat!, _lng!) : null,
    );
    if (found == null || !mounted) return;
    setState(() {
      _lat = found.latitude;
      _lng = found.longitude;
      _pinnedAt = found.formatted;
      // What the map knows replaces what was there. The house number is the
      // customer's: filled only when Google has one and the field is empty.
      if (found.line1.isNotEmpty && _line1.text.trim().isEmpty) {
        _line1.text = found.line1;
      }
      if (found.line2.isNotEmpty) _line2.text = found.line2;
      if (found.city.isNotEmpty) _city.text = found.city;
      if (found.postalCode.isNotEmpty) _pin.text = found.postalCode;
      _state = _matchState(found.state) ?? _state;
      _filledFromMap = true;
    });
    // Ask for what the map can't know.
    if (_line1.text.trim().isEmpty) _houseFocus.requestFocus();
  }

  Future<void> _pickContact() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final c = await FlutterNativeContactPicker().selectPhoneNumber();
      final raw = c?.selectedPhoneNumber ?? c?.phoneNumbers?.firstOrNull;
      if (raw == null || !mounted) return;
      setState(() {
        _phone.text = _cleanPhone(raw);
        final name = c?.fullName?.trim() ?? '';
        if (name.isNotEmpty) _name.text = name;
      });
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(friendlyError(e))));
    }
  }

  /// "+91 98123-45678" / "098123 45678" → "+919812345678"; else just the digits.
  static String _cleanPhone(String raw) {
    var d = raw.replaceAll(RegExp(r'[^\d+]'), '');
    if (d.startsWith('+')) return d;
    d = d.replaceFirst(RegExp(r'^0+'), '');
    if (d.length == 10) return '+91$d';
    if (d.length == 12 && d.startsWith('91')) return '+$d';
    return d;
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _phone,
      _line1,
      _line2,
      _landmark,
      _city,
      _pin,
      _gstin,
    ]) {
      c.dispose();
    }
    _houseFocus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final saved = await getIt<StoreRepository>().saveAddress(
        Address(
          id: _id,
          label: _label,
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          line1: _line1.text.trim(),
          line2: _line2.text.trim(),
          landmark: _landmark.text.trim(),
          city: _city.text.trim(),
          state: _state!,
          postalCode: _pin.text.trim(),
          gstin: _gstin.text.trim().toUpperCase(),
          isDefault: _isDefault,
          latitude: _lat,
          longitude: _lng,
        ),
      );
      router.pop(saved);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(friendlyError(e))));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l.storeRequired : null;
    final labels = {
      'Home': l.storeLabelHome,
      'Work': l.storeLabelWork,
      'Other': l.storeLabelOther,
    };
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(
        title: Text(_id.isEmpty ? l.storeAddAddress : l.storeEditAddress),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  _MapCard(
                    lat: _lat,
                    lng: _lng,
                    address: _pinnedAt,
                    onTap: _openMap,
                  ),
                  if (_filledFromMap) ...[
                    const SizedBox(height: 10),
                    StoreNotice(
                      icon: Icons.edit_location_alt_outlined,
                      tone: 'info',
                      message: l.addrFilledFromMap,
                    ),
                  ],
                  const SizedBox(height: 18),
                  StoreSectionTitle(
                    l.addrDetailsTitle,
                    hue: AstroPalette.money,
                  ),
                  TextFormField(
                    controller: _line1,
                    focusNode: _houseFocus,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l.addrHouse),
                    validator: required,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _line2,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l.addrArea),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _landmark,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: l.storeLandmark),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _city,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(labelText: l.storeCity),
                          validator: required,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _pin,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: l.storePincode,
                            counterText: '',
                          ),
                          validator: (v) =>
                              RegExp(r'^[1-9][0-9]{5}$').hasMatch(v ?? '')
                              ? null
                              : l.storePincodeInvalid,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    // Re-created when the map fills a new state in.
                    key: ValueKey(_state),
                    initialValue: _state,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.storeState),
                    items: [
                      for (final s in Address.indianStates)
                        DropdownMenuItem(value: s, child: Text(s)),
                    ],
                    onChanged: (v) => setState(() => _state = v),
                    validator: (v) => v == null ? l.storeRequired : null,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final e in labels.entries)
                        ChoiceChip(
                          label: Text(e.value),
                          selected: _label == e.key,
                          onSelected: (s) =>
                              setState(() => _label = s ? e.key : ''),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  StoreSectionTitle(l.addrReceiver, hue: AstroPalette.career),
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l.storeFullName),
                    validator: required,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l.storePhone,
                      suffixIcon: IconButton(
                        tooltip: l.addrPickContact,
                        icon: const Icon(Icons.contact_phone_outlined),
                        onPressed: _pickContact,
                      ),
                    ),
                    validator: (v) {
                      final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                      return digits.length < 10 ? l.storePhoneInvalid : null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _gstin,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 15,
                    decoration: InputDecoration(
                      labelText: l.storeGstinOptional,
                      helperText: l.storeGstinHelp,
                    ),
                    validator: (v) {
                      final s = (v ?? '').trim();
                      return s.isEmpty || s.length == 15
                          ? null
                          : l.storeGstinInvalid;
                    },
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _isDefault,
                    onChanged: (v) => setState(() => _isDefault = v),
                    title: Text(l.storeMakeDefault),
                  ),
                  const SizedBox(height: 12),
                  GoldButton(
                    label: l.storeSaveAddress,
                    busy: _saving,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
    );
  }
}

/// The pin on a small map with "Change" — or a prompt to pin it.
class _MapCard extends StatelessWidget {
  const _MapCard({
    required this.lat,
    required this.lng,
    required this.address,
    required this.onTap,
  });

  final double? lat;
  final double? lng;
  final String address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    if (lat == null || lng == null) {
      return StoreCard(
        child: Row(
          children: [
            const HueIcon(
              hue: AstroPalette.money,
              icon: Icons.add_location_alt_rounded,
              size: 42,
              iconSize: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(l.addrNoPin, style: theme.textTheme.bodyMedium),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
              onPressed: onTap,
              child: Text(l.addrPinOnMap),
            ),
          ],
        ),
      );
    }
    final at = LatLng(lat!, lng!);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: brand.hairline),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 130,
            child: IgnorePointer(
              child: GoogleMap(
                key: ValueKey(at),
                initialCameraPosition: CameraPosition(target: at, zoom: 16),
                liteModeEnabled: true,
                markers: {
                  Marker(markerId: const MarkerId('pin'), position: at),
                },
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: AstroPalette.money.end,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.isNotEmpty ? address : l.addrOnMap,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
                  ),
                ),
                TextButton(onPressed: onTap, child: Text(l.storeChange)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
