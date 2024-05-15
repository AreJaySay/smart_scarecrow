import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientColors{

  // BUTTON GRADIENT
  static LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color.fromRGBO(5, 172, 196, 1),Color.fromRGBO(0, 228, 189, 1),Color.fromRGBO(8, 254, 185, 1)]);

  // TEXT GRADIENT
  static Shader textgradient = LinearGradient(
    colors: <Color>[Color.fromRGBO(5, 182, 194, 1), Color.fromRGBO(0, 246, 186, 1)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 50.0));

  // PAGE GRADIENT
  static LinearGradient pagebckgrnd = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color.fromRGBO(102, 132, 255, 1),Color.fromRGBO(12, 38, 65, 0.6)]);
}