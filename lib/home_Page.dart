import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart'; // استيراد المكتبة لطلب الإذن
import 'package:Money_manager/pags/Expenses_page.dart';
import 'package:Money_manager/pags/Savings_page.dart';
import 'package:Money_manager/pags/inCome_page.dart';
import 'components/Category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _incomeTotal = 0.0;
  double _expensesTotal = 0.0;
  double _savingsTotal = 0.0;
  late SharedPreferences _prefs;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadTotals();
    _initializeNotifications();
  }

  Future<void> _loadTotals() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _incomeTotal = _prefs.getDouble('incomeTotal') ?? 0.0;
      _expensesTotal = _prefs.getDouble('expensesTotal') ?? 0.0;
      _savingsTotal = _prefs.getDouble('savingsTotal') ?? 0.0;
    });
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'تنبيه مالي',
      'رصيدك الحالي 500 جنيه أو أقل. قد تحتاج لتقليل مصروفاتك.',
      platformChannelSpecifics,
    );
  }

  Future<void> _saveTotals() async {
    await _prefs.setDouble('incomeTotal', _incomeTotal);
    await _prefs.setDouble('expensesTotal', _expensesTotal);
    await _prefs.setDouble('savingsTotal', _savingsTotal);
  }

  void _updateIncomeTotal(double newTotal) {
    setState(() {
      _incomeTotal = newTotal;
    });
    _saveTotals();
  }

  void _updateExpensesTotal(double newTotal) {
    setState(() {
      _expensesTotal = newTotal;
    });
    _saveTotals();
  }

  void _updateSavingsTotal(double newTotal) {
    setState(() {
      _savingsTotal = newTotal;
    });
    _saveTotals();
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = _incomeTotal - _expensesTotal - _savingsTotal;

    // Request notification permission if it's not granted yet
    _requestNotificationPermission();

    // Show notification if total is less than or equal to 500
    if (total <= 500) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNotification();
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff00bcd4),
        title: const Text('Money Manager'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back/spread-us-one-hundred-dollars-bills-background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              children: [
                Category(
                  text: 'الادخار',
                  color: const Color(0xffff2000),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return SavingsPage(updateSavingTotal: _updateSavingsTotal);
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
                        return ExpensesPage(updateExpensesTotal: _updateExpensesTotal);
                      }),
                    );
                  },
                ),
                Category(
                  text: 'الدخل',
                  color: const Color(0xff2cc106),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return IncomePage(updateIncomeTotal: _updateIncomeTotal);
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
              'الاموال المتاحة',
              style: TextStyle(
                fontSize: 60,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
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
}
