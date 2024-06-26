import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ColorText extends StatefulWidget {
  const ColorText(
      String text,
      {
        this.key,
        TextStyle? style,
      }
  ) : style = style ?? const TextStyle(fontSize: 72.0),
      text = text,
        super(key: key);

  final Key? key;
  final String text;
  final TextStyle style;

  @override
  _ColorTextState createState() => _ColorTextState();
}

class _ColorTextState extends State<ColorText> {
  bool isAnimationOver = false;

  @override
  Widget build(BuildContext context) {
    return (!isAnimationOver) ? AnimatedTextKit(
      pause: 200.ms,
      animatedTexts: [
        ColorizeAnimatedText(
            "",
            colors: [Colors.transparent, Colors.transparent],
            textStyle: widget.style,
            speed: 0.ms
        ),
        ColorizeAnimatedText(
          widget.text,
          colors: [
            (Theme.of(context).brightness == Brightness.light) ? Colors.black87 : Colors.white,
            Colors.indigo,
            Colors.blue,
            Colors.teal,
            Colors.green,
            Colors.pink,
            Colors.purple,
            Colors.transparent,
            Colors.transparent,
            Colors.transparent,
          ],
          textStyle: widget.style,
          speed: 1000.ms,
        ),
      ],
      totalRepeatCount: 1,
      repeatForever: false,
      onFinished: () {
        setState(() {
          isAnimationOver = true;
        });
      },
    )
    : Text(
      widget.text,
      style: widget.style,
    );
  }
}