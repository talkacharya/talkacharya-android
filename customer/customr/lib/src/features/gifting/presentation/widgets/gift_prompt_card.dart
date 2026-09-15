import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../data/models/gift.dart';
import '../view/gift_sheet.dart';
import 'gift_art.dart';

/// "Say thanks with a gift" card — the post-session entry point. Flips to a
/// thank-you line once a gift has gone out from it.
class GiftPromptCard extends StatefulWidget {
  const GiftPromptCard({required this.target, super.key});

  final GiftTarget target;

  @override
  State<GiftPromptCard> createState() => _GiftPromptCardState();
}

class _GiftPromptCardState extends State<GiftPromptCard> {
  GiftTransaction? _sent;

  static const _preview = [
    ('rose', 'flower'),
    ('diya', 'blessing'),
    ('marigold-garland', 'flower'),
    ('gold-crown', 'premium'),
  ];

  Future<void> _open() async {
    final sent = await showGiftSheet(context, target: widget.target);
    if (sent != null && mounted) setState(() => _sent = sent);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final name = widget.target.astrologerName;

    return Pressable(
      child: Material(
        color: brand.tint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _open,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                SizedBox(
                  width: 76,
                  height: 44,
                  child: Stack(
                    children: [
                      for (var i = 0; i < _preview.length; i++)
                        Positioned(
                          left: i * 11.0,
                          top: i.isEven ? 0 : 6,
                          child: GiftArt(
                            slug: _preview[i].$1,
                            category: _preview[i].$2,
                            size: 34,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _sent == null
                            ? l.giftThankYouTitle
                            : l.giftThankYouSentTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: brand.onTint,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _sent == null
                            ? l.giftThankYouBody(name)
                            : l.giftSentTitle(_sent!.giftName, name),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _sent == null
                      ? Icons.chevron_right_rounded
                      : Icons.favorite_rounded,
                  color: _sent == null
                      ? brand.inkMuted
                      : BrandColors.goldGradient.last,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
