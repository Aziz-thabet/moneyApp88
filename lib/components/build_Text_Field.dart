// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget buildTextField(String labelText, TextEditingController controller,
    {TextInputType? keyboardType}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: labelText),
    keyboardType: keyboardType,
  );
}