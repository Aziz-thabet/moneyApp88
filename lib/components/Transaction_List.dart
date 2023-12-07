
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:many/models/TransactionModel.dart';
import 'package:many/pags/CustomColumn.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final ScrollController scrollController;

  const TransactionList(this.transactions,
      {Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomColumn(transactions: transactions, scrollController: scrollController);
  }
}
