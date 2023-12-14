// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';

import 'package:many/components/Custom_FloatingAction_Button.dart';
import 'package:many/components/Transaction_List.dart';
import 'package:many/components/build_Text_Field.dart';
import 'package:many/components/totalAmount.dart';
import 'package:many/models/TransactionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key, required this.updateExpensesTotal})
      : super(key: key);
  final Function(double) updateExpensesTotal;
  @override
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends State<ExpensesPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();
  double expensesTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _addTransaction(String name, double amount, String type) async {
    setState(() {
      _transactions.add(Transaction(
        name: name,
        amount: amount,
        date: DateTime.now(),
        type: type,
      ));
      _nameController.clear();
      _amountController.clear();
      _saveTransactions();
      expensesTotal = getTotalAmountOfExpenses(_transactions);
      widget.updateExpensesTotal(expensesTotal);
    });
  }

  double getTotalAmountOfExpenses(List<Transaction> transactions) {
    return transactions.fold(
        0.0, (total, transaction) => total + transaction.amount);
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
      _saveTransactions();
    });
  }

  String type = 'نوع غير محدد';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        title: const Text('المصروفات'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TotalAmountWidget(
              getTotalAmountOfExpenses(_transactions),
              color: Colors.purpleAccent,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  buildTextField('الاسم', _nameController),
                  buildTextField('المبلغ', _amountController,
                      keyboardType: TextInputType.number),
                  buildChoiceChipList(),
                  ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text;
                      double amount =
                          double.tryParse(_amountController.text) ?? 0.0;
                      if (name.isNotEmpty && amount > 0) {
                        _addTransaction(name, amount, type);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffe040fb),
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
              CircleAvatarColor: Colors.purpleAccent,
              onDelete: _deleteTransaction,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChoiceChipList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
              child:
                  buildChoiceChip('ترفيهية', 'ترفيهية', Colors.purpleAccent)),
          const SizedBox(width: 10.0),
          Expanded(
              child: buildChoiceChip('اساسية', ' اساسية', Colors.purpleAccent)),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget buildChoiceChip(String label, String chipType, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: type == chipType ? Colors.black : Colors.black,
          ),
        ),
        selectedColor: Colors.purpleAccent,
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

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = _transactions
        .map((t) => {
              'name': t.name,
              'amount': t.amount,
              'date': t.date.toIso8601String(),
              'type': t.type
            })
        .toList();
    prefs.setStringList(
      'expenses_transactions',
      transactions.map((t) => json.encode(t)).toList(),
    );
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsData = prefs.getStringList('expenses_transactions');
    if (transactionsData != null) {
      final transactions = transactionsData
          .map((t) => Transaction(
              name: json.decode(t)['name'],
              amount: json.decode(t)['amount'],
              date: DateTime.parse(json.decode(t)['date']),
              type: 'type'))
          .toList();
      setState(() {
        _transactions.clear(); // يجب مسح القائمة قبل إضافة الصفقات المسترجعة
        _transactions.addAll(transactions);
        expensesTotal = getTotalAmountOfExpenses(_transactions);
      });
    }
  }
}
