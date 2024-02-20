
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whether/const/Colors.dart';

class CustomThemes{
  static  final lightTheme = ThemeData(
    fontFamily: "poppins",
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Vx.gray800,
    iconTheme: const IconThemeData(
      color : Vx.gray600
    )
  );
  static  final darkTheme = ThemeData(
      fontFamily: "poppins",
      scaffoldBackgroundColor: bgColor,
      primaryColor: Colors.white,
      cardColor: bgColor.withOpacity(0.6),
      iconTheme: const IconThemeData(
          color :Colors.white
      )
  );

}