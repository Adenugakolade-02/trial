import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {

  static ThemeData materialTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: ThemeData().colorScheme.copyWith(secondary: accentColor, primary: accentColor),
      textTheme: Theme.of(context).textTheme.apply(
        fontFamily: 'Nunito',
      ),
    );
  }
}