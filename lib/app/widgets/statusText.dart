import 'package:flutter/material.dart';
import 'package:vent/src/config.dart';

class StatusText extends StatelessWidget {
  const StatusText({super.key, required this.texts, required this.current, this.style, this.textAlign});

  final Map<dynamic, String> texts;
  final dynamic current;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return StatusTextRaw(
      child: Text(
        texts[current] ?? "",
        softWrap: true,
        style: style,
        textAlign: textAlign ?? TextAlign.center,
        key: ValueKey(current),
      ),
    );
  }
}

class StatusTextRaw extends StatelessWidget {
  const StatusTextRaw({super.key, required this.child});

  final Widget child;

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
      child: child,
    );
  }
}