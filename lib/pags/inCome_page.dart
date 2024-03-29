// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, file_names
import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:many/components/AppBarText.dart';
import 'package:many/components/buildDateSelectionWidget.dart';
import 'package:many/components/Transaction_List.dart';
import 'package:many/components/build_Text_Field.dart';
import 'package:many/components/totalAmount.dart';
import 'package:many/models/TransactionModel.dart';
import 'package:many/pags/EditTransactionPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/Custom_FloatingAction_Button.dart';
class IncomePage extends StatefulWidget {
  const IncomePage({super.key, required this.updateIncomeTotal});
  final Function(double) updateIncomeTotal;

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();
  double incomeTotal = 0.0;
  DateTime? selectedDate;
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

  void _addTransaction(String name, double amount, String type) async {
    setState(() {
      _transactions.add(Transaction(
        name: name,
        amount: amount,
        date: selectedDate ?? DateTime.now(),
        type: type,
      ));
      _nameController.clear();
      _amountController.clear();
      _saveTransactions();
      incomeTotal = getTotalAmountOfInCome(_transactions);
      widget.updateIncomeTotal(incomeTotal);
    });
  }

  double getTotalAmountOfInCome(List<Transaction> transactions) {
    return transactions.fold(
        0.0, (total, transaction) => total + transaction.amount);
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
      _saveTransactions();
      incomeTotal = getTotalAmountOfInCome(_transactions);
      widget.updateIncomeTotal(incomeTotal);
    });
  }

  String type = 'نوع غير محدد';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff48c659),
        title: const AppBarText(text: 'الدخل',),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TotalAmountWidget(
              getTotalAmountOfInCome(_transactions),
              color: Colors.greenAccent,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  buildTextField('الاسم', _nameController),
                  buildTextField('المبلغ', _amountController,
                      keyboardType: TextInputType.number),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(child: buildChoiceChip(' اساسي', ' اساسي')),
                        const SizedBox(width: 10.0),
                        Expanded(child: buildChoiceChip(' اضافي', ' اضافي')),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: buildDateSelectionWidget(context, selectedDate,
                        (DateTime? pickedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text;
                      double amount = double.parse(_amountController.text);
                      if (name.isNotEmpty && amount > 0) {
                        _addTransaction(name, amount, type);
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
              CircleAvatarColor: const Color(0xff48c659),
              onDelete: _deleteTransaction,
              onEdite: _editTransaction,
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
        'type': t.type
      };
    }).toList();
    prefs.setStringList(
        'transactions', transactions.map((t) => json.encode(t)).toList());
    prefs.setDouble('incomeTotal', incomeTotal);
  }

  Future<void> _editTransaction(int index) async {
    Transaction editedTransaction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionPage(
          transaction: _transactions[index],
        ),
      ),
    );
    setState(() {
      _transactions[index] = editedTransaction;
      _saveTransactions();
      incomeTotal = getTotalAmountOfInCome(_transactions);
      widget.updateIncomeTotal(incomeTotal);
    });
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
          type: data['type'],
        );
      }).toList();
      setState(() {
        _transactions.clear(); // يجب مسح القائمة قبل إضافة الصفقات المسترجعة
        _transactions.addAll(transactions);
        incomeTotal = getTotalAmountOfInCome(_transactions);
        widget.updateIncomeTotal(incomeTotal);
      });
    }
  }
}
