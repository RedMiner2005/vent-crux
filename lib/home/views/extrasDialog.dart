import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vent/src/config.dart';

class ExtrasDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const ExtrasDialog({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          VentConfig.appName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: VentConfig.brandingFont,
            fontSize: 36.0
          )
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("By: " + VentConfig.appAuthor, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(VentConfig.appCredits, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
      actions: <Widget>[
        FloatingActionButton.extended(
          elevation: 0.0,
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    ).animate()
        .fade()
        .slideY(begin: 0.05, curve: Curves.easeOut);
  }
}