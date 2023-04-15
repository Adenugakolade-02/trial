import 'package:flutter/material.dart';
import 'app_colors.dart';

const snackBarErrorStyle = TextStyle();
const snackBarInfoStyle = TextStyle();
const normalButtonStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
const accentButtonStyle = TextStyle(color: accentColor, fontWeight: FontWeight.bold);
const bigAccentButtonStyle = TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 18);
const blackButtonStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
const darkButtonStyle = TextStyle(color: primaryDark);
const titleStyle = TextStyle(fontWeight: FontWeight.w600, color: titleColor, fontSize: 26,);
const blackStyle = TextStyle(fontWeight: FontWeight.bold, color: titleColor,);
const subtitleStyle = TextStyle(fontWeight: FontWeight.bold, color: subtitleColor);
const textStyle = TextStyle();
const mutedButtonStyle = TextStyle(color: mutedColor);
const carouselMessageStyle = TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 18);
const authInputStyle = TextStyle(color: authInputColor, fontSize: 30,);
const keypadStyle = TextStyle(color: titleColor, fontSize: 30,);
const bottomNavBarLabelStyle = TextStyle(color: accentColor, fontWeight: FontWeight.bold,);
const normalBlackStyle = TextStyle(color: Colors.black,);
const normalFaintStyle = TextStyle(color: faintColor,);
const smallBlackStyle = TextStyle(color: Colors.black, fontSize: 12);
const smallFaintStyle = TextStyle(color: Colors.black, fontSize: 12);
const subTitleStyle = TextStyle(color: titleColor, fontSize: 20, fontWeight: FontWeight.bold);
const smallCreditStyle = TextStyle(color: creditColor, fontSize: 12);
const smallDebitStyle = TextStyle(color: debitColor, fontSize: 12);
const debitButtonStyle = TextStyle(color: debitColor, fontWeight: FontWeight.bold);
const boldBlackStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
const successButtonStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
const whiteTitleStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 24,);
const normalTextStyle = TextStyle(color: textColor, fontSize: 16);
const normalBlackTextStyle = TextStyle(color: Colors.black, fontSize: 16);
const successStyle = TextStyle(color: creditColor,);
const pendingStyle = TextStyle(color: pendingColor,);
const failedStyle = TextStyle(color: debitColor,);

TextStyle getStyle(String? status) {
  switch (status) {
    case 'completed':
      return successStyle;
    case 'pending':
      return pendingStyle;
    case 'failed':
      return failedStyle;
    default:
      return normalBlackStyle;
  }
}