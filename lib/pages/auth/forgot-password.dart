import 'package:adorafrika/pages/auth/widgets/background-image.dart';
import 'package:adorafrika/pages/auth/widgets/pallete.dart';
import 'package:adorafrika/pages/auth/widgets/rounded-button.dart';
import 'package:adorafrika/pages/auth/widgets/text-field-input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ForgotPassword extends StatelessWidget {
  late TextEditingController email;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/auth/login.jpeg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kWhite,
              ),
            ),
            title: Text(
              'Mot de passe oublié',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Text(
                        'Entrez votre adresse e-mail pour réinitialiser votre mot de passe',
                        style: TextStyle(fontSize: 20, color: Colors.white, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextInputField(
                      controller: email,
                      icon: FontAwesomeIcons.envelope,
                      hint: 'E-mail',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.done,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RoundedButton(buttonName: 'Envoyer')
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
