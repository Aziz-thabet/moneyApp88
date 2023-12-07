
// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:many/models/TransactionModel.dart';
import 'package:intl/intl.dart';

class CustomColumn extends StatelessWidget {
  const CustomColumn({
    super.key,
    required this.transactions,
    required this.scrollController,
  });

  final List<Transaction> transactions;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        transactions.isEmpty
            ? const Center(
          child: Text(
            'ليس هناك عمليات حتى الآن.',
            style: TextStyle(fontSize: 25),
          ),
        )
            : ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: transactions.length,
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: FittedBox(
                      child: Text('${transactions[index].amount}'),
                    ),
                  ),
                ),
                title: Text(
                  transactions[index].name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(transactions[index].date),
                    ),
                    const Text(
                      'التفاصيل الإضافية هنا',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}