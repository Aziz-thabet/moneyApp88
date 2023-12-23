// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:many/components/Custom_FloatingAction_Button.dart';
import 'package:many/components/Transaction_List.dart';
import 'package:many/components/build_Text_Field.dart';
import 'package:many/components/totalAmount.dart';
import 'package:many/models/TransactionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key, required this.updateSavingTotal});
  final Function(double) updateSavingTotal ;
  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();
  double savingsTotal = 0.0;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _addTransaction(String name, double amount) async{
    setState(() {
      _transactions
          .add(Transaction(
        name: name,
        amount: amount,
        date: selectedDate ?? DateTime.now(),));
      _nameController.clear();
      _amountController.clear();
      _saveTransactions();
      savingsTotal = getTotalAmountOfSaving(_transactions);
      widget.updateSavingTotal(savingsTotal);

    });
  }

   double getTotalAmountOfSaving(List<Transaction> transactions) {
    return transactions.fold(
        0.0, (total, transaction) => total + transaction.amount);
  }
  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
      _saveTransactions();
      savingsTotal = getTotalAmountOfSaving(_transactions);
      widget.updateSavingTotal(savingsTotal);
    });
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
              getTotalAmountOfSaving(_transactions),
              color: Colors.deepOrange.shade300,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  buildTextField('الاسم', _nameController),
                  buildTextField('المبلغ', _amountController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        selectedDate != null
                            ? 'تم اختيار التاريخ: ${selectedDate!.toLocal()}'
                            : 'اختر التاريخ',
                        style: const TextStyle(color: Colors.black, fontSize: 25),
                      ),
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
                      backgroundColor: const Color(0xffff5500),
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
              CircleAvatarColor: const Color(0xffff5500),
              onDelete: _deleteTransaction,
            ),
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
    prefs.setDouble('savingsTotal', savingsTotal);
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
        _transactions.clear(); // يجب مسح القائمة قبل إضافة الصفقات المسترجعة
        _transactions.addAll(transactions);
        savingsTotal = getTotalAmountOfSaving(_transactions);
        widget.updateSavingTotal(savingsTotal);
      });
    }
  }
}
