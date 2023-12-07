//
// // ignore_for_file: depend_on_referenced_packages, file_names
//
// import 'package:flutter/material.dart';
// import 'package:many/models/TransactionModel.dart';
// import 'package:intl/intl.dart';
//
// Widget buildTransactionCard(Transaction transaction) {
//   return Card(
//     elevation: 5,
//     margin: const EdgeInsets.symmetric(
//       vertical: 8,
//       horizontal: 5,
//     ),
//     child: ListTile(
//       leading: CircleAvatar(
//         radius: 30,
//         child: Padding(
//           padding: const EdgeInsets.all(6),
//           child: FittedBox(
//             child: Text('${transaction.amount}'),
//           ),
//         ),
//       ),
//       title: Text(
//         transaction.name,
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             DateFormat.yMMMd().format(transaction.date),
//           ),
//           const Text(
//             'التفاصيل الإضافية هنا',
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
