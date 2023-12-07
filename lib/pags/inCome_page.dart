// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, file_names

import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:many/components/Transaction_List.dart';
import 'package:many/components/totalAmount.dart';
import 'package:many/models/TransactionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/Custom_FloatingAction_Button.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({Key? key}) : super(key: key);

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    _saveTransactions(); // حفظ الصفقات قبل الخروج من التطبيق
    super.dispose();
  }

  void _addTransaction(String name, double amount) {
    setState(() {
      _transactions.add(Transaction(
        name: name,
        amount: amount,
        date: DateTime.now(),
      ));
      _nameController.clear();
      _amountController.clear();
      _saveTransactions();
    });
  }

  double _getTotalAmount() {
    return _transactions.fold(
        0.0, (total, transaction) => total + transaction.amount);
  }

  String type = 'income';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff48c659),
        title: const Text('الدخل'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TotalAmountWidget(
              _getTotalAmount(),
              color: Colors.greenAccent,
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(child: buildChoiceChip(' اساسي', ' اساسي')),
                        const SizedBox(width: 10.0),
                        Expanded(child: buildChoiceChip(' اضافي', ' اضافي')),
                        const SizedBox(width: 10),
                        Expanded(child: buildChoiceChip('مستحقات', 'مستحقات')),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text;
                      double amount = double.parse(_amountController.text);
                      if (name.isNotEmpty && amount > 0) {
                        _addTransaction(name, amount);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff48c659),
                    ),
                    child: const Text(
                      'إضافة',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
            TransactionList(
              _transactions,
              scrollController: _scrollController,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChoiceChip(String label, String chipType) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ChoiceChip(
        label: Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              color: type == chipType ? Colors.black : Colors.black,
            ),
          ),
        ),
        selectedColor: Colors.greenAccent,
        selected: type == chipType,
        showCheckmark: false,
        onSelected: (val) {
          if (val) {
            setState(() {
              type = chipType;
            });
          }
        },
      ),
    );
  }

  // دالة لحفظ الصفقات باستخدام Shared Preferences
  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = _transactions.map((t) {
      return {
        'name': t.name,
        'amount': t.amount,
        'date': t.date.toIso8601String(),
      };
    }).toList();
    prefs.setStringList(
        'transactions', transactions.map((t) => json.encode(t)).toList());
  }

  // دالة لاستعادة الصفقات المحفوظة باستخدام Shared Preferences
  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsData = prefs.getStringList('transactions');
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
