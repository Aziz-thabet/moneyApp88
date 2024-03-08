// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:many/components/Custom_Row_Filter.dart';

class AppBarText extends StatelessWidget {
  const AppBarText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text),
        const Spacer(flex: 1),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Center(child: Text('فلترة')),
                content: SizedBox(
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                      Custom_Row_Filter(name: 'حدد اسم المعاملة ',
                        icon:Icons.arrow_drop_down_circle_outlined,),
                      SizedBox(height: 30,),
                      Custom_Row_Filter(name: 'حدد تاريخ المعاملة ',
                        icon: Icons.date_range,)
                    ],
                  ),
                ),
              ),
            );
          },
          icon: const Icon(Icons.filter_alt, size: 30),
        ),
      ],
    );
  }
}

