import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final bool filled;
  final Color color;
  final double? height;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.filled = true,
    this.color = primaryColor,
    this.height = 47,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialButton(
    child: Text(text, style: textStyle ?? normalButtonStyle,),
    onPressed: onPressed,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
      side: BorderSide(color: color),
    ),
    color: filled ? color : Colors.white,
    height: height,
  );
}