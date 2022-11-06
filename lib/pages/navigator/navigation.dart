import 'dart:ffi';

import 'package:adorafrika/pages/navigator/account.dart';
import 'package:adorafrika/pages/navigator/dashboard.dart';
import 'package:adorafrika/pages/navigator/panegyriques.dart';
import 'package:adorafrika/pages/navigator/playlist.dart';
import 'package:adorafrika/pages/player.dart';
import 'package:adorafrika/pages/navigator/projects.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

//import 'package:awesome_bottom_navigation/awesome_bottom_navigation.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  bool visible = true;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

       static const TextStyle optionStyles =
      TextStyle(fontSize: 14);
  static const List<Widget> _widgetOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Dashboard(
            hideNavigation: hideNav,
            showNavigation: showNav,
          ),
          Playlist(hideNavigation: hideNav,
          showNavigation: showNav),
          Panegyriques(hideNavigation: hideNav,
            showNavigation: showNav,),
         // Projects(),
          Account()
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
        
        duration: Duration(microseconds: 1000),
        height: visible ? kBottomNavigationBarHeight + 40 : 0,
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          color: Colors.green.shade800,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.orange,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              //style: optionStyles,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 300),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Accueil',
                ),
                GButton(
                  icon: LineIcons.music,
                  text: 'Musique',
                ),
                GButton(
                  icon: LineIcons.microphone,
                  text: 'Panégyriques',
                ),
                /* GButton(
                  icon: LineIcons.lightbulbAlt,
                  text: 'Projets',
                ), */
                GButton(
                  icon: LineIcons.user,
                  text: 'Compte',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void hideNav() {
    setState(() {
      visible = false;
    });
  }

  void showNav() {
    setState(() {
      visible = true;
    });
  }
}

