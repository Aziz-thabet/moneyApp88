// ignore_for_file: file_names, avoid_types_as_parameter_names,, non_constant_identifier_names


import 'package:flutter/material.dart' show BuildContext, FloatingActionButton, Icon, Icons, MaterialPageRoute, Navigator, StatelessWidget, Widget;
import 'package:Money_manager/home_Page.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder:
            (BuildContext){
          return  const HomePage();
            }));
      },
      child: const Icon(Icons.arrow_back_ios,),
    );
  }
}