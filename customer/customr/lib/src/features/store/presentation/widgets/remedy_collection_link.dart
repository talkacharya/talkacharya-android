import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/config/config_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../data/models/catalog.dart';
import '../../data/store_repository.dart';

/// "See remedies · Saturn (Shani) remedies ›" — under a dosha, a weak planet
/// or a running Sade Sati in the kundali: the store collection for it, one
/// tap away. [keys] are remedy keys (`saturn`, `sade_sati`, `kaal_sarpa`…);
/// the first one a live collection answers wins. Shows nothing when none
/// does, the store is off, or it cannot be reached.
class RemedyCollectionLink extends StatefulWidget {
  const RemedyCollectionLink({
    required this.keys,
    this.hue = AstroPalette.money,
    this.padding = const EdgeInsets.only(top: 10),
    super.key,
  });

  final List<String> keys;
  final AstroHue hue;
  final EdgeInsets padding;

  @override
  State<RemedyCollectionLink> createState() => _RemedyCollectionLinkState();
}

class _RemedyCollectionLinkState extends State<RemedyCollectionLink> {
  late final Future<Map<String, CollectionLink>> _keys = _load();

  Future<Map<String, CollectionLink>> _load() async {
    try {
      if (!getIt<ConfigRepository>().value.features.store) return const {};
      return await getIt<StoreRepository>().collectionKeys();
    } catch (_) {
      return const {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, CollectionLink>>(
      future: _keys,
      builder: (context, snap) {
        final map = snap.data;
        if (map == null) return const SizedBox.shrink();
        CollectionLink? link;
        for (final k in widget.keys) {
          link = map[k.toLowerCase()];
          if (link != null) break;
        }
        if (link == null) return const SizedBox.shrink();
        final target = link;
        final l = context.l10n;
        final theme = Theme.of(context);
        final hue = widget.hue;
        return Padding(
          padding: widget.padding,
          child: Material(
            color: hue.tint(0.10),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push(Routes.storeCollection(target.slug)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
                child: Row(
                  children: [
                    Icon(Icons.spa_rounded, size: 16, color: hue.end),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l.remedyLinkFor(target.title),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: hue.end,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 18, color: hue.end),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
