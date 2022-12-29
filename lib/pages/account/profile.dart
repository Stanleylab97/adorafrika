import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:profile/profile.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  var box = Hive.box('settings');
  @override
  Widget build(BuildContext context) {
    var currentUser = box.get('currentUser', defaultValue: {});
    print("curent : $currentUser");
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Profile(
            imageUrl:
                "https://images.unsplash.com/photo-1598618356794-eb1720430eb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
            name: currentUser['nom'] +" "+currentUser['prenom'],
            website: "shamimmiah.com",
            designation: "Project Manager | Flutter & Blockchain Developer",
            email: "cse.shamimosmanpailot@gmail.com",
            phone_number: "01757736053",
          ),
        ),
      ),
    );
  }
}
