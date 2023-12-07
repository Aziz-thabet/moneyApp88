// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TotalAmountWidget extends StatelessWidget {
  final double total;
  final Color color;

  const TotalAmountWidget(this.total, {Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:color ,
      padding: const EdgeInsets.only(left: 150),
      child: Text(
        'الاجمالي : ${total.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 30),
      ),
    );
  }
}
