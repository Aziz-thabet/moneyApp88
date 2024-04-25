// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:Money_manager/models/TransactionModel.dart';
import 'package:Money_manager/pags/CustomColumn.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final ScrollController scrollController;
  final Color CircleAvatarColor;
  final void Function(int) onDelete;
  final void Function(int) onEdite;

  const TransactionList(this.transactions,
      {super.key,
      required this.scrollController,
      required this.CircleAvatarColor,
      required this.onDelete,
      required this.onEdite});

  @override
  Widget build(BuildContext context) {
    return CustomColumn(
      transactions: transactions,
      scrollController: scrollController,
      circleAvatarColor: CircleAvatarColor,
      onDelete: onDelete,
      onEdit: onEdite,
    );
  }
}
