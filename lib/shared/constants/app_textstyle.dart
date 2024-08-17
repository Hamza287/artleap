import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTextstyle {
  static TextStyle interRegular(
          {FontWeight fontWeight = FontWeight.normal,
          double fontSize = 14,
          Color color = Colors.black}) =>
      TextStyle(
          fontFamily: "interregular",
          fontWeight: fontWeight,
          fontSize: fontSize,
          // overflow: TextOverflow.ellipsis,
          color: color);
  static TextStyle interMedium(
          {FontWeight fontWeight = FontWeight.normal,
          double fontSize = 14,
          Color color = Colors.black}) =>
      TextStyle(
          fontFamily: "intermedium",
          fontWeight: fontWeight,
          fontSize: fontSize,
          overflow: TextOverflow.ellipsis,
          color: color);
  static TextStyle interBold(
          {FontWeight fontWeight = FontWeight.normal,
          double fontSize = 14,
          Color color = Colors.black}) =>
      TextStyle(
          fontFamily: "interBold",
          fontWeight: fontWeight,
          fontSize: fontSize,
          // overflow: TextOverflow.ellipsis,
          color: color);
}
