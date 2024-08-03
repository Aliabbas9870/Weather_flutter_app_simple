import 'package:flutter/material.dart';

class Constants {
  final primaryColor = Color(0xff615EFC);
  final secondaryColor = Color(0xff7E8EF1);
  final tarityColor = Color(0xffD1D8C5);
  final textColor = Color(0xffEEEEEE);
  final Shader = LinearGradient(colors: [
    Color(0xff7E8EF1),
    Color(0xffD1D8C5),
  ]);

  final linearGradientPrimary = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      // stops: [0.5, 0.5,0.5,0.5],
      colors: [Color(0xff615EFC), Color(0xff7E8EF1), Color.fromARGB(255, 213, 218, 205)]);
}


