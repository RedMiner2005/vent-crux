import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vent/app/widgets/statusText.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/widgets/notificationsButton.dart';
import 'package:vent/src/config.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key, required this.pageController, required this.cubit});

  final PageController pageController;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              VentConfig.greetingText,
              style: TextStyle(
                  fontFamily: VentConfig.headingFont,
                  fontSize: 60.0,
                  height: 1.2
              ),
            ).animate()
                .fade(
                  delay: (cubit.state.doIntroAnimationHome) ? 300.ms : 0.ms,
                  duration: (cubit.state.doIntroAnimationHome) ? VentConfig.animationDuration : 0.ms
                )
                .shimmer(
                  delay: (cubit.state.doIntroAnimationHome) ? 300.ms : 0.ms,
                  duration: (cubit.state.doIntroAnimationHome) ? VentConfig.animationDuration : 0.ms
                ),
            NotificationsButton(pageController: pageController)
              .animate()
              .fade(
                delay: (cubit.state.doIntroAnimationHome) ? 300.ms : 0.ms,
                duration: (cubit.state.doIntroAnimationHome) ? VentConfig.animationDuration : 0.ms
              )
          ],
        ),
        StatusTextRaw(
          child: Container(
            width: 250.0,
            height: 70.0,
            child: Text(
              cubit.state.message,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            key: ValueKey<String>(cubit.state.message),
          ),
        ).animate().fade(
            delay: (cubit.state.doIntroAnimationHome) ? 900.ms : 0.ms,
            duration: (cubit.state.doIntroAnimationHome) ? VentConfig.animationDuration : 0.ms
          ),
      ],
    );
  }
}
