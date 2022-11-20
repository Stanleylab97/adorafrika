import 'package:adorafrika/pages/playlist/add_musique.dart';
import 'package:adorafrika/pages/playlist/music.dart';
import 'package:adorafrika/pages/playlist/newMusics.dart';
import 'package:adorafrika/pages/playlist/panigericList.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/panegyrique.dart';
import '../services/networkHandler.dart';

class Playlist extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;
  const Playlist(
      {Key? key, required this.showNavigation, required this.hideNavigation})
      : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  ScrollController scrollController = ScrollController();
  late SingleValueDropDownController _cnt;
  bool? searchBycountry = false;
  bool? searchByyearofproduction = false;
  bool? searchByblazartiste = false;
  String codepays = "";
  TextEditingController pays = TextEditingController();
  final countryPicker = const FlCountryCodePicker();
  TextEditingController anneeprod = TextEditingController();
  TextEditingController blazArtist = TextEditingController();

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
  }

  showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recherche',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      onPressed: () {
                         searchByblazartiste =
                      searchBycountry = searchByyearofproduction = false;
                  anneeprod.clear();
                  blazArtist.clear();
                  codepays = "";
                        Navigator.pop(context);
                      },
                      minWidth: 40,
                      height: 40,
                      color: Colors.grey.shade300,
                      elevation: 0,
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: this.searchBycountry,
                            onChanged: (val) => setState(() {
                              this.searchBycountry = val!;
                            }),
                          ),
                          title: Center(
                            child: codepays.isEmpty
                                ? FloatingActionButton.extended(
                                    heroTag: "country",
                                    elevation: 8,
                                    label: Center(
                                        child: Text(
                                      'Choisissez le pays',
                                      style: TextStyle(color: Colors.black),
                                    )),
                                    backgroundColor: Colors.white,
                                    icon: Icon(
                                      FontAwesomeIcons.flag,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      final code = await countryPicker
                                          .showPicker(context: context);
                                      if (code != null) {
                                        setState(() {
                                          pays.text = code.name;
                                          codepays = code.code;
                                        });
                                      }
                                    },
                                  )
                                : InkWell(
                                    onTap: () async {
                                      final code = await countryPicker
                                          .showPicker(context: context);
                                      if (code != null) {
                                        setState(() {
                                          pays.text = code.name;
                                          codepays = code.code;
                                        });
                                      }
                                    },
                                    child: TextFormField(
                                      controller: pays,
                                      enabled: false,
                                      style: TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          labelText: "Pays sélectionné"),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: this.searchByyearofproduction,
                            onChanged: (val) => setState(() {
                              this.searchByyearofproduction = val!;
                            }),
                          ),
                          title: Center(
                            child: TextFormField(
                              controller: anneeprod,
                              enabled:
                                  this.searchByyearofproduction! ? true : false,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: "Année de production"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: this.searchByblazartiste,
                            onChanged: (val) => setState(() {
                              this.searchByblazartiste = val!;
                            }),
                          ),
                          title: Center(
                            child: TextFormField(
                              controller: blazArtist,
                              enabled: searchByblazartiste! ? true : false,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Nom de l'artiste"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                button('Rechercher', () {
                  searchByblazartiste =
                      searchBycountry = searchByyearofproduction = false;
                  anneeprod.clear();
                  blazArtist.clear();
                  codepays = "";
                })
              ],
            ),
          );
        });
      },
    );
  }

  button(String text, Function onPressed) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 50,
      elevation: 0,
      splashColor: Colors.yellow[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.red,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 5,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xFF303151).withOpacity(0.6),
              Color(0xFF303151).withOpacity(0.9)
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.only(
                    top: size.height * .01,
                    left: size.height * .015,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * .008),
                        child: Text(
                            "Promouvoir la beauté de la culture Africaine",
                            style: GoogleFonts.cabin(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * .008,
                          right: size.width * .02,
                          bottom: size.height * .02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Quelle musique voulez-vous écouter ?",
                                style: GoogleFonts.cabin(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: Colors.white.withOpacity(0.5))),
                            GestureDetector(
                                onTap: () {},
                                child: Icon(Icons.sort_rounded,
                                    color: Colors.white, size: 28))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * .008,
                          right: size.width * .02,
                          bottom: size.height * .02,
                        ),
                        child: GestureDetector(
                          onTap: showFilterModal,
                          child: Container(
                            height: size.height * .07,
                            width: size.width * .9,
                            decoration: BoxDecoration(
                                color: Color(0xFF31314F),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width * .02),
                                    height: size.height * .06,
                                    width: size.width * .57,
                                    child: TextFormField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                          hintText: "Recherche de musique",
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.8)),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.height * .02),
                                    child: Icon(
                                      Icons.search,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      TabBar(
                        isScrollable: true,
                        labelStyle: TextStyle(fontSize: 18),
                        indicator: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: SizeConfig.secondaryColor,
                                    width: 3))),
                        tabs: [
                          Text("Récentes"),
                          Text("Rythmes traditionnels"),
                          Text("Playlistes"),
                          Text("Réligieux"),
                          Text("Vidéos"),
                        ],
                      ),
                      Flexible(
                        flex: 1,
                        child: TabBarView(
                          children: [
                            NewMusics(),
                            Container(color: Colors.yellow.shade600),
                            Container(color: Colors.yellow.shade600),
                            Container(color: Colors.yellow.shade600),
                            Container(color: Colors.yellow.shade600),
                          ],
                        ),
                      )
                    ],
                  ))),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.yellow.shade600,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddMusic()));
              },
              child: Icon(Icons.add)),
        ),
      ),
    );
  }
}
