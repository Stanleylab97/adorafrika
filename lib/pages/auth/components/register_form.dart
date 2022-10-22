import 'package:flutter/material.dart';
import 'package:adorafrika/pages/auth/components/rounded_button.dart';
import 'package:adorafrika/pages/auth/components/rounded_input.dart';
import 'package:adorafrika/pages/auth/components/rounded_password_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLogin ? 0.0 : 1.0,
      duration: animationDuration * 5,
      child: Visibility(
        visible: !isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SizedBox(height: 10),

                  Text(
                    'Bienvenue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black
                    ),
                  ),

                  SizedBox(height: 40),

                  SvgPicture.asset('assets/images/auth/register.svg'),

                  SizedBox(height: 40),

                  RoundedInput(icon: Icons.mail, hint: 'E-mail'),

                  RoundedInput(icon: Icons.face_rounded, hint: 'Nom'),

                  RoundedPasswordInput(hint: 'Mot de passe'),

                  RoundedPasswordInput(hint: 'Confrmation de mot de passe'),


                  SizedBox(height: 10),

                  RoundedButton(title: 'Inscription'),

                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}