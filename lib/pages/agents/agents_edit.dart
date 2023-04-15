import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/models/agent_data.dart';
import 'package:web_admin/pages/agents/agents_view_model.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/widgets/transaction_item.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../enums/states.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_input.dart';
import 'dart:math';

class AdminsEdit extends StatefulWidget {
  final AgentData adminData;
  const AdminsEdit({Key? key, required this.adminData}) : super(key: key);

  @override
  State<AdminsEdit> createState() => _AdminsEditState();
}

class _AdminsEditState extends State<AdminsEdit> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String _accessCode = '';
  final String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  final List<String> statusList = ['active', 'pending', 'blocked'];
  String _status = 'Name';

  @override
  void initState() {
    _firstName.text = widget.adminData.firstName!;
    _lastName.text = widget.adminData.lastName!;
    _phoneNumber.text = widget.adminData.phoneNumber!;
    _email.text = widget.adminData.email!;
    _status = widget.adminData.status!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BaseView<AdminsViewModel>(
    backgroundType: BackgroundType.content,
    title: 'Edit Agent Details',
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
                        const Text('Agent Status:',),
                        DropdownButton<String>(
                          value: _status,
                          underline: Container(),
                          items: statusList.map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          )).toList(),
                          onChanged: (s) {
                            setState(() {
                              _status = s!;
                            });
                          },
                        )
                      ],
                    ),
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
                        SelectableText(_accessCode.isEmpty ? 'Generate New Access code' : _accessCode),
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
                    text: 'Update Agent',
                    onPressed: () {
                      if (
                        _firstName.text.isEmpty ||
                        _lastName.text.isEmpty ||
                        _email.text.isEmpty ||
                        _phoneNumber.text.isEmpty ||
                        _status.isEmpty ||
                        widget.adminData.id == null
                      ) return;
                      model.updateAgent(widget.adminData.id!, _firstName.text, _lastName.text, _email.text, _accessCode, _phoneNumber.text, _status);
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