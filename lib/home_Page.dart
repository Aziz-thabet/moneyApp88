// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:Money_manager/pags/Expenses_page.dart';
import 'package:Money_manager/pags/Savings_page.dart';
import 'package:Money_manager/pags/inCome_page.dart';
import 'components/Category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  double incomeTotal = 0.0;
  double expensesTotal = 0.0;
  double savingsTotal = 0.0;
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    double total = incomeTotal - expensesTotal - savingsTotal;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff00bcd4),
        title: const Text('Money manager'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
              'assets/back/spread-us-one-hundred-dollars-bills-background.jpg'),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Category(
                  text: 'الادخار',
                  color: const Color(0xffff2000),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return SavingsPage(
                            updateSavingTotal: _updateSavingsTotal);
                      }),
                    );
                  },
                ),
                Category(
                  text: 'المصاريف',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ExpensesPage(
                            updateExpensesTotal: _updateExpensesTotal);
                      }),
                    );
                  },
                ),
                Category(
                  text: 'الدخل',
                  color: const Color(0xff48c658),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return IncomePage(
                            updateIncomeTotal: _updateIncomeTotal);
                      }),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Image.asset(
                'assets/pngs/klipartz.com.png',
                width: double.infinity,
              ),
            ),
            const Text(
              'الاموال المتاحة ',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$total',
                          style: const TextStyle(fontSize: 120),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTotals();
  }

  Future<void> _loadTotals() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      incomeTotal = prefs.getDouble('incomeTotal') ?? 0.0;
      expensesTotal = prefs.getDouble('expensesTotal') ?? 0.0;
      savingsTotal = prefs.getDouble('savingsTotal') ?? 0.0;
    });
  }

  void _updateIncomeTotal(double newTotal) {
    // تحديث قيمة الدخل في صفحة الرئيسية
    setState(() {
      incomeTotal = newTotal;
    });
  }

  void _updateExpensesTotal(double newTotal) {
    // تحديث قيمة المصروفات في صفحة الرئيسية
    setState(() {
      expensesTotal = newTotal;
    });
  }

  void _updateSavingsTotal(double newTotal) {
    // تحديث قيمة الادخار في صفحة الرئيسية
    setState(() {
      savingsTotal = newTotal;
    });
  }
}
