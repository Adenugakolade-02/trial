import 'package:flutter/material.dart';
import 'package:web_admin/constants/web_routes.dart';

import '../../constants/app_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_input.dart';
import '../base_view.dart';
import 'login_view_model.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final TextEditingController _email = TextEditingController();

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => WebRoute.pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(height: 18,),
                    const Text('Forgot Password', style: titleStyle,),
                    const Text('A reset link will be emailed to you shortly', style: normalTextStyle,),
                    const SizedBox(height: 35,),
                    AppTextInput(
                      textEditingController: _email,
                      inputType: TextInputType.emailAddress,
                      label: 'Email Address',
                      hint: 'admin@email.com',
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 40),
                      child: AppButton(
                        text: 'Send Link',
                        color: Colors.black,
                        textStyle: blackButtonStyle,
                        onPressed: () {
                          WebRoute.go(WebRoute.forgotPasswordSuccess);
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