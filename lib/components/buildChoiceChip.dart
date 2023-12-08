// // ignore_for_file: file_names
//
// import 'package:flutter/material.dart';
//
// Widget buildChoiceChip(
//   String label,
//   String chipType,
//   Color color,
//   VoidCallback onSelected,
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
//       onSelected: (_) {
//         onSelected(); // استدعاء الدالة المستلمة عند الضغط على ChoiceChip
//       },
//     ),
//   );
// }
