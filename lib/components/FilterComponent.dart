import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterComponent extends StatefulWidget {
  final List<String> transactionNames;
  final Function(DateTime?, DateTime?) onDateSelected;
  final Function(String) onNameSelected;

  const FilterComponent({super.key,
    required this.transactionNames,
    required this.onDateSelected,
    required this.onNameSelected,
  });

  @override
  _FilterComponentState createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Filter by Date',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buildDateField('Start Date', startDate, (date) {
            setState(() {
              startDate = date;
            });
          }),
          const SizedBox(height: 10),
          buildDateField('End Date', endDate, (date) {
            setState(() {
              endDate = date;
            });
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              widget.onDateSelected(startDate, endDate);
              Navigator.pop(context); // Close the modal after applying filter
            },
            child: const Text('Apply Filter'),
          ),
        ],
      ),
    );
  }

  Widget buildDateField(
    String label,
    DateTime? date,
    void Function(DateTime?) onChanged,
  ) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  onChanged(selectedDate);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                date != null
                    ? DateFormat('yyyy-MM-dd').format(date)
                    : 'Select Date',
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
