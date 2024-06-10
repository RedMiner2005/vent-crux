import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/widgets/customTooltip.dart';
import 'package:vent/src/config.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    if (!widget.cubit.state.isRecording) {
      _animationController.stop();
      _animationController.reset();
    } else {
      _animationController.forward();
    }
    final lerp = (VentConfig.rainbowSpectrum.rangeStart.toDouble() + (0.5) * (Random().nextDouble() + animation.value) * (VentConfig.rainbowSpectrum.rangeEnd.toDouble() - VentConfig.rainbowSpectrum.rangeStart.toDouble())) % VentConfig.rainbowSpectrum.rangeEnd;
    return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Container(
            width: 110.0,
            height: 110.0,
            child: Material(
              color: (!widget.cubit.state.isRecording) ? Colors.transparent : VentConfig.rainbowSpectrum[lerp],
              shape: StarBorder(
                  pointRounding: 0.8,
                  valleyRounding: 0.2,
                  points: 8,
                  rotation: animation.value * 720
              ),
              clipBehavior: Clip.antiAlias,
              child: CustomTooltip(
                message: "Voice Input",
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: widget.cubit.onVoiceButtonPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      (!widget.cubit.state.isRecording) ? Icons.mic_none_rounded : Icons.stop_rounded,
                      size: 32.0,
                      color: (widget.cubit.state.isRecording) ? Colors.white : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  @override
  void initState() {
    _animationController =
        AnimationController(duration: VentConfig.animationLoadingTextDuration * 15, vsync: this);

    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
