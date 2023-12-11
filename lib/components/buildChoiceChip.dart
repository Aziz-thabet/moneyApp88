// ignore_for_file: file_names
// // ignore_for_file: file_names
//
// import 'package:flutter/material.dart';
//
// Widget buildChoiceChip(
//   String label,
//   String chipType,
//   Color color,
//     ValueChanged<bool> onSelected
// ) {
//   String type = 'income';
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: ChoiceChip(
//       label: Text(
//         label,
//         style: TextStyle(
//           fontSize: 24,
//           color: type == chipType ? Colors.black : Colors.black,
//         ),
//       ),
//       selectedColor: color,
//       selected: type == chipType,
//       showCheckmark: false,
//   onSelected: onSelected, // استدعاء الدالة المستلمة عند الضغط على ChoiceChip
//     ),
//   );
// }
