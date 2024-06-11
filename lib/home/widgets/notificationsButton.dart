import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/home/widgets/customTooltip.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/authService.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthenticationService>();
    return StreamBuilder(
        stream: authService.unreadCount,
        builder: (context, unread) {
          final button = CustomTooltip(
            message: (unread.data == 0 || unread.data == null) ? "Inbox" : "Inbox (${unread.data})",
            preferBelow: true,
            child: IconButton(
              icon: Icon(
                (unread.data == 0 || unread.data == null) ? Icons.inbox_outlined : Icons.inbox_rounded,
                size: 32,
              ),
              onPressed: () {
                pageController.nextPage(
                  duration: VentConfig.animationPageSwipeDuration,
                  curve: Curves.easeInOut,
                );
              },
            ),
          );
          return (unread.data == 0 || unread.data == null) ? button : Badge(
            offset: const Offset(2.0, 2.0),
            label: Text("${unread.data}"),
            child: button,
          );
        }
    );
  }
}
