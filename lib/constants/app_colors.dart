import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

const accentColor = Color(0xff00BBA6);
const primaryColor = Color(0xff00BBA6);
const secondaryColor = Color(0xff00BBA6);
const transparentBlack = Color(0x99000000);
const disabledColor = Color(0xFFAEAEAE);
const mutedColor = Colors.black54;
const primaryDark = Color(0xFF002037);
const titleColor = Color(0xFF000000);
const subtitleColor = Color(0xFF525252);
const unfocusedColor = Color(0xFFF9F9F9);
const keypadBackgroundColor = Color(0xFFE5E5E5);
const authInputColor = Color(0xFF747474);
const accountBackgroundColor = Color(0xFFF2F9FF);
const homeCardColor = Color(0xFF00BBA6);
const withdrawButtonColor = Color(0xFFF8F8F8);
const creditColor = Color(0xFF36834C);
const debitColor = Color(0xFFC9272E);
const creditBackgroundColor = Color(0xFFF0F9F2);
const debitBackgroundColor = Color(0xFFFCF0F0);
const pendingBackgroundColor = Color(0xFFFEF6E8);
const failedBackgroundColor = Color(0xFFFCF0F0);
const faintColor = Color(0xFF5F5E5E);
const darkAccentColor = Color(0xff00BBA6);
const lightDotColor = Color(0xFFBCE3FF);
const successButtonColor = Color(0xFF002037);
const textBackground = Color(0xFFF9F9F9);
const pendingColor = Color(0xFFF2AD23);
const textColor = Color(0xFF737373);
const backgroundColor = Color(0xFFE5E5E5);
const greenBackgroundColor = Color(0xFFEEF9EC);
const transactionItemColor = Color(0xFFF5F3F3);
const amountBackgroundColor = Color(0xFFF2F9FF);

Color getBackgroundColor(String? status) {
  switch (status) {
    case 'completed':
      return creditBackgroundColor;
    case 'pending':
      return pendingBackgroundColor;
    case 'failed':
      return debitBackgroundColor;
    case 'approved':
      return unfocusedColor;
    default:
      return transactionItemColor;
  }
}

Color getColor(String? status) {
  switch (status) {
    case 'completed':
      return creditColor;
    case 'pending':
      return pendingColor;
    case 'failed':
      return debitColor;
    case 'approved':
      return Colors.black;
    default:
      return transactionItemColor;
  }
}