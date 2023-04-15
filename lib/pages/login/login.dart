import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/login/login_view_model.dart';
import 'package:web_admin/widgets/app_button.dart';
import 'package:web_admin/widgets/app_text_input.dart';

import '../../service_locator.dart';
import '../../services/snackbar_service.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) => BaseView<LoginViewModel>(
    backgroundType: BackgroundType.main,
    builder: (_, model, __) => Center(
      child: SizedBox(
        width: 510,
        height: 643,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/app_logo.png', fit: BoxFit.cover, width: 100, height: 70,),
            Expanded(
              child: Container(
                width: 510,
                height: 543,
                padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 57),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome Back', style: titleStyle,),
                    const SizedBox(height: 8,),
                    const Text('Sign into your admin account.', style: normalTextStyle,),
                    const SizedBox(height: 47,),
                    AppTextInput(
                      textEditingController: _email,
                      inputType: TextInputType.emailAddress,
                      label: 'Email',
                    ),
                    const SizedBox(height: 24,),
                    AppTextInput(
                      textEditingController: _password,
                      label: 'Password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 8,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => WebRoute.go(WebRoute.forgotPassword),
                        child: const Text('Forgot password', style: normalBlackTextStyle,),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 36),
                      child: AppButton(
                        text: 'Login',
                        onPressed: () async {
                          String result = await model.login(_email.text, _password.text);
                          if (result == 'success') {
                            WebRoute.go(WebRoute.home, popAll: true);
                          } else {
                            serviceLocator<SnackBarService>().showSnackBar(
                              message: result,
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}