import 'dart:convert';
import 'dart:ui';
import 'package:adorafrika/pages/auth/screens.dart';
import 'package:adorafrika/pages/auth/widgets/background-image.dart';
import 'package:adorafrika/pages/auth/widgets/pallete.dart';
import 'package:adorafrika/pages/auth/widgets/widgets.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewAccount extends StatefulWidget {
  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  TextEditingController email = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  bool vis = true;
  late String errorText;
  bool validate = false;
  bool circular = false;
  Logger log = Logger();
  bool statut = false;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  saveClient() async {
  //  if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      // final storage = new FlutterSecureStorage();
      setState(() {
        circular = true;
      });

      
      
      
      
      
      
      
      
      
      DataConnectionStatus status = await isConnected();
      if (status == DataConnectionStatus.connected) {
        Map<String, String> data = {
  "nom": nom.text.trim(),
  "prenom": prenom.text.trim(), //prenom.text.trim(),
  //"email": email.text.trim(),
  "profil": "abonne",
  "username": email.text.trim(),
  "password": password.text.trim(),
  "password_confirmation": confirmpass.text.trim()
};
        var url= NetworkHandler.baseurl+"/compte/client";     
        print(url) ;
        var response = await networkHandler.authenticateUser(url, data);
    
        log.v(response.statusCode);
        if (response.statusCode == 201 || response.statusCode == 200) {
          Map<String, dynamic> output = json.decode(response.body);
          /*  */
          /*     await prefs.setString('nom', nom.text.trim()); */
          /*     await prefs.setString('prenom', prenom.text.trim()); */
          /*     await prefs.setString('email', email.text.trim()); */
          /*     await prefs.setString('tel', email.text.trim()); */
          // await storage.write(key: "token" , value:  output["token"]);
          setState(() {
            validate = true;
            circular = false;
          });
          Navigator.pop(context);
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
                      title: Text("Erreur réseau",style:TextStyle(color:Colors.black)),
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

          nom.clear();
          prenom.clear();
          password.clear();
        }
      } else {
        setState(() {
          circular = false;
        });
        CherryToast.error(
                title: Text("Erreur réseau"),
                displayTitle: false,
                description: Text(
                  "Vérifiez votre connexion internet!",
                  style: TextStyle(color: Colors.black),
                ),
                animationType: AnimationType.fromRight,
                animationDuration: Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(context);
      }
   // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/auth/background.jpeg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.width * 0.1,
                ),
                Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: CircleAvatar(
                            radius: size.width * 0.14,
                            backgroundColor: Colors.grey[400]!.withOpacity(
                              0.4,
                            ),
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: kWhite,
                              size: size.width * 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.08,
                      left: size.width * 0.56,
                      child: Container(
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        decoration: BoxDecoration(
                          color: SizeConfig.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kWhite, width: 2),
                        ),
                        child: Icon(
                          FontAwesomeIcons.arrowUp,
                          color: kWhite,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Column(
                  children: [
                    TextInputField(
                      controller: nom,
                      icon: FontAwesomeIcons.user,
                      hint: 'Nom ',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                     TextInputField(
                      controller: prenom,
                      icon: FontAwesomeIcons.user,
                      hint: 'Prénom',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                    TextInputField(
                      controller: email,
                      icon: FontAwesomeIcons.user,
                      hint: 'Nom d\'utilisateur',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                    PasswordInput(
  controller: password,
  icon: FontAwesomeIcons.lock,
  hint: 'Mot de passe',
  inputAction: TextInputAction.done,
),
                    PasswordInput(
                      controller: confirmpass,
                      icon: FontAwesomeIcons.lock,
                      hint: 'Confirmer le mot de passe',
                      inputAction: TextInputAction.done,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    circular? Center(child: CircularProgressIndicator(color: Colors.red,),):Container(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: kBlue,
                      ),
                      child: TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(SizeConfig.primaryColor)),
                        onPressed: () {
                          saveClient();
                        },
                        child: Text(
                          "Inscription",
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Déja inscrit? ',
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            'Se connecter',
                            style: kBodyText.copyWith(
                                color: SizeConfig.primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
