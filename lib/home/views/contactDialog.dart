import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart' as libPhone;
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/widgets/widgets.dart';

class ContactDialog extends StatelessWidget {
  // final List<Map<String, dynamic>> contacts;
  final HomeCubit cubit;
  final Function closeDialog;

  const ContactDialog({Key? key, required this.cubit, required this.closeDialog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contacts = cubit.contactsMatch;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: Container(
          child: ContactsTitle(cubit: cubit, closeDialog: closeDialog,),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (contacts.isEmpty) Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 48.0, 32.0, 16.0),
                  child: Icon(Icons.person_search_rounded, size: 72.0,),
                )
            ),
            if (contacts.isEmpty) Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 48.0),
                child: Text("No contacts to send vents to. Go on, invite your friends to use this app :)", textAlign: TextAlign.center,),
              ),
            ),
            if (contacts.isNotEmpty) Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      title: Text(contacts[index]["name"]),
                      subtitle: Text(libPhone.formatNumberSync(contacts[index]["phone"])),
                      onTap: () {
                        Navigator.of(context).pop(contacts[index]["hash"]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}