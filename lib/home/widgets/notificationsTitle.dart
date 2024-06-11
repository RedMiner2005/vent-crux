import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/src/config.dart';

class NotificationsTitle extends StatelessWidget {
  const NotificationsTitle({super.key, required this.pageController, required this.cubit});

  final PageController pageController;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  size: 32.0,
                ),
                onPressed: () {
                  pageController.previousPage(
                    duration: VentConfig.animationPageSwipeDuration,
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Text(
              "Inbox",
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
          ],
        ),
      ),
    );
  }
}
