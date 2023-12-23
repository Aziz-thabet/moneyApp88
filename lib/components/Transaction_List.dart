// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:many/models/TransactionModel.dart';
import 'package:many/pags/CustomColumn.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final ScrollController scrollController;
  final Color CircleAvatarColor;
  final void Function(int) onDelete;

  const TransactionList(this.transactions,
      {super.key,
      required this.scrollController,
      required this.CircleAvatarColor,
        required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return CustomColumn(
        transactions: transactions,
        scrollController: scrollController,
        circleAvatarColor: CircleAvatarColor,
      onDelete: onDelete,);
  }
}
