import 'package:flutter/material.dart';
import 'package:flutter_institutions_testcase/Pages/homeScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Poppins'),
    home: const HomeScreen(),
  ));
}
