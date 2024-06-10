import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/views/contactDialog.dart';
import 'package:vent/home/widgets/widgets.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: OpenContainer<String?>(
        tappable: false,
        transitionType: ContainerTransitionType.fade,
        transitionDuration: 500.ms,
        onClosed: cubit.onContactClosed,
        openColor: Theme.of(context).colorScheme.primaryContainer,
        middleColor: Theme.of(context).colorScheme.primaryContainer,
        closedColor: Theme.of(context).colorScheme.primaryContainer,
        closedElevation: 10.0,
        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        closedBuilder: (context, openDialog) {
          return Container(
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 100,
                    width: 300,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ExtrasButton(cubit: cubit),
                      VoiceButton(cubit: cubit),
                      SendButton(cubit: cubit, openDialog: openDialog),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        openBuilder: (context, closeDialog) {
          return ContactDialog(cubit: cubit, closeDialog: closeDialog);
        },
      ).animate().slideY(begin: (cubit.state.doIntroAnimationHome) ? 1.2 : 0.0, curve: Curves.easeOutQuad),
    );
  }
}
