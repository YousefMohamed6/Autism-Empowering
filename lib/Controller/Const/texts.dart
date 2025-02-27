import 'package:flutter/material.dart';

Text text(String title,
    {double fontSize = 16, Color color = Colors.black, TextAlign? textAlign}) {
  return Text(
    title,
    style: TextStyle(fontFamily: 'tajwal', fontSize: fontSize, color: color),
    textAlign: textAlign,
  );
}

const String oneSignalAppId = 'f6d36d37-d26c-4973-8ead-e6600c5ba0cd';
const String oneSignalApikey =
    'OWNiOTgxMTQtZjY0Ny00NmY2LThkMDQtZjdiZjhiMjYzMzc0';
