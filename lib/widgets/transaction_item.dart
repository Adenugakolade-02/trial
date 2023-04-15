import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class TransactionItem extends StatelessWidget {
  final Color? backgroundColor;
  final Color? color;
  final TextStyle? valueStyle;
  final String label;
  final String? value;
  final double? height;

  TransactionItem(this.label, this.value, { this.backgroundColor, this.color, this.valueStyle, this.height });

  @override
  Widget build(BuildContext context) => Container(
    height: height ?? 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: backgroundColor ?? transactionItemColor
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(label, style: TextStyle(fontSize: 12, color: color ?? faintColor),),
          ),
        ),
        Expanded(
          child: Text('${value}', style: valueStyle ?? normalBlackStyle,),
        )
      ],
    ),
  );
}