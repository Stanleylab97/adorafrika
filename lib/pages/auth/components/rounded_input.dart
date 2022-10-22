import 'package:flutter/material.dart';
import 'package:adorafrika/pages/auth/components/input_container.dart';
const kPrimaryColor = Color(0XFF6A62B7);
const kBackgroundColor = Color(0XFFE5E5E5);
class RoundedInput extends StatelessWidget {
  const RoundedInput({
    Key? key,
    required this.icon,
    required this.hint
  }) : super(key: key);

  final IconData icon;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        
        cursorColor: kPrimaryColor ,
        decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none
        ),
      ));
  }
}