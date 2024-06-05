import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StatusText extends StatelessWidget {
  const StatusText({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 400.ms,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeInExpo,
      transitionBuilder:
          (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0
          ).animate(animation),
          child: SlideTransition(
            child: child,
            position: Tween<Offset>(
                begin: Offset(0.0, 0.5),
                end: Offset(0.0, 0.0))
                .animate(animation),
          ),
        );
      },
      child: child,
    );
  }
}
