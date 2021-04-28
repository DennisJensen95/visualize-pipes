import 'package:flutter/material.dart';

Color idColor = Color(0xff00adb4);
var idColorNonConst = Color(0xff00adb4);
var genericButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
    ),
    primary: idColor);
