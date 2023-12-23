// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages,

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // استيراد حزمة لتنسيق التواريخ
import 'package:many/components/build_Text_Field.dart';
import 'package:many/models/TransactionModel.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.transaction.name);
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _dateController = TextEditingController(
        text: DateFormat.yMMMd().format(widget.transaction.date));
    _typeController =
        TextEditingController(text: widget.transaction.type ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('تعديل '),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: () {
                Transaction updatedTransaction = Transaction(
                  name: _nameController.text,
                  amount: double.parse(_amountController.text),
                  date: DateFormat.yMMMd().parse(_dateController.text),
                  type: _typeController.text.isNotEmpty
                      ? _typeController.text
                      : null,
                );
                Navigator.pop(context, updatedTransaction);
              },
              icon: const Icon(
                Icons.save,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('الاسم', _nameController),
            buildTextField('المبلغ', _amountController),
            buildTextField('المبلغ', _typeController),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  //
                  Text(
                    _dateController.text,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),

                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: widget.transaction.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              DateFormat.yMMMd().format(pickedDate);
                        });
                      }
                    },
                    child: const Icon(
                      Icons.date_range_sharp,
                      color: Colors.black,
                      size: 45,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
