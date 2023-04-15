import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ShortBar extends StatelessWidget {
  final Color? color;
  const ShortBar({
    Key? key,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    height: 5,
    width: 25,
    decoration: BoxDecoration(
      color: color ?? accentColor,
      borderRadius: BorderRadius.circular(2.5)
    ),
  );
}