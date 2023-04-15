import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_colors.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/agent_data.dart';
import 'package:web_admin/pages/agents/agents_view_model.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/widgets/app_button.dart';
import 'package:web_admin/widgets/app_text_input.dart';
import 'dart:math';

class AdminsCreate extends StatefulWidget {
  const AdminsCreate({Key? key}) : super(key: key);

  @override
  State<AdminsCreate> createState() => _AdminsCreateState();
}

class _AdminsCreateState extends State<AdminsCreate> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String _accessCode = '';
  final String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  @override
  Widget build(BuildContext context) => BaseView<AdminsViewModel>(
    backgroundType: BackgroundType.content,
    title: 'Create Agent',
    builder: (_, model, __) => ListView(
      children: [
        const SizedBox(height: 100,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  DottedBorder(
                    radius: const Radius.circular(50),
                    borderType: BorderType.RRect,
                    dashPattern: const [3, 3],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: unfocusedColor
                      ),
                      child: const Center(child: Icon(Icons.camera_alt, size: 20,),),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextInput(
                          textEditingController: _firstName,
                          label: 'Agent First Name',
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: AppTextInput(
                          textEditingController: _lastName,
                          label: 'Agent Last Name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  AppTextInput(
                    textEditingController: _email,
                    label: 'Email Address',
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20,),
                  AppTextInput(
                    textEditingController: _phoneNumber,
                    label: 'Agent Phone Number',
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: unfocusedColor
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SelectableText(_accessCode.isEmpty ? 'Access code' : _accessCode),
                        AppButton(
                          text: 'Generate',
                          color: Colors.black,
                          textStyle: successButtonStyle,
                          onPressed: () {
                            setState(() {
                              _accessCode = getRandomString(10);
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  AppButton(
                    text: 'Create Agent',
                    onPressed: () async {
                      if (
                      _firstName.text.isEmpty ||
                      _lastName.text.isEmpty ||
                      _email.text.isEmpty ||
                      _accessCode.isEmpty ||
                      _phoneNumber.text.isEmpty
                      ) return;
                      bool res = await model.addAgent(_firstName.text, _lastName.text, _email.text, _accessCode, _phoneNumber.text);
                      if (res) WebRoute.dashboardPop(true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}