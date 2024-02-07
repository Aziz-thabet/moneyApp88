// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget buildDateSelectionWidget(BuildContext context, DateTime? selectedDate, void Function(DateTime?) onDateSelected) {
  return InkWell(
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != selectedDate) {
        onDateSelected(pickedDate);
      }
    },
    child: Row(
      children: [
        const Icon(
          Icons.date_range_sharp,
          color: Colors.black,
          size: 45,
        ),
        const SizedBox(width: 10),
        if (selectedDate != null) ...[
          const Icon(
            Icons.check,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
        ],
        Text(
          selectedDate != null
              ? 'تم اختيار التاريخ '
              : 'اختر التاريخ',
          style: const TextStyle(color: Colors.black, fontSize: 25),
        ),
      ],
    ),
  );
}
