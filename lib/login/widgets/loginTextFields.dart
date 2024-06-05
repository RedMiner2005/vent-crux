import 'package:flutter/material.dart';

enum LoginFieldType {
  phone,
  code
}

class LoginField extends StatelessWidget {
  const LoginField({super.key, required this.onChanged, required this.fieldType});

  final Function(String text) onChanged;
  final LoginFieldType fieldType;

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[500]),
        hintText: (fieldType == LoginFieldType.phone) ? "Phone" : "Code",
        fillColor: (isLightMode) ? Colors.white70 : Colors.white10,
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
