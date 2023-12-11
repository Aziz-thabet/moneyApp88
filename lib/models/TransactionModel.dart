// ignore_for_file: file_names
class Transaction {
  final String name;
  final double amount;
  final DateTime date;
  String? type;

  Transaction({
    required this.name,
    required this.amount,
    required this.date,
    this.type,
  });
}
