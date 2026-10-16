import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/network/friendly_error.dart';
import '../../../shared/widgets/settings_widgets.dart';
import '../data/my_store_api.dart';
import '../data/my_store_models.dart';
import 'my_store_widgets.dart';

/// `/my-store/setup` — the store's name, a line about it, and the address
/// goods are picked up from. A new store waits for the team to approve it.
class StoreSetupPage extends StatefulWidget {
  const StoreSetupPage({super.key});

  @override
  State<StoreSetupPage> createState() => _StoreSetupPageState();
}

class _StoreSetupPageState extends State<StoreSetupPage> {
  final _api = getIt<MyStoreApi>();
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _about = TextEditingController();
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _city = TextEditingController();
  final _pin = TextEditingController();
  final _phone = TextEditingController();
  String? _state;
  List<String> _states = const [];
  StoreSetup? _existing;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [_name, _about, _line1, _line2, _city, _pin, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([_api.setup(), _api.options()]);
      final setup = results[0] as StoreSetup;
      final options = results[1] as CatalogOptions;
      if (!mounted) return;
      setState(() {
        _existing = setup;
        _states = options.states;
        _name.text = setup.displayName;
        _about.text = setup.description;
        _line1.text = setup.address['line1'] ?? '';
        _line2.text = setup.address['line2'] ?? '';
        _city.text = setup.address['city'] ?? '';
        _pin.text = setup.address['postal_code'] ?? '';
        _phone.text = setup.address['phone'] ?? '';
        final st = setup.address['state'] ?? '';
        _state = _states.firstWhere(
          (s) => s.toLowerCase() == st.toLowerCase(),
          orElse: () => '',
        );
        if (_state!.isEmpty) _state = null;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _loading = false;
        });
      }
    }
  }

  Future<void> _save() async {
    final l = context.l10n;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final setup = await _api.saveSetup(
        displayName: _name.text,
        description: _about.text,
        address: {
          'line1': _line1.text.trim(),
          'line2': _line2.text.trim(),
          'city': _city.text.trim(),
          'state': _state ?? '',
          'postal_code': _pin.text.trim(),
          'phone': _phone.text.trim(),
        },
      );
      if (!mounted) return;
      showToast(
        context,
        _existing?.exists ?? false
            ? l.commonSaved
            : (setup.isActive ? l.msStoreOpened : l.msStoreSentForApproval),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _saving = false);
  }

  String? _required(String? v) =>
      (v ?? '').trim().isEmpty ? context.l10n.msRequired : null;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isNew = !(_existing?.exists ?? false);
    return SubPageScaffold(
      title: isNew ? l.msSetUpStore : l.msEditStore,
      subtitle: l.msSetupSubtitle,
      bottomBar: _loading || _error != null
          ? null
          : StickyActionBar(
              child: BusyButton(
                label: isNew ? l.msSendForApproval : l.commonSave,
                busy: _saving,
                onPressed: _save,
              ),
            ),
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error != null)
          ErrorView(message: _error!, onRetry: _load)
        else
          Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsCard(
                  title: l.msStoreSection,
                  icon: Icons.storefront_rounded,
                  hue: AstroPalette.money,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _name,
                        maxLength: 120,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: l.msStoreName),
                        validator: _required,
                      ),
                      TextFormField(
                        controller: _about,
                        maxLines: 3,
                        maxLength: 600,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: l.msStoreAbout,
                          hintText: l.msStoreAboutHint,
                        ),
                      ),
                    ],
                  ),
                ),
                SettingsCard(
                  title: l.msPickupSection,
                  subtitle: l.msPickupHint,
                  icon: Icons.local_shipping_rounded,
                  hue: AstroPalette.career,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _line1,
                        decoration: InputDecoration(
                          labelText: l.msAddressLine1,
                        ),
                        validator: _required,
                      ),
                      TextFormField(
                        controller: _line2,
                        decoration: InputDecoration(
                          labelText: l.msAddressLine2,
                        ),
                      ),
                      TextFormField(
                        controller: _city,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: l.msCity),
                        validator: _required,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _state,
                        isExpanded: true,
                        decoration: InputDecoration(labelText: l.msState),
                        items: [
                          for (final s in _states)
                            DropdownMenuItem(value: s, child: Text(s)),
                        ],
                        onChanged: (v) => setState(() => _state = v),
                        validator: (v) => v == null ? l.msRequired : null,
                      ),
                      TextFormField(
                        controller: _pin,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(labelText: l.msPin),
                        validator: (v) =>
                            RegExp(r'^\d{6}$').hasMatch((v ?? '').trim())
                            ? null
                            : l.msPinInvalid,
                      ),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: l.msPickupPhone),
                        validator: _required,
                      ),
                    ],
                  ),
                ),
                NoteBox(
                  text: l.msSetupNote,
                  color: AstroPalette.health.end,
                  icon: Icons.verified_user_rounded,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
