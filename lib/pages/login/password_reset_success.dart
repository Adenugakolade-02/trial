import 'package:flutter/material.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/widgets/success.dart';

import '../base_view.dart';
import 'login_view_model.dart';

class ForgotPasswordSuccess extends StatelessWidget {
  const ForgotPasswordSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<LoginViewModel>(
    builder: (_, model, __) => Center(
      child: SizedBox(
        width: 510,
        height: 529,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/Icon-512.png', fit: BoxFit.cover, width: 100, height: 70,),
            Expanded(
              child: Container(
                width: 510,
                height: 429,
                padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 57),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Success(
                  title: 'Password Reset\nSuccessfully',
                  message: 'You can now log in to your admin Account',
                  actionText: 'Back to Login',
                  onPressed: () => WebRoute.go(WebRoute.login, popAll: true),
                )
              ),
            )
          ],
        ),
      ),
    ),
  );
}