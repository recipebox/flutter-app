import 'package:flutter/material.dart';

// --------------------------- Text Style ---------------------------
final styleHintText = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

// --------------------------- Color Code ---------------------------
final sColorBody1 = Color(0xFF433D3E);
final sColorBody2 = Color(0xFF9C9495);
final sColorBody3 = Color(0xFFE6DBDD);
final sColorBody4 = Color(0xffFFEEE0);

final sColorButton1 = Color(0xFFFE3562);

final sColorText1 = Color(0xffFC9535);
final sColorTextHeader1 = Colors.white;
final sColorTextTitle1 = Colors.brown;
final sColorTextDesc1 = Colors.grey;
final sColorTextDetail1 = Colors.black26;

// ---------------------- BoxDecoration ----------------------------
final sBoxDecorationSplashInput = BoxDecoration(
  color: sColorBody1,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
