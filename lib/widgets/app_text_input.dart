import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTextInput extends StatefulWidget {
  final Function(String)? onChanged;
  final TextEditingController textEditingController;
  final String? label;
  final String? hint;
  final TextInputType? inputType;
  final bool isPassword;
  final bool enabled;
  final Widget? suffix;

  const AppTextInput({
    Key? key,
    required this.textEditingController,
    this.label,
    this.hint,
    this.onChanged,
    this.inputType,
    this.isPassword = false,
    this.enabled = true,
    this.suffix,
  }) : super(key: key);

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {

  bool obscure = true;

  @override
  Widget build(BuildContext context) => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: unfocusedColor,
    ),
    child: TextField(
      controller: widget.textEditingController,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        // filled: true,
        // fillColor: unfocusedColor,
        labelText: widget.label,
        hintText: widget.hint,
        suffixIcon: widget.isPassword ? _visibilityIcon() : widget.suffix,
        border: InputBorder.none,
        // focusedBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(width: 2, color: primaryColor),
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ),
      keyboardType: widget.inputType ?? TextInputType.text,
      obscureText: widget.isPassword ? obscure : false,
      enabled: widget.enabled,
    ),
  );

  Widget _visibilityIcon() => IconButton(
    onPressed: () {
      setState(() {
        obscure = !obscure;
      });
    },
    icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
  );
}