import 'package:adorafrika/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:adorafrika/pages/auth/components/input_container.dart';
const kPrimaryColor = Color(0XFF6A62B7);
const kBackgroundColor = Color(0XFFE5E5E5);
class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({
    Key? key,
    required this.hint
  }) : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        cursorColor: kPrimaryColor,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none
        ),
      ));
  }
}