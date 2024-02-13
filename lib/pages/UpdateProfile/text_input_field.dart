//Yara Mohamed

import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String labelText;
  final String? initialValue;
  final TextEditingController? controller;

  const TextInputField({
    Key? key,
    required this.labelText,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
