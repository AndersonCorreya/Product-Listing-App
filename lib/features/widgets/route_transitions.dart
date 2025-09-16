import 'package:flutter/material.dart';

PageRoute<T> slideRightToLeftRoute<T>(
  Widget page, {
  Duration duration = const Duration(milliseconds: 280),
}) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final CurvedAnimation curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: curved.drive(Tween<double>(begin: 0.6, end: 1.0)),
          child: child,
        ),
      );
    },
  );
}

PageRoute<T> slideLeftToRightRoute<T>(
  Widget page, {
  Duration duration = const Duration(milliseconds: 280),
}) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final CurvedAnimation curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: curved.drive(Tween<double>(begin: 0.6, end: 1.0)),
          child: child,
        ),
      );
    },
  );
}
