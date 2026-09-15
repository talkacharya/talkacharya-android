import 'package:flutter/material.dart';

/// App-wide navigation motion.
///
/// Two deliberate transitions, applied consistently:
///
/// * **Pushing a screen** (detail pages, wallet, chats, kundali, …) —
///   [SlideFadePageTransitionsBuilder]: the new screen slides in from the
///   trailing edge with a short fade while the one below eases back a touch.
///   Popping reverses it automatically (Flutter drives `secondaryAnimation`).
///   Wired in once via `ThemeData.pageTransitionsTheme`, so every go_router
///   `builder:` route (which produces a `MaterialPage`) gets it for free.
///
/// * **Switching bottom-nav tabs** — [AnimatedBranchContainer]: a straight
///   cross-fade between branch navigators, each branch keeping its own state
///   and scroll position. Used by the shell's `navigatorContainerBuilder`.
///
/// Both honour the platform "reduce motion" setting: transitions collapse to a
/// plain fade (or an instant cut for tab switches).

const Duration _kTabFadeDuration = Duration(milliseconds: 220);

/// Slide-from-trailing-edge + fade for pushed routes. Registered for every
/// platform in [ThemeData.pageTransitionsTheme].
class SlideFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const SlideFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) {
      return FadeTransition(opacity: animation, child: child);
    }

    // Incoming page: slide in from the trailing edge + fade in early.
    final enterOffset = Tween<Offset>(
      begin: const Offset(0.22, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

    final enterFade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, 0.65, curve: Curves.easeOut),
      reverseCurve: const Interval(0.35, 1, curve: Curves.easeIn),
    );

    // Outgoing page (the one underneath): eases back a little for depth.
    final exitOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.08, 0),
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(secondaryAnimation);

    return SlideTransition(
      position: exitOffset,
      child: SlideTransition(
        position: enterOffset,
        child: FadeTransition(opacity: enterFade, child: child),
      ),
    );
  }
}

/// Convenience: the same [SlideFadePageTransitionsBuilder] for every platform.
const PageTransitionsTheme kAppPageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: SlideFadePageTransitionsBuilder(),
    TargetPlatform.iOS: SlideFadePageTransitionsBuilder(),
    TargetPlatform.linux: SlideFadePageTransitionsBuilder(),
    TargetPlatform.macOS: SlideFadePageTransitionsBuilder(),
    TargetPlatform.windows: SlideFadePageTransitionsBuilder(),
    TargetPlatform.fuchsia: SlideFadePageTransitionsBuilder(),
  },
);

/// Cross-fades the bottom-nav branch navigators. Drop-in for
/// `StatefulShellRoute(navigatorContainerBuilder: …)` — replaces the instant
/// `IndexedStack` swap of `StatefulShellRoute.indexedStack`.
///
/// Every branch stays mounted (so its navigator stack + scroll offsets
/// survive); only opacity, hit-testing and ticker state follow the active
/// index. Follows the canonical go_router "AnimatedBranchContainer" recipe.
class AnimatedBranchContainer extends StatelessWidget {
  const AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
    super.key,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        for (var i = 0; i < children.length; i++)
          _branch(i, children[i], reduceMotion),
      ],
    );
  }

  Widget _branch(int index, Widget navigator, bool reduceMotion) {
    final active = index == currentIndex;
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: active ? 1 : 0,
        duration: reduceMotion ? Duration.zero : _kTabFadeDuration,
        curve: Curves.easeOut,
        child: IgnorePointer(
          ignoring: !active,
          child: TickerMode(enabled: active, child: navigator),
        ),
      ),
    );
  }
}
