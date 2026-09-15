import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../data/birth_profiles_repository.dart';
import '../../../data/models/place.dart';

/// Birth-place picker: type to search `GET /app/places/search` (debounced),
/// pick a result. Reports the chosen [Place] via [onSelected].
class PlaceSearchField extends StatefulWidget {
  const PlaceSearchField({
    required this.onSelected,
    this.initialText = '',
    this.labelText,
    this.hintText,
    super.key,
  });

  final ValueChanged<Place?> onSelected;
  final String initialText;

  /// Defaults to the birth-place wording; other pickers (panchang city) override.
  final String? labelText;
  final String? hintText;

  @override
  State<PlaceSearchField> createState() => _PlaceSearchFieldState();
}

class _PlaceSearchFieldState extends State<PlaceSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );
  Timer? _debounce;
  List<Place> _results = const [];
  bool _loading = false;
  Place? _selected;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (_selected != null) {
      _selected = null;
      widget.onSelected(null);
    }
    if (value.trim().length < 2) {
      setState(() => _results = const []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    try {
      final results = await getIt<BirthProfilesRepository>().searchPlaces(
        query,
      );
      if (mounted) setState(() => _results = results);
    } catch (_) {
      if (mounted) setState(() => _results = const []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _pick(Place place) {
    setState(() {
      _selected = place;
      _results = const [];
      _controller.text = place.name;
    });
    FocusScope.of(context).unfocus();
    widget.onSelected(place);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: widget.labelText ?? 'Birth place',
            hintText: widget.hintText ?? 'City, town or village',
            prefixIcon: const Icon(Icons.location_on_outlined),
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_selected != null
                      ? Icon(Icons.check_circle_rounded, color: scheme.primary)
                      : null),
          ),
        ),
        if (_results.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (final p in _results)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.place_outlined, size: 20),
                    title: Text(p.name),
                    onTap: () => _pick(p),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
