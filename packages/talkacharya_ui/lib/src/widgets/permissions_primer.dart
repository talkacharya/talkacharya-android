import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/astro_palette.dart';
import '../theme/brand_colors.dart';
import 'cosmic.dart';
import 'hue_widgets.dart';
import 'pressable.dart';

/// One thing the app asks to be allowed, with why.
class PrimerItem {
  const PrimerItem({
    required this.icon,
    required this.hue,
    required this.title,
    required this.why,
  });

  final IconData icon;
  final AstroHue hue;
  final String title;
  final String why;
}

/// The words on the page; each app passes its own, in its own language.
class PrimerStrings {
  const PrimerStrings({
    required this.title,
    required this.body,
    required this.allow,
    required this.later,
    required this.done,
    required this.openSettings,
    required this.allowed,
    required this.blockedNote,
  });

  final String title;
  final String body;
  final String allow;
  final String later;
  final String done;
  final String openSettings;
  final String allowed;

  /// Shown once something was refused: how to turn it on later.
  final String blockedNote;
}

/// The first-run screen that asks for everything the app needs in one go:
/// what each permission is for, one button that walks through the system
/// dialogs, and a tick on each as it is allowed.
///
/// It knows nothing about permissions itself: [load] says which of [items]
/// are already allowed (same order), [request] asks for the rest and says
/// where each ended up.
class PermissionsPrimerPage extends StatefulWidget {
  const PermissionsPrimerPage({
    required this.items,
    required this.strings,
    required this.load,
    required this.request,
    required this.openSettings,
    super.key,
  });

  final List<PrimerItem> items;
  final PrimerStrings strings;
  final Future<List<bool>> Function() load;
  final Future<List<bool>> Function() request;
  final Future<void> Function() openSettings;

  @override
  State<PermissionsPrimerPage> createState() => _PermissionsPrimerPageState();
}

class _PermissionsPrimerPageState extends State<PermissionsPrimerPage>
    with WidgetsBindingObserver {
  late List<bool> _granted = List.filled(widget.items.length, false);
  bool _asked = false;
  bool _busy = false;

  bool get _all => _granted.every((g) => g);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Back from system settings: see what they turned on there.
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final now = await widget.load();
    if (mounted) setState(() => _granted = now);
  }

  Future<void> _allow() async {
    setState(() => _busy = true);
    final now = await widget.request();
    if (!mounted) return;
    setState(() {
      _granted = now;
      _asked = true;
      _busy = false;
    });
    // Everything allowed: nothing left to read here.
    if (_all) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = widget.strings;
    const goldInk = Color(0xFF3A1703);
    final blocked = _asked && !_all;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.cosmicStart,
        body: Stack(
          children: [
            const Positioned.fill(child: CosmicBackdrop()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: BrandColors.goldGradient,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: BrandColors.goldGradient.last
                                        .withValues(alpha: 0.45),
                                    blurRadius: 28,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.verified_user_rounded,
                                size: 40,
                                color: goldInk,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            s.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: brand.onCosmic,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s.body,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: brand.onCosmicMuted,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 22),
                          for (final (i, item) in widget.items.indexed)
                            _ItemCard(
                              item: item,
                              granted: _granted[i],
                              allowedLabel: s.allowed,
                            ),
                          if (blocked)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                s.blockedNote,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: brand.onCosmicMuted,
                                  height: 1.4,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Pressable(
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: _busy
                              ? null
                              : _all
                              ? () => Navigator.of(context).maybePop()
                              : blocked
                              ? widget.openSettings
                              : _allow,
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: BrandColors.goldGradient,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: BrandColors.goldGradient.last
                                      .withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _busy
                                  ? const SizedBox.square(
                                      dimension: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: goldInk,
                                      ),
                                    )
                                  : Text(
                                      _all
                                          ? s.done
                                          : blocked
                                          ? s.openSettings
                                          : s.allow,
                                      style: const TextStyle(
                                        color: goldInk,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!_all)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: brand.onCosmicMuted,
                        ),
                        onPressed: _busy
                            ? null
                            : () => Navigator.of(context).maybePop(),
                        child: Text(s.later),
                      ),
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

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.granted,
    required this.allowedLabel,
  });

  final PrimerItem item;
  final bool granted;
  final String allowedLabel;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: granted
            ? brand.online.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: granted
              ? brand.online.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          HueIcon(hue: item.hue, icon: item.icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: brand.onCosmic,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  granted ? allowedLabel : item.why,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.onCosmicMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            granted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: granted
                ? brand.online
                : Colors.white.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}
