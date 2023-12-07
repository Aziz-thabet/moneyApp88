// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:many/components/Custom_FloatingAction_Button.dart';
import 'package:many/components/Transaction_List.dart';
import 'package:many/components/totalAmount.dart';
import 'package:many/models/TransactionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;


class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
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
        0.0, (sum, transaction) => sum + transaction.amount);
  }

  String type = 'income';

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
              _getTotalAmount(),
              color: Colors.purpleAccent,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  _buildTextField('الاسم', _nameController),
                  _buildTextField('المبلغ', _amountController,
                      keyboardType: TextInputType.number),
                  _buildChoiceChips(),
                  ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text;
                      double amount =
                          double.tryParse(_amountController.text) ?? 0.0;
                      if (name.isNotEmpty && amount > 0) {
                        _addTransaction(name, amount);
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
    );
  }

  Widget _buildChoiceChips() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: _buildChoiceChip('ترفيهية', 'ترفيهية')),
          const SizedBox(width: 10.0),
          Expanded(child: _buildChoiceChip('اساسية', ' اساسية')),
          const SizedBox(width: 10),
          Expanded(child: _buildChoiceChip('التزامات', 'التزامات')),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, String chipType) {
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
              ))
          .toList();
      setState(() {
        _transactions.addAll(transactions);
      });
    }
  }
}
