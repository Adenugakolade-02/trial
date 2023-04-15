import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class Progress extends StatelessWidget {
  final String? progressText;
  const Progress(this.progressText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: transparentBlack,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10,),
          Text(progressText ?? '', style: normalButtonStyle,)
        ],
      ),
    ),
  );
}