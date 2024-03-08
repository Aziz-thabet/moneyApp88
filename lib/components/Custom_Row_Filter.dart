// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';

class Custom_Row_Filter extends StatelessWidget {
  const Custom_Row_Filter({
    super.key, required this.name, required this.icon,
  });
final String name ;
final IconData icon ;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Text(name,
          style: const TextStyle(fontSize: 25),
        ),
        const Spacer(
          flex: 1,
        ),
        IconButton(
          onPressed: () {},
          icon:  Icon(
           icon,
            size: 30,
          ),
        ),
      ],
    );
  }
}
