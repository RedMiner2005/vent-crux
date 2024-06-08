import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart' as libPhone;
import 'package:go_router/go_router.dart';

class ContactDialog extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;

  const ContactDialog({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Who do you want to vent to?'),
      content: Container(
        height: 200,
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(contacts[index]["name"]),
              subtitle: Text(libPhone.formatNumberSync(contacts[index]["phone"])),
              onTap: () {
                context.pop(contacts[index]["hash"]);
              },
            );
          },
        ),
      ),
    );
  }
}