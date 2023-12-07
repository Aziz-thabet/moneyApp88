// ignore_for_file: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Category extends StatelessWidget {
  const Category(
      {super.key, required this.text, required this.color, this.onTap});
  final String? text;
  final Color? color;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 60,
            width: 120,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                text!,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
