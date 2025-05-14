import 'package:flutter/material.dart';

Text text(String title,
    {double fontSize = 16, Color color = Colors.black, TextAlign? textAlign}) {
  return Text(
    title,
    style: TextStyle(fontFamily: 'tajwal', fontSize: fontSize, color: color),
    textAlign: textAlign,
  );
}


