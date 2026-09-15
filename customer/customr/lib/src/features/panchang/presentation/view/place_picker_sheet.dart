import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../birthprofiles/presentation/view/widgets/place_search_field.dart';
import '../../data/models/day_panchang.dart';

/// City picker for the panchang. Resolves with the chosen place, or `null`.
/// [suggestion] (usually the birth city) is offered as a one-tap choice.
Future<PanchangPlace?> showPanchangPlacePicker(
  BuildContext context, {
  PanchangPlace? suggestion,
}) {
  final l = context.l10n;
  return showAppSheet<PanchangPlace>(
    context: context,
    title: l.panchangChoosePlaceTitle,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.panchangChoosePlaceBody,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        if (suggestion != null) ...[
          ActionChip(
            avatar: Icon(
              Icons.home_rounded,
              size: 18,
              color: AstroPalette.money.end,
            ),
            label: Text(l.panchangUsePlace(suggestion.name)),
            onPressed: () => Navigator.pop(context, suggestion),
          ),
          const SizedBox(height: 8),
        ],
        PlaceSearchField(
          labelText: l.panchangCity,
          hintText: l.panchangCityHint,
          onSelected: (place) {
            if (place == null) return;
            Navigator.pop(
              context,
              PanchangPlace(
                name: place.name,
                latitude: place.latitude,
                longitude: place.longitude,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    ),
  );
}
