// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:many/pags/Expenses_page.dart';
import 'package:many/pags/Savings_page.dart';
import 'package:many/pags/inCome_page.dart';
import 'components/Category.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff00bcd4),
        title: const Text('Money manager'),
      ),
      body: Column(
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
                      return const SavingsPage();
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
                      return const ExpensesPage();
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
                      return const IncomePage();
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
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                child: Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '1225',
                        style: TextStyle(fontSize: 120),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}