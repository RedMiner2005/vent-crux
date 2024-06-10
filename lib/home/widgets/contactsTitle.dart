import 'package:flutter/material.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/src/config.dart';

class ContactsTitle extends StatelessWidget {
  const ContactsTitle({super.key, required this.cubit, required this.closeDialog});

  final HomeCubit cubit;
  final Function closeDialog;

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
                  Icons.close_rounded,
                  size: 32.0,
                ),
                onPressed: () {
                  closeDialog();
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contacts",
                  style: TextStyle(
                      fontFamily: VentConfig.headingFont,
                      fontSize: 60.0,
                      height: 1.2
                  ),
                ),
                Text(
                  "Choose who to send the vent to",
                  style: TextStyle(
                      fontSize: 12.0,
                      height: 1.2
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
