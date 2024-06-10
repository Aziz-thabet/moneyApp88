// ignore_for_file: camel_case_types
import 'package:Money_manager/home_Page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const moneyApp88());
}

class moneyApp88 extends StatelessWidget {
  const moneyApp88({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
