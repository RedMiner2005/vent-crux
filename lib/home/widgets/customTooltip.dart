import 'package:flutter/material.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip({super.key, this.message, this.child, this.preferBelow=false});

  final String? message;
  final Widget? child;
  final bool preferBelow;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      verticalOffset: 50.0,
      child: child,
    );
  }
}
