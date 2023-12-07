// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:many/components/Custom_FloatingAction_Button.dart';
import 'package:many/components/totalAmount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;

class SavingsPage extends StatefulWidget {
  const SavingsPage({Key? key}) : super(key: key);

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _addTransaction(String name, double amount) {
    setState(() {
      _transactions
          .add(Transaction(name: name, amount: amount, date: DateTime.now()));
      _nameController.clear();
      _amountController.clear();
      _saveTransactions();
    });
  }

  double _getTotalAmount() {
    double total = 0.0;
    for (var transaction in _transactions) {
      total += transaction.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffff5500),
        title: const Text('الادخار'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TotalAmountWidget(
              _getTotalAmount(),
              color: Colors.deepOrange.shade300,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'الاسم'),
                  ),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'المبلغ'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text;
                      double amount = double.parse(_amountController.text);
                      if (name.isNotEmpty && amount > 0) {
                        _addTransaction(name, amount);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffff5500),
                    ),
                    child: const Text('إضافة',
                      style: TextStyle(color: Colors.black, fontSize: 25),),
                  ),
                ],
              ),
            ),
            TransactionList(_transactions),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = _transactions.map((t) {
      return {
        'name': t.name,
        'amount': t.amount,
        'date': t.date.toIso8601String(),
      };
    }).toList();
    prefs.setStringList('savings_transactions',
        transactions.map((t) => json.encode(t)).toList());
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsData = prefs.getStringList('savings_transactions');
    if (transactionsData != null) {
      final transactions = transactionsData.map((t) {
        final Map<String, dynamic> data = json.decode(t);
        return Transaction(
          name: data['name'],
          amount: data['amount'],
          date: DateTime.parse(data['date']),
        );
      }).toList();
      setState(() {
        _transactions.addAll(transactions);
      });
    }
  }
}

class Transaction {
  final String name;
  final double amount;
  final DateTime date;

  Transaction({required this.name, required this.amount, required this.date});
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList(this.transactions, {Key? key}) : super(key: key);

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
