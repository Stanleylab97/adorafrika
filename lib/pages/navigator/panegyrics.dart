import 'dart:async';
import 'dart:convert';
import 'package:adorafrika/pages/panegyriques/create_panegyrique.dart';
import 'package:adorafrika/pages/panegyriques/video_panegyrique.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:adorafrika/models/panegyrique.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Panegerycs extends StatefulWidget {
  const Panegerycs({super.key});

  @override
  State<Panegerycs> createState() => _PanegerycsState();
}

class _PanegerycsState extends State<Panegerycs> {
  List<Panegyrique> list = [];
  StreamController<Panegyrique>? streamController;
  late Future<List<Panegyrique>> dynamiclist;
  Future<List<Panegyrique>> getPanegyriquesList() async {
    try {
      // var client = new http.Client();

      var response =
          await http.get(Uri.parse(NetworkHandler.baseurl + "/panegyrique"));
      var jsonData = json.decode(response.body);
      var jsonArray = jsonData['panegyriques'];
      print(jsonArray);

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

  Future<List<Panegyrique>> updateList(dynamic value) async {
    try {
      // var client = new http.Client();
      Map<String, dynamic> data = {
        "nom_famille": value,
      };

      var response = await http.post(
        Uri.parse(
          NetworkHandler.baseurl + "/panegyrique/recherche",
        ),
        body: json.encode(data),
        headers: {
          "Content-type": "application/json",
          //  HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      var jsonData = json.decode(response.body);
      var jsonArray = jsonData['panegyrique'];

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
    dynamiclist = getPanegyriquesList();
    super.initState();
  }

  @override
  void dispose() {
    streamController?.close();
    streamController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search for a panegyric',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              onChanged: ((value) {
                if (value == "")
                  setState(() {
                    dynamiclist = getPanegyriquesList();
                  });
                else
                  setState(() {
                    dynamiclist = updateList(value);
                   // print('liste filtrée ${dynamiclist.l}');
                  });
              }),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  prefixStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none),
                  hintText: "Nom de famille, village, pays",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.green),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            Expanded(
              child: FutureBuilder<List<Panegyrique>>(
                  future: dynamiclist,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var panegeriques = snapshot.data!;
                      print(panegeriques);
                      return ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                        itemCount: panegeriques.length,
                        itemBuilder: (context, index) {
                          final pane = panegeriques[index];
                          if (pane.type == "AUDIO")
                            return ListTile(
                              leading: FaIcon(
                                FontAwesomeIcons.music,
                                size: 35,
                                color: Colors.orange,
                              ),
                              title: Text(
                                "Famille " + pane.name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(pane.region,
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              trailing: Visibility(
                                  visible: true,
                                  child: Icon(
                                    Icons.verified_rounded,
                                    color: Colors.green,
                                  )),
                            );
                          else
                            return GestureDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .09,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .17,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .07,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          "assets/images/panigeriques/play.jpg"))),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .01,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Famille " + pane.name,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .02,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(pane.countryCode!,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(pane.region,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(pane.username,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: true,
                                      child: Icon(
                                        Icons.verified_rounded,
                                        color: Colors.green,
                                      ))
                                ],
                              ),
                            );
                        },
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(color: Colors.red));
                    }
                  }),
            )
          ],
        ),
      ),
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
          ]),
    );
  }
}
