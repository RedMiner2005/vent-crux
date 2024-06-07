import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/repository/authService.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthenticationService>();
    return StreamBuilder(
        stream: authService.unreadCount,
        builder: (context, unread) {
          final button = IconButton(
            icon: Icon(
              (unread.data == 0 || unread.data == null) ? Icons.notifications_none_rounded : Icons.notifications_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              authService.clearUnread();
            },
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
