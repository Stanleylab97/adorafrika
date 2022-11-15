import 'dart:convert';

import 'package:adorafrika/pages/auth/widgets/background-image.dart';
import 'package:adorafrika/pages/auth/widgets/pallete.dart';
import 'package:adorafrika/pages/auth/widgets/widgets.dart';
import 'package:adorafrika/pages/navigator/navigation.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create-new-account.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool validate = false;
  Logger log = Logger();
  late String errorText = "";
  bool isloading = false;
  bool circular = false;

  login() async {
    final prefs = await SharedPreferences.getInstance();
    // final storage = new FlutterSecureStorage();
    setState(() {
      circular = true;
    });
   // print("password=: ${password.text.trim()}");
    Map<String, dynamic> data = {
      "username": email.text.trim(),
      "password": password.text.trim(),
    };
    DataConnectionStatus status = await isConnected();
    if (status == DataConnectionStatus.connected) {
      var response = await networkHandler.unsecurepost(NetworkHandler.baseurl+"/client/login", data);
      log.v(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Login susscessfull");
       // Map<String, dynamic> output = json.decode(response.data);
        /*  if (!statut) {
           await prefs.setString('nom', nom.text.trim());
           await prefs.setString('prenom', prenom.text.trim());
           await prefs.setString('email', email.text.trim());
           await prefs.setString('tel', email.text.trim());
         } else {
           await prefs.setString('raison', raison.text.trim());
           await prefs.setString('rccm', rccm.text.trim());
           await prefs.setString('email', email.text.trim());
           await prefs.setString('tel', tel.text.trim());
         } */
        // await storage.write(key: "token" , value:  output["token"]);
        setState(() {
          validate = true;
          circular = false;
        });
        Navigator.push(context,MaterialPageRoute(builder: (context) => Navigation()));
      } else {
        setState(() {
          validate = false;
          if (response.statusCode == 401) {
            circular = false;
            errorText = 'Identifiant ou mot de passe incorrects';
            //log.e('Erreur ${response.statusCode}: $errorText');
            Flushbar(
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              message: errorText,
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              duration: Duration(seconds: 3),
            )..show(context);
          }
          if (response.statusCode == 500) {
            circular = false;
            errorText = 'Erreur système détectée';
            CherryToast.error(
                    title: Text("Erreur réseau"),
                    displayTitle: false,
                    description: Text(errorText),
                    animationType: AnimationType.fromRight,
                    animationDuration: Duration(milliseconds: 1000),
                    autoDismiss: true)
                .show(context);
          } else {
            circular = false;
          }
        });
      }
    } else {
      setState(() {
        circular = false;
      });
      CherryToast.error(
              title: Text("Erreur réseau"),
              displayTitle: false,
              description: Text("Vérifiez votre connexion internet!"),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
    }
  }

  showError(String errormessage) {
    Flushbar(
      message: errormessage,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[300],
    )..show(context);
  }

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BackgroundImage(
          image: 'assets/images/auth/background.jpeg',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Text(
                    'AdorAfriKa',
                    style: GoogleFonts.fuzzyBubbles(
                        textStyle: TextStyle(
                            color: SizeConfig.primaryColor,
                            fontSize: 60,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextInputField(
                    controller: email,
                    icon: FontAwesomeIcons.envelope,
                    hint: 'Nom d\'utilisateur',
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                  ),
                  PasswordInput(
                    controller: password,
                    icon: FontAwesomeIcons.lock,
                    hint: 'Mot de passe',
                    inputAction: TextInputAction.done,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
                    child: Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                          fontSize: 14, color: Colors.white, height: 1.5),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                 circular? Center(child: CircularProgressIndicator(color:Colors.yellow)): Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: kBlue,
                    ),
                    child: TextButton(
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        "Se connecter",
                        style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNewAccount())),
                child: Container(
                  child: Text(
                    'Créer un compte',
                    style: kBodyText,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
}
