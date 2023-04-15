import 'package:flutter/material.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/widgets/short_bar.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import 'app_button.dart';
import 'checker.dart';

class Success extends StatelessWidget {
  final String title, message, actionText;
  final Color? color;
  final VoidCallback? onPressed;

  const Success({
    Key? key,
    required this.title,
    required this.message,
    required this.actionText,
    this.onPressed,
    this.color,
  }): super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, textAlign: TextAlign.center, style: titleStyle,),
        const SizedBox(height: 47,),
        Text(message, textAlign: TextAlign.center,),
        const SizedBox(height: 10,),
        ShortBar(color: color,),
        const SizedBox(height: 63,),
        Container(
          height: 60,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: AppButton(
            text: actionText,
            textStyle: successButtonStyle,
            color: successButtonColor,
            onPressed: onPressed ?? () => WebRoute.pop(),
          ),
        ),
      ],
    ),
  );
}