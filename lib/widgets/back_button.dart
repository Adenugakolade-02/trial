import 'package:flutter/material.dart';
import 'package:web_admin/constants/web_routes.dart';

import '../constants/app_colors.dart';
import '../enums/states.dart';
import '../pages/base_model.dart';

class AppBackButton extends StatelessWidget {
  final BaseModel model;

  const AppBackButton(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: titleColor)
        ),
        child: const Icon(Icons.arrow_back_ios, color: titleColor,),
      ),
      onTap: () {
        if (model.state != AppState.idle) {
          model.setState(AppState.idle);
        } else {
          WebRoute.dashboardPop();
        }
      },
    );
  }
}