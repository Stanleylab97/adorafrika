import 'package:flutter/material.dart';
import 'package:adorafrika/pages/auth/components/rounded_button.dart';
import 'package:adorafrika/pages/auth/components/rounded_input.dart';
import 'package:adorafrika/pages/auth/components/rounded_password_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
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
      opacity: isLogin ? 1.0 : 0.0,
      duration: animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: size.width,
          height: defaultLoginSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(height: size.width * .12),
                Text(
                  'Inscrivez-vous!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                ),

                SizedBox(height: 40),

                SvgPicture.asset('assets/images/auth/login.svg'),

                SizedBox(height: 40),
              //  Form(child: child)

                RoundedInput(icon: Icons.mail, hint: 'E-mail'),

                RoundedPasswordInput(hint: 'Mot de passe'),

                SizedBox(height: 10),

                RoundedButton(title: 'Connexion'),

                SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ),
    );
  }
}