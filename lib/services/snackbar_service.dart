
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class SnackBarService {
  final GlobalKey<ScaffoldMessengerState> _snackbarKey = GlobalKey<ScaffoldMessengerState>();
  GlobalKey<ScaffoldMessengerState> get snackbarKey => _snackbarKey;

  void showSnackBar({
    VoidCallback? onPressed,
    bool isError = true,
    required String message,
    String actionLabel = 'Go back',
    Duration duration = const Duration(seconds: 5),
    bool showAction = false
  }) {
    if (_snackbarKey.currentContext == null) return;
    ScaffoldMessenger.of(_snackbarKey.currentContext!).hideCurrentSnackBar();
    ScaffoldMessenger.of(_snackbarKey.currentContext!).showSnackBar(SnackBar(
      duration: duration,
      content: Text(message, style: isError ? snackBarErrorStyle : snackBarInfoStyle,),
      backgroundColor: isError ? debitColor : primaryColor,
      action: showAction ? SnackBarAction(
        label: actionLabel,
        textColor: isError ? Colors.white : accentColor,
        onPressed: onPressed!,
      ) : null,
    ));
  }
}