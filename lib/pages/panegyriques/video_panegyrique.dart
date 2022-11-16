import 'dart:convert';
import 'dart:io';
import 'package:adorafrika/pages/navigator/navigation.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

///import 'package:country_state_city/country_state_city_picker.dart';

class PicknUploadPaneegyrique extends StatefulWidget {
  const PicknUploadPaneegyrique({super.key});

  @override
  State<PicknUploadPaneegyrique> createState() =>
      _PicknUploadPaneegyriqueState();
}

class _PicknUploadPaneegyriqueState extends State<PicknUploadPaneegyrique> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _famille = TextEditingController();
  final TextEditingController _region = TextEditingController();
  TextEditingController country = TextEditingController();
  bool iscovered = false;
  ImagePicker picker = ImagePicker();
  bool validate = false;
  Logger log = Logger();
  late String errorText = "";
  bool isloading = false;
  var coverImage;

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  File? _video;
  VideoPlayerController? videoPlayerController;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _getVideofromCamera() async {
    XFile? video = await _imagePicker.pickVideo(source: ImageSource.camera);
    _video = File(video!.path);
    videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
      });
    videoPlayerController!.play();
  }

  Future<void> _getVideofromgallery() async {
    XFile? video = await _imagePicker.pickVideo(source: ImageSource.gallery);
    _video = File(video!.path);
    videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
      });
    videoPlayerController!.play();
  }

  _getFromGallery() async {
    XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: MediaQuery.of(context).size.height * .3,
        maxWidth: MediaQuery.of(context).size.height * .6);

    if (pickedFile != null) {
      // File imageFile = File(pickedFile.path);
      setState(() {
        coverImage = File(pickedFile.path);
        iscovered = true;
      });
    }
  }

  bool isNotNull(String? input) {
    return input?.isNotEmpty ?? false;
  }

  @override
  Widget build(BuildContext context) {
    savePanegyrique() async {
      print("Valeur:  ${isNotNull(_video?.path)}  val :  ${_video?.path}");
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          isloading = true;
        });

        if (isNotNull(_video?.path)) {
          DataConnectionStatus status = await isConnected();
          if (status == DataConnectionStatus.connected) {
            var request = http.MultipartRequest('POST',
                Uri.parse(NetworkHandler.baseurl + "/panegyrique/creation"));
            request.files.add(
                await http.MultipartFile.fromPath("fichier", _video!.path));

            request.files.add(await http.MultipartFile.fromPath(
                "thumbnail", coverImage.path));

            request.fields['nom_famille'] = _famille.text.trim();
            request.fields['region'] = _region.text.trim();
            request.fields['pays'] = country.text.trim();
            request.fields['type_fichier'] = "VIDEO";
            request.fields['statut'] = "NOUVEAU";
            request.fields['compte_clients_id'] = "1";
            request.headers.addAll({
              "Content-type": "multipart/form-data",
              //"Authorization": "Bearer $token"
            });
            EasyLoading.show(status: 'Chargement du fichier...');
            try {
              final streamedResponse = await request.send();
              final response = await http.Response.fromStream(streamedResponse);
              if (response.statusCode == 200 || response.statusCode == 201) {
                print(response.body);
                Map<String, dynamic> output = json.decode(response.body);
                EasyLoading.showSuccess('Panégyrique enregistré!');
                print("Upload done");
                EasyLoading.dismiss();
                setState(() {
                  isloading = false;
                });

                Navigator.pop(context);
              } else {
                EasyLoading.dismiss();
                print("SSSSS" + response.body);
                Map<String, dynamic> output = json.decode(response.body);
                setState(() {
                  validate = false;
                  errorText = response.statusCode.toString();
                  log.e(errorText);
                  isloading = false;
                });
              }
            } catch (e) {
              print(e);
              EasyLoading.dismiss();
              log.e(e);
              setState(() {
                isloading = false;
              });
              return null;
            }
          } else {
            setState(() {
              isloading = false;
            });
            CherryToast.error(
                    title: Text("Erreur"),
                    displayTitle: false,
                    description: Text(
                        "Il semble que votre connexion soit instable",
                        style: TextStyle(color: Colors.black)),
                    animationType: AnimationType.fromRight,
                    animationDuration: Duration(milliseconds: 1000),
                    autoDismiss: true)
                .show(context);
          }
        } else {
          setState(() {
            isloading = false;
          });
          CherryToast.error(
                  title: Text("Erreur"),
                  displayTitle: false,
                  description: Text("Il manque fichier à charger",
                      style: TextStyle(color: Colors.black)),
                  animationType: AnimationType.fromRight,
                  animationDuration: Duration(milliseconds: 1000),
                  autoDismiss: true)
              .show(context);
          print("Il manque fichier à charger");
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Navigation()));
            //Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "Ajout de panégyrique",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _video != null
                  ? AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: videoPlayerController!.value.isInitialized
                          ? InkWell(
                              onTap: () {
                                videoPlayerController!.initialize();
                                videoPlayerController!.play();
                              },
                              child: VideoPlayer(videoPlayerController!))
                          : Container(),
                    )
                  : AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: Container(
                        child: Text(
                          'Veuillez définir la vidéo',
                        ),
                        color: Colors.grey,
                        alignment: Alignment.center,
                      ),
                    ),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _getVideofromgallery,
                        child: Icon(
                          FontAwesomeIcons.fileVideo,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "ou",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: _getVideofromCamera,
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: TextFormField(
                                  controller: _famille,
                                  validator: (input) {
                                    if (input!.isEmpty)
                                      return 'Veuillez indiquer la famille';
                                    return null;
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    errorText: validate ? null : errorText,
                                    labelText: 'Nom de famille',
                                    prefixIcon: Icon(Icons.person),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: Colors.green),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                  ),
                                  //onSaved: (input) => _email = input
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: country,
                                  validator: (input) {
                                    if (input!.isEmpty)
                                      return 'Indiquez le pays';
                                    return null;
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    errorText: validate ? null : errorText,
                                    labelText: 'Pays',
                                    prefixIcon:
                                        Icon(FontAwesomeIcons.mapLocation),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  //onSaved: (input) => _password = input
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _region,
                                  validator: (input) {
                                    if (input!.isEmpty)
                                      return 'Indiquez la région';
                                    return null;
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    errorText: validate ? null : errorText,
                                    labelText: 'Région',
                                    prefixIcon: Icon(Icons.map_outlined),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  //onSaved: (input) => _password = input
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                  child: iscovered
                                      ? Card(
                                          elevation: 10,
                                          child: GestureDetector(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .6,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .3,
                                              child: Image.file(coverImage),
                                            ),
                                            onTap: () {},
                                          ),
                                        )
                                      : GestureDetector(
                                          child: Card(
                                            elevation: 10,
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .6,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .3,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          "assets/images/playlist/cover.jpeg",
                                                        )))),
                                          ),
                                          onTap: () {
                                            _getFromGallery();
                                          },
                                        )),
                              SizedBox(
                                height: 10,
                              ),
                              const SizedBox(height: 40),
                              isloading
                                  ? Center(
                                      child: Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: CircularProgressIndicator(
                                          color: Colors.red),
                                    ))
                                  : Column(
                                      children: [
                                        const SizedBox(height: 40),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            // shape: CircleBorder(),
                                            //padding: EdgeInsets.all(20),
                                            backgroundColor: Colors
                                                .green, // <-- Button color
                                            foregroundColor: Colors.yellow
                                                .shade600, // <-- Splash color
                                          ),
                                          onPressed: () {
                                            // print("Valeur:  ${isNotNull(_video?.path)}  val :  ${_video?.path}");
                                            savePanegyrique();
                                          }, //savePanegyrique,
                                          child: const Text('Envoyer',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                          /*   style: ButtonStyle(backgroundColor: Colors.green, shape:RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20.0) ) , */
                                        )
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
