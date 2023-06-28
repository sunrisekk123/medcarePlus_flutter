import 'package:flutter/material.dart';

Color primary = const Color(0xFFe68453);

class Styles {
  static Color primaryColor = primary;
  static Color textColor = const Color(0xFF303030);
  static Color appBarTextColor = const Color(0xFF303030);
  static Color appBarBgColor = const Color(0xFFe68453);
  static Color buttonTextColor = const Color(0xFFffffff);
  static Color bgColor = const Color(0x00000000);
  static Color bgColor2 = const Color(0xFFffffff);
  static TextStyle textStyle =
      TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle1 =
      TextStyle(fontSize: 22, color: textColor, fontWeight: FontWeight.bold);
  static TextStyle headLineStyle2 =
      TextStyle(fontSize: 21, color: textColor, fontWeight: FontWeight.bold);
  static TextStyle headLineStyle3 =
      TextStyle(fontSize: 17, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle4 =
      TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle5 = TextStyle(
      fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle6 = TextStyle(
      fontSize: 12, color: Color(0xFFA1A8B0), fontWeight: FontWeight.w500);
  static TextStyle appBarStyle1 = TextStyle(
      fontSize: 17, color: appBarTextColor, fontWeight: FontWeight.bold);
  static TextStyle buttonTextStyle1 = TextStyle(
      fontSize: 15, color: buttonTextColor, fontWeight: FontWeight.w500);
  static TextStyle boxTextStyle1 =
      TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle boxTextStyle2 = TextStyle(
      fontSize: 10, color: Color(0xFF494a49), fontWeight: FontWeight.w500);
  static TextStyle cardDetailsTextStyleTitle =
      TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle cardDetailsTextStyleSubtitle1 =
      TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle cardDetailsTextStyleSubtitle2 =
      TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w400);
  static TextStyle cardDetailsTextStyleLocation =
      TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500);
}

Map<int, Color> color = {
  50: Color.fromRGBO(230, 132, 83, .1),
  100: Color.fromRGBO(230, 132, 83, .2),
  200: Color.fromRGBO(230, 132, 83, .3),
  300: Color.fromRGBO(230, 132, 83, .4),
  400: Color.fromRGBO(230, 132, 83, .5),
  500: Color.fromRGBO(230, 132, 83, .6),
  600: Color.fromRGBO(230, 132, 83, .7),
  700: Color.fromRGBO(230, 132, 83, .8),
  800: Color.fromRGBO(230, 132, 83, .9),
  900: Color.fromRGBO(230, 132, 83, 1),
};

MaterialColor colorCustom = MaterialColor(0xFFe68453, color);

class IconStyles {
  static Icon blackCross = const Icon(Icons.clear_rounded, color: Colors.black);
}
