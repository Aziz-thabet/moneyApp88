// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, file_names, non_constant_identifier_names

import 'package:Money_manager/components/FilterComponent.dart';
import 'package:flutter/material.dart';
import 'package:Money_manager/components/buildDateSelectionWidget.dart';

import 'package:Money_manager/components/Transaction_List.dart';
import 'package:Money_manager/components/build_Text_Field.dart';
import 'package:Money_manager/components/totalAmount.dart';
import 'package:Money_manager/models/TransactionModel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;

import 'EditTransactionPage.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key, required this.updateExpensesTotal});
  final Function(double) updateExpensesTotal;
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  // Define filter parameters
  DateTime? startDate;
  DateTime? endDate;
  String filterName = '';
  double? minAmount;
  double? maxAmount;
  List<String> transactionNames = [];
  String selectedName = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();
  double expensesTotal = 0.0;
  Color ExpensesColor = Colors.purpleAccent;
  DateTime? selectedDate;
  double originalIncomeTotal = 0.0;
  double filteredIncomeTotal = 0.0;
// Update name filter
  void _handleNameSelected(String selectedName) {
    setState(() {
      filterName = selectedName;
      // Update total income when name filter is applied
      expensesTotal =
          getTotalAmountOfExpenses(_getFilteredTransactions(_transactions));
      widget.updateExpensesTotal(expensesTotal);
    });
  }


  // Method to show filter modal
  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Filter by Date'),
              onTap: () {
                _handleDateFilter(context);
              },
            ),
            ListTile(
              title: const Text('Filter by Name'),
              onTap: () {
                _handleNameFilter(context);
              },
            ),
            ListTile(
              title: const Text('Filter by Amount'),
              onTap: () {
                _handleAmountFilter(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDateFilter(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return FilterComponent(
          onDateSelected: (startDate, endDate) async {
            // Save the selected start and end dates to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'startDate', startDate?.toIso8601String() ?? '');
            await prefs.setString('endDate', endDate?.toIso8601String() ?? '');
            // Apply the date filter
            setState(() {
              this.startDate = startDate;
              this.endDate = endDate;
            });
            Navigator.pop(context); // Close the modal after selecting dates
          },
          transactionNames: transactionNames,
          onNameSelected: _handleNameSelected,
        );
      },
    );
  }

  // Method to handle name filter
  void _handleNameFilter(BuildContext context) {
    String enteredName = ''; // Initialize variable to store entered name

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Enter Name'),
                onChanged: (value) {
                  enteredName = value; // Update enteredName as user types
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filterName =
                        enteredName.trim(); // Apply entered name as filter
                  });
                  Navigator.of(context).pop(); // Close dialog
                  // Update total income when name filter is applied
                  expensesTotal = getTotalAmountOfExpenses(
                      _getFilteredTransactions(_transactions));
                  widget.updateExpensesTotal(expensesTotal);
                },
                child: const Text('Apply Filter'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to handle amount filter
  void _handleAmountFilter(BuildContext context) {
    double? enteredMinAmount;
    double? enteredMaxAmount;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Amount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Enter Min Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  enteredMinAmount = double.tryParse(value);
                },
              ),
              TextField(
                decoration:
                const InputDecoration(labelText: 'Enter Max Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  enteredMaxAmount = double.tryParse(value);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    minAmount = enteredMinAmount;
                    maxAmount = enteredMaxAmount;
                  });
                  Navigator.of(context).pop(); // Close dialog
                  // Update total income when amount filter is applied
                  expensesTotal = getTotalAmountOfExpenses(
                      _getFilteredTransactions(_transactions));
                  widget.updateExpensesTotal(expensesTotal);
                },
                child: const Text('Apply Filter'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Update date filter

  List<Transaction> _getFilteredTransactions(List<Transaction> transactions) {
    return transactions.where((transaction) {
      // Filter by date
      final dateInRange =
          (startDate == null || transaction.date.isAfter(startDate!)) &&
              (endDate == null || transaction.date.isBefore(endDate!));

      // Filter by name
      final nameMatches =
          filterName.isEmpty || transaction.name.contains(filterName);
      // Filter by amount
      final amountInRange =
          (minAmount == null || transaction.amount >= minAmount!) &&
              (maxAmount == null || transaction.amount <= maxAmount!);

      return dateInRange && nameMatches && amountInRange;
    }).toList();
  }



  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _addTransaction(String name, double amount, String type) async {
    setState(() {
      _transactions.add(
          Transaction(
        name: name,
        amount: amount,
        date: selectedDate ?? DateTime.now(),
        type: type,
      ));
      transactionNames.add(name);
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
      expensesTotal = getTotalAmountOfExpenses(_transactions);
      widget.updateExpensesTotal(expensesTotal);
    });
  }

  String type = 'نوع غير محدد';

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _getFilteredTransactions(_transactions);
    return Scaffold(
      // floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterModal(context); // Show filter modal when FAB is pressed
        },
        child: const Icon(Icons.filter_list),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        title: const Text( 'المصروفات'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TotalAmountWidget(
              getTotalAmountOfExpenses(_transactions),
              color: ExpensesColor,
            ),
            if (startDate != null &&
                endDate != null) // Display selected date range
              Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: Text(
                  'Filtered Date Range: ${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  buildTextField('الاسم', _nameController),
                  buildTextField('المبلغ', _amountController,
                      keyboardType: TextInputType.number),
                  buildChoiceChipList(),
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
              filteredTransactions,
              scrollController: _scrollController,
              CircleAvatarColor: ExpensesColor,
              onDelete: _deleteTransaction,
              onEdite: _editTransaction,
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
          Expanded(child: buildChoiceChip('ترفيهية', 'ترفيهية', ExpensesColor)),
          const SizedBox(width: 10.0),
          Expanded(child: buildChoiceChip('اساسية', ' اساسية', ExpensesColor)),
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
        selectedColor: ExpensesColor,
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
    prefs.setDouble('expensesTotal', expensesTotal);
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
      expensesTotal = getTotalAmountOfExpenses(_transactions);
      widget.updateExpensesTotal(expensesTotal);
    });
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsData = prefs.getStringList('expenses_transactions');
    if (transactionsData != null) {
      final transactions = transactionsData
          .map(
            (t) => Transaction(
              name: json.decode(t)['name'],
              amount: json.decode(t)['amount'],
              date: DateTime.parse(json.decode(t)['date']),
              type: json.decode(t)['type'],
            ),
          )
          .toList();
      setState(() {
        _transactions
            .clear(); // Clear the list before adding retrieved transactions
        _transactions.addAll(transactions);
        // Calculate original total income
        originalIncomeTotal = getTotalAmountOfExpenses(_transactions);
        // Initialize filtered total income to original total income
        filteredIncomeTotal = originalIncomeTotal;
        widget.updateExpensesTotal(filteredIncomeTotal);
      });
    }
  }
}
