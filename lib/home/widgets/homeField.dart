import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vent/home/cubit/home_cubit.dart';

import '../../src/config.dart';

class HomeTextField extends StatefulWidget {
  const HomeTextField({super.key, required this.textEditingController, required this.focusNode, required this.cubit});

  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final HomeCubit cubit;

  @override
  State<HomeTextField> createState() => _HomeTextFieldState();
}

class _HomeTextFieldState extends State<HomeTextField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(widget.cubit.state.isFieldEmpty) DefaultTextStyle(
          softWrap: true,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.grey[500],
            fontFamily: VentConfig.bodyVentFont,
            fontSize: 32,
            height: 1.0
          ),
          child: AnimatedTextKit(
            repeatForever: false,
            totalRepeatCount: 1,
            pause: (widget.cubit.state.doIntroAnimationHome) ?  1500.ms : 0.ms,
            animatedTexts: [
              TyperAnimatedText(""),
              TyperAnimatedText('Type out your vent here, or speak away.'),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                controller: widget.textEditingController,
                decoration: InputDecoration.collapsed(hintText: ""),
                textCapitalization: TextCapitalization.sentences,
                scrollPadding: EdgeInsets.all(20.0),
                scrollPhysics: BouncingScrollPhysics(),
                keyboardType: TextInputType.text,
                cursorWidth: 3.0,
                cursorRadius: Radius.circular(5.0),
                cursorColor: VentConfig.brandingColor,
                onChanged: widget.cubit.onHomeFieldChanged,
                minLines: 2,
                maxLines: 12,
                maxLength: 200,
                style: TextStyle(
                    fontFamily: VentConfig.bodyVentFont,
                    fontSize: 32,
                    height: 1.0
                ),
              ).animate().fade(delay: (widget.cubit.state.doIntroAnimationHome) ?  1500.ms : 0.ms, duration: (widget.cubit.state.doIntroAnimationHome) ?  VentConfig.animationDuration : 0.ms),
            ),
          ],
        )
      ],
    );
  }
}
