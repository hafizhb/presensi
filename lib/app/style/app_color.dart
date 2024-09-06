import 'package:flutter/cupertino.dart';

class AppColor {
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF6482AD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static Color primary = Color(0xFF6482AD);
  static Color primarySoft = Color(0xFF7FA1C3);
  static Color secondary = Color(0xFFE2DAD6);
  static Color blackprimary = Color(0xFF444444);
  static Color blacksecondary = Color(0xFF6D6D6D);
  static Color error = Color(0xFFD00E0E);
}
