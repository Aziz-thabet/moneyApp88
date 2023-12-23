// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget buildTextField(String labelText, TextEditingController controller,
    {TextInputType? keyboardType}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText),
      keyboardType: keyboardType,
    ),
  );
}