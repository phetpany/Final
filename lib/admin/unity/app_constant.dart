import 'package:flutter/material.dart';

class AppConstant {
  static String urlMapStart = 'https://www.google.com/maps/@17.9765248,102.6326528,13z?entry=ttu';


  TextStyle h1Style({Color? color}) => TextStyle(
        color: color,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      );
       TextStyle h2Style({Color? color}) => TextStyle(
        color: color,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      );
       TextStyle h3Style({Color? color}) => TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
}
