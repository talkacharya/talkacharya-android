import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/models/place.dart';
import '../../data/store_repository.dart';
import '../widgets/store_ui.dart';

/// The delivery-address map, the way food and ride apps do it: the map moves
/// under a fixed pin, and the address under the pin is looked up as it settles.
/// Search finds a place by name; "my location" jumps to where the phone is.
/// Pops the [FoundPlace] the customer confirmed (null if they backed out).
///
/// All lookups go through our server (`/app/store/places/*`), so the Google key
/// stays there; only the map tiles use the app's own Maps SDK key.
class MapPickerPage extends StatefulWidget {
  const MapPickerPage({this.initial, super.key});

  /// Where to start: the address being edited. Null starts at the phone's location.
  final LatLng? initial;

  static Future<FoundPlace?> open(BuildContext context, {LatLng? initial}) =>
      Navigator.of(context).push<FoundPlace>(
        MaterialPageRoute(builder: (_) => MapPickerPage(initial: initial)),
      );

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

/// Middle of India, zoomed out — until we know better.
const _india = LatLng(22.9734, 78.6569);

class _MapPickerPageState extends State<MapPickerPage> {
  final _repo = getIt<StoreRepository>();
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  GoogleMapController? _map;
  late LatLng _target = widget.initial ?? _india;
  FoundPlace? _found;
  bool _looking = false;
  bool _failed = false;
  bool _moving = false;
  bool _locating = false;
  bool _canShowMe = false;
  int _lookup = 0;
  Timer? _settle;
  Timer? _typing;
  List<PlaceSuggestion>? _suggestions;
  bool _searching = false;
  // One search session per visit: Google bills search + the picked place as one.
  final String _session = _token();

  /// Skip the pin lookup once: a picked suggestion already says where we are.
  bool _skipNextLookup = false;

  static String _token() {
    final r = Random.secure();
    return List.generate(
      16,
      (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _lookUp(widget.initial!);
      _checkPermission();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _goToMe(quiet: true));
    }
  }

  @override
  void dispose() {
    _settle?.cancel();
    _typing?.cancel();
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final p = await Geolocator.checkPermission();
    if (!mounted) return;
    setState(
      () => _canShowMe =
          p == LocationPermission.always || p == LocationPermission.whileInUse,
    );
  }

  /// Jump to the phone's location, asking for permission the first time.
  Future<void> _goToMe({bool quiet = false}) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    void say(String m) {
      if (!quiet) messenger.showSnackBar(SnackBar(content: Text(m)));
    }

    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        say(l.addrLocationOff);
        if (quiet) _searchFocus.requestFocus();
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        say(l.addrLocationDenied);
        if (quiet) _searchFocus.requestFocus();
        return;
      }
      if (mounted) setState(() => _canShowMe = true);
      // The last known fix is instant; the fresh one follows.
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) _moveTo(LatLng(last.latitude, last.longitude));
      final now = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      _moveTo(LatLng(now.latitude, now.longitude));
    } catch (_) {
      say(l.addrLocationOff);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _moveTo(LatLng at, {double zoom = 17.5}) {
    _target = at;
    final map = _map;
    if (map == null) {
      _lookUp(at);
      return;
    }
    map.animateCamera(CameraUpdate.newLatLngZoom(at, zoom));
  }

  /// The address under the pin. Older answers arriving late are dropped.
  Future<void> _lookUp(LatLng at) async {
    final id = ++_lookup;
    setState(() {
      _looking = true;
      _failed = false;
    });
    try {
      final found = await _repo.placeAt(at.latitude, at.longitude);
      if (!mounted || id != _lookup) return;
      setState(() {
        _found = found;
        _looking = false;
      });
    } catch (_) {
      if (!mounted || id != _lookup) return;
      setState(() {
        _looking = false;
        _failed = true;
        _found = null;
      });
    }
  }

  void _onCameraIdle() {
    setState(() => _moving = false);
    if (_skipNextLookup) {
      _skipNextLookup = false;
      return;
    }
    _settle?.cancel();
    _settle = Timer(const Duration(milliseconds: 350), () => _lookUp(_target));
  }

  void _onSearchChanged(String q) {
    _typing?.cancel();
    if (q.trim().length < 3) {
      setState(() => _suggestions = null);
      return;
    }
    _typing = Timer(const Duration(milliseconds: 350), () async {
      setState(() => _searching = true);
      try {
        final list = await _repo.searchPlaces(
          q.trim(),
          lat: _target == _india ? null : _target.latitude,
          lng: _target == _india ? null : _target.longitude,
          session: _session,
        );
        if (mounted && _search.text.trim() == q.trim()) {
          setState(() => _suggestions = list);
        }
      } catch (_) {
        if (mounted) setState(() => _suggestions = const []);
      } finally {
        if (mounted) setState(() => _searching = false);
      }
    });
  }

  Future<void> _pick(PlaceSuggestion s) async {
    _searchFocus.unfocus();
    setState(() {
      _suggestions = null;
      _search.text = s.title;
      _looking = true;
    });
    try {
      final found = await _repo.placeDetails(s.placeId, session: _session);
      if (!mounted) return;
      _skipNextLookup = true;
      _lookup++; // drop any pin lookup still on its way
      setState(() {
        _found = found;
        _looking = false;
        _failed = false;
      });
      _moveTo(LatLng(found.latitude, found.longitude));
    } catch (_) {
      if (mounted) {
        setState(() {
          _looking = false;
          _failed = true;
        });
      }
    }
  }

  void _confirm() {
    final f = _found;
    Navigator.of(context).pop(
      FoundPlace(
        line1: f?.line1 ?? '',
        line2: f?.line2 ?? '',
        city: f?.city ?? '',
        state: f?.state ?? '',
        postalCode: f?.postalCode ?? '',
        country: f?.country ?? 'IN',
        // The pin decides, even if the customer nudged it after picking a place.
        latitude: _target.latitude,
        longitude: _target.longitude,
        formatted: f?.formatted ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: brand.canvas,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _target,
                zoom: widget.initial != null ? 17.5 : 4.5,
              ),
              onMapCreated: (c) => _map = c,
              onCameraMoveStarted: () => setState(() => _moving = true),
              onCameraMove: (p) => _target = p.target,
              onCameraIdle: _onCameraIdle,
              myLocationEnabled: _canShowMe,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              padding: const EdgeInsets.only(bottom: 200),
            ),
          ),
          // The pin stays in the middle; it lifts while the map moves.
          Positioned.fill(
            bottom: 200,
            child: IgnorePointer(
              child: Center(
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 160),
                  offset: Offset(0, _moving ? -0.75 : -0.5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_moving)
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.inverseSurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            l.addrPinHint,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onInverseSurface,
                            ),
                          ),
                        ),
                      Icon(
                        Icons.location_on_rounded,
                        size: 48,
                        color: AstroPalette.money.end,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Back + search on top.
          Positioned(
            top: top + 8,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.surface,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _search,
                          focusNode: _searchFocus,
                          onChanged: _onSearchChanged,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: l.addrSearchHint,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (_searching)
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      else if (_search.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _search.clear();
                            setState(() => _suggestions = null);
                          },
                        ),
                    ],
                  ),
                ),
                if (_suggestions != null)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(blurRadius: 12, color: Color(0x22000000)),
                      ],
                    ),
                    child: _suggestions!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              l.addrSearchEmpty,
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: _suggestions!.length,
                            separatorBuilder: (_, _) =>
                                Divider(height: 1, color: brand.hairline),
                            itemBuilder: (_, i) {
                              final s = _suggestions![i];
                              return ListTile(
                                leading: Icon(
                                  Icons.place_outlined,
                                  color: brand.inkMuted,
                                ),
                                title: Text(
                                  s.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: s.subtitle.isEmpty
                                    ? null
                                    : Text(
                                        s.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                onTap: () => _pick(s),
                              );
                            },
                          ),
                  ),
              ],
            ),
          ),
          // "My location" above the card.
          Positioned(
            right: 16,
            bottom: 216,
            child: FloatingActionButton.small(
              heroTag: 'my-location',
              onPressed: _locating ? null : () => _goToMe(),
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: AstroPalette.money.end,
              tooltip: l.addrUseMyLocation,
              child: _locating
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location_rounded),
            ),
          ),
          // What's under the pin + confirm.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                18,
                20,
                16 + MediaQuery.paddingOf(context).bottom,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: const [
                  BoxShadow(blurRadius: 16, color: Color(0x22000000)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.addrOnMap,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 64,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: AstroPalette.money.end,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _pinText(context)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GoldButton(
                    label: l.addrConfirmLocation,
                    onPressed: _looking || _moving || _target == _india
                        ? null
                        : _confirm,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pinText(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    if (_looking || _moving) {
      return Text(
        l.addrLocating,
        style: theme.textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
      );
    }
    final f = _found;
    if (_failed || f == null || f.isEmpty) {
      return Text(
        _target == _india ? l.addrPinHint : l.addrNotFound,
        style: theme.textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          f.headline,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          f.formatted.isNotEmpty
              ? f.formatted
              : '${f.city}, ${f.state} ${f.postalCode}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: brand.inkMuted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
