import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:vent/login/widgets/widgets.dart';
import 'package:vent/src/config.dart';


class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  late Timer _timer;
  int _counter = Random().nextInt(VentConfig.loadingTexts.length);



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 16.0),
            child: StatusText(
                texts: VentConfig.loadingTexts.asMap(),
                current: (_counter % VentConfig.loadingTexts.length)
            ),
          ),
          SizedBox(height: 8.0,),
          AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                return SpinKitThreeBounce(
                  itemBuilder: (context, index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: VentConfig.rainbowSpectrum[(2.0*index + animation.value) % VentConfig.rainbowSpectrum.rangeEnd],
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }
          )
        ],
      ).animate().fade(),
    );
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _counter++;
      });
    });

    _controller =
        AnimationController(duration: VentConfig.animationLoadingTextDuration, vsync: this);

    animation = Tween<double>(
        begin: VentConfig.rainbowSpectrum.rangeStart.toDouble(), end: VentConfig.rainbowSpectrum.rangeEnd.toDouble())
        .animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}

