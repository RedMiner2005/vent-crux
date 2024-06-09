import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vent/src/config.dart';

class StatusText extends StatelessWidget {
  const StatusText({super.key, required this.texts, required this.current, this.style});

  final Map<dynamic, String> texts;
  final dynamic current;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: VentConfig.animationStatusText,
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
      child: Text(
        texts[current] ?? "",
        softWrap: true,
        style: style,
        textAlign: TextAlign.center,
        key: ValueKey(current),
      ),
    );
  }
}
