import 'dart:async';
import 'dart:convert';
import 'package:adorafrika/pages/panegyriques/video_panegyrique.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:adorafrika/models/panegyrique.dart';
import 'package:adorafrika/pages/panegyriques/create_panegyrique.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Panegyriques extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;
  const Panegyriques(
      {super.key, required this.showNavigation, required this.hideNavigation});

  @override
  State<Panegyriques> createState() => _PanegyriquesState();
}

class _PanegyriquesState extends State<Panegyriques> {
  StreamController<Panegyrique>? streamController;

  ScrollController scrollController = ScrollController();
  late SingleValueDropDownController _cnt;
  List<Panegyrique> list = [];

  Future<List<Panegyrique>> getPanegyriquesList() async {
    try {
      // var client = new http.Client();

      var response =
          await http.get(Uri.parse(NetworkHandler.baseurl + "/panegyrique"));
      var jsonData = json.decode(response.body);
      var jsonArray = jsonData['panegyriques'];
     
      return jsonArray.map<Panegyrique>(Panegyrique.fromJson).toList();

      /*    var req = new http.Request(
          'get', Uri.parse(NetworkHandler.baseurl + "/panegyrique"));

      var streamedRes = await client.send(req);
      print(streamedRes);

      streamedRes.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .expand((e) => e)
          .map((map) => Panegyrique.fromJson(map))
          .pipe(sc); */
    } catch (ex) {
      return List.empty();
    }
  }

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
    streamController = StreamController.broadcast();

    streamController!.stream.listen((p) => setState(() => list.add(p)));

    getPanegyriquesList();
  }

  @override
  void dispose() {
    streamController?.close();
    streamController = null;
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDialOpen = ValueNotifier(false);

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else
          return true;
      },
      child: Scaffold(
          body: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                child: Column(children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: size.height * 0.3,
                        width: size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/panigeriques/images.jpeg"),
                                fit: BoxFit.cover)),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(1.0),
                              ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft)),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset:
                        Offset(0.0, -(size.height * 0.3 - size.height * 0.26)),
                    child: Container(
                      width: size.width,
                      padding: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: DefaultTabController(
                          length: 1,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: TextField(
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 3),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Icon(
                                          Icons.search,
                                          size: 30,
                                        ),
                                      ),
                                      hintText: "Nom de famille ou région",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                              width: 1.0,
                                              color: Colors.grey.shade400))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Container(
                                  height: size.height * 0.6,
                                  child: TabBarView(
                                    children: <Widget>[
                                      FutureBuilder<List<Panegyrique>>(
                                          future: getPanegyriquesList(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var panegeriques = snapshot.data!;
                                              return ListView.builder(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                itemCount: panegeriques.length,
                                                itemBuilder: (context, index) {
                                                  final pane =
                                                      panegeriques[index];
                                                  if (pane.type == "AUDIO")
                                                    return ListTile(
                                                        leading: FaIcon(
                                                          FontAwesomeIcons
                                                              .music,
                                                          size: 35,
                                                          color: Colors.orange,
                                                        ),
                                                        title: Text(
                                                          "Famille " +
                                                              pane.name,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20),
                                                        ),
                                                        subtitle: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.map,
                                                              color: Colors.red,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(pane.region,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ));
                                                  else
                                                    return GestureDetector(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .09,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .2,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .07,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18),
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              AssetImage("assets/images/panigeriques/play.jpg"))),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .01,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Famille " +
                                                                          pane.name,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          .02,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                       Text(
                                                                            pane.countryCode!,
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                            pane
                                                                                .region,
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                      ],
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                },
                                              );
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.red));
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                ]),
              )),
          floatingActionButton: SpeedDial(
              heroTag: "create-paneyrique",
              //animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.yellow.shade600,
              overlayOpacity: 0.4,
              overlayColor: Colors.black,
              icon: Icons.add,
              activeIcon: Icons.close,
              children: [
                SpeedDialChild(
                    child: Icon(FontAwesomeIcons.microphone),
                    label: "Enregister",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePanegyrique()));
                    }),
                SpeedDialChild(
                    child: Icon(FontAwesomeIcons.video),
                    label: "Sélectionner une vidéo",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PicknUploadPaneegyrique()));
                    }),
              ])),
    );

  }
}
