import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The room's cosmic header: back, who you are talking to, and what this
/// chat is (a free line, answered when they can).
class AssistantRoomHeader extends StatelessWidget {
  const AssistantRoomHeader({
    required this.name,
    required this.subtitle,
    this.avatar,
    this.onTapName,
    this.actions = const [],
    super.key,
  });

  final String name;
  final String subtitle;
  final String? avatar;
  final VoidCallback? onTapName;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
        child: Stack(
          children: [
            const Positioned.fill(child: CosmicBackdrop()),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 8, 12),
                child: Row(
                  children: [
                    BackButton(color: brand.onCosmic),
                    Expanded(
                      child: InkWell(
                        onTap: onTapName,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              HueAvatar(
                                name: name,
                                url: avatar,
                                hue: AstroPalette.career,
                                size: 40,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: brand.onCosmic,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    Text(
                                      subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: brand.onCosmicMuted,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ...actions,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
