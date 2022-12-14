import 'dart:convert';
import 'dart:io';
import 'package:adorafrika/pages/navigator/navigation.dart';
import 'package:adorafrika/pages/navigator/panegyrics.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:adorafrika/providers/play_audio_provider.dart';
import 'package:adorafrika/providers/record_audio_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:csc_picker/csc_picker.dart';

//import 'package:country_state_city_picker/country_state_city_picker.dart';

class CreatePanegyrique extends StatefulWidget {
  const CreatePanegyrique({super.key});

  @override
  State<CreatePanegyrique> createState() => _CreatePanegyriqueState();
}

class _CreatePanegyriqueState extends State<CreatePanegyrique> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _famille = TextEditingController();
  final TextEditingController _region = TextEditingController();
  TextEditingController country = TextEditingController();
  bool validate = false;
  Logger log = Logger();
  late String errorText = "";
  bool isloading = false;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  Map currentUser =
      Hive.box('settings').get('currentUser', defaultValue: {}) as Map;
  bool typeFichier = true;
  bool isPanegyric = true;
  String audiofilePicked = "";

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  _recordHeading() {
    return const Center(
      child: Text(
        'Record Audio',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }

  _playAudioHeading() {
    return const Center(
      child: Text(
        'Play Audio',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }

  _recordingSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _recordProviderWithoutListener =
        Provider.of<RecordAudioProvider>(context, listen: false);

    if (_recordProvider.isRecording) {
      return InkWell(
        onTap: () async => await _recordProviderWithoutListener.stopRecording(),
        child: RippleAnimation(
          repeat: true,
          color: const Color(0xff4BB543),
          minRadius: 40,
          ripplesCount: 6,
          child: _commonIconSection(),
        ),
      );
    }

    return  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
       InkWell(
      onTap: () async => await _recordProviderWithoutListener.recordVoice(),
      child: _commonIconSection()),
        SizedBox(
          width: 6,
        ),
        Text('ou'),
        SizedBox(
          width: 6,
        ),
        _selectFileSection()
      ]
    );
  }

 _recordingVideoNPickSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _recordProviderWithoutListener =
        Provider.of<RecordAudioProvider>(context, listen: false);

    if (_recordProvider.isRecording) {
      return InkWell(
        onTap: (){} 
      );
    }

    return  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
      onTap: () async => await _recordProvider.recordWithCamera(),
      child: _recordVideoIconSection()),
        SizedBox(
          width: 6,
        ),
        Text('ou'),
        SizedBox(
          width: 6,
        ),
        InkWell(
      onTap: () async => await _recordProvider.pickVideoFile(),
      child: _videoFileIconSection())
      ]
    );
  }

    _selectVideoFileSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _recordProviderWithoutListener =
        Provider.of<RecordAudioProvider>(context, listen: false);

    /*  if (_recordProvider.isRecording) {
      return InkWell(
        onTap: () async => await _recordProviderWithoutListener.stopRecording(),
        child: RippleAnimation(
          repeat: true,
          color: const Color(0xff4BB543),
          minRadius: 40,
          ripplesCount: 6,
          child: _commonIconSection(),
        ),
      );
    } */

    return InkWell(
      onTap: () {
        _recordProvider.pickAudioFile();
        print("File selected");
      },
      child: _recordVideoIconSection(),
    );
  }

  _selectFileSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _recordProviderWithoutListener =
        Provider.of<RecordAudioProvider>(context, listen: false);

    /*  if (_recordProvider.isRecording) {
      return InkWell(
        onTap: () async => await _recordProviderWithoutListener.stopRecording(),
        child: RippleAnimation(
          repeat: true,
          color: const Color(0xff4BB543),
          minRadius: 40,
          ripplesCount: 6,
          child: _commonIconSection(),
        ),
      );
    } */

    return InkWell(
      onTap: () {
        _recordProvider.pickAudioFile();
        print("File selected");
      },
      child: _fileIconSection(),
    );
  }

  _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'aac', 'wav'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        audiofilePicked = file.path;
      });
    } else {
      // User canceled the picker
      return;
    }
    // if no file is picked
    if (result == null) return;
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    print(result.files.first.size);
    print(result.files.first.path);
  }

  _commonIconSection() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff4BB543),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(Icons.keyboard_voice_rounded,
          color: Colors.white, size: 30),
    );
  }

   _recordVideoIconSection() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff4BB543),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(FontAwesomeIcons.video,
          color: Colors.white, size: 30),
    );
  }

   _selectVideoIconSection() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff4BB543),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(FontAwesomeIcons.video,
          color: Colors.white, size: 30),
    );
  }

  _fileIconSection() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff4BB543),
        borderRadius: BorderRadius.circular(100),
      ),
      child:
          const Icon(FontAwesomeIcons.paperclip, color: Colors.white, size: 30),
    );
  }

   _videoFileIconSection() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff4BB543),
        borderRadius: BorderRadius.circular(100),
      ),
      child:
          const Icon(FontAwesomeIcons.paperclip, color: Colors.white, size: 30),
    );
  }

  _audioPlayingSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _audioControllingSection(_recordProvider.recordedFilePath),
          _audioProgressSection(),
          SizedBox(width: 1),
          GestureDetector(
              onTap: () {
                final _recordProvider =
                    Provider.of<RecordAudioProvider>(context, listen: false);
                _recordProvider.clearOldData();
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 24,
              ))
        ],
      ),
    );
  }

  _audioControllingSection(String songPath) {
    final _playProvider = Provider.of<PlayAudioProvider>(context);
    final _playProviderWithoutListen =
        Provider.of<PlayAudioProvider>(context, listen: false);

    return IconButton(
      onPressed: () async {
        if (songPath.isEmpty) return;

        await _playProviderWithoutListen.playAudio(File(songPath));
      },
      icon: Icon(
          _playProvider.isSongPlaying ? Icons.pause : Icons.play_arrow_rounded),
      color: const Color(0xff4BB543),
      iconSize: 30,
    );
  }

  _audioProgressSection() {
    final _playProvider = Provider.of<PlayAudioProvider>(context);

    return Expanded(
        child: Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .6,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: LinearPercentIndicator(
            percent: _playProvider.currLoadingStatus,
            backgroundColor: Colors.black26,
            progressColor: const Color(0xff4BB543),
          ),
        )
      ],
    ));
  }

  bool isNull(String? input) {
    return input?.isNotEmpty ?? false;
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _playProvider = Provider.of<PlayAudioProvider>(context);
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

    savePanegyrique() async {
      final prefs = await SharedPreferences.getInstance();

      String panegyrique_path = "";

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          isloading = true;
        });
        panegyrique_path = prefs.getString("panegyrique_path").toString();
        log.v("Pane" + panegyrique_path);
        var x = isNull(panegyrique_path);
        if (panegyrique_path.isNotEmpty) {
          DataConnectionStatus status = await isConnected();

          if (status == DataConnectionStatus.connected) {
            var request = http.MultipartRequest('POST',
                Uri.parse(NetworkHandler.baseurl + "/panegyrique/creation"));
            request.files.add(
                await http.MultipartFile.fromPath("fichier", panegyrique_path));
            request.fields['nom_famille'] = _famille.text.trim();
            request.fields['country_libelle'] = countryValue;
            request.fields['country_code'] = countryValue.substring(0, 2);
            request.fields['state'] = stateValue;
            request.fields['region'] = cityValue;
            request.fields['type_fichier'] = typeFichier ? "AUDIO" : "VIDEO";
            request.fields['isPanegyric'] =
                isPanegyric ? 1.toString() : 0.toString();
            request.fields['statut'] = "NOUVEAU";
            request.fields['compte_clients_id'] = currentUser['id'].toString();
            request.headers.addAll({
              "Content-type": "multipart/form-data",
              //"Authorization": "Bearer $token"
            });
            EasyLoading.show(status: 'Chargement du fichier...');

            try {
              final streamedResponse = await request.send();
              final response = await http.Response.fromStream(streamedResponse);
              print(response.statusCode);
              if (response.statusCode == 200 || response.statusCode == 201) {
                Map<String, dynamic> output = json.decode(response.body);
                EasyLoading.showSuccess('Pan??gyrique enregistr??!');
                print("Upload done");
                EasyLoading.dismiss();

                setState(() {
                  isloading = false;
                });
                _recordProvider.clearOldData();
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Panegerycs()));
              } else {
                EasyLoading.dismiss();
                Map<String, dynamic> output = json.decode(response.body);
                setState(() {
                  validate = false;
                  errorText = output['status'];
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
          CherryToast.error(
                  title: Text("Erreur"),
                  displayTitle: false,
                  description: Text("Il manque fichier ?? charger",
                      style: TextStyle(color: Colors.black)),
                  animationType: AnimationType.fromRight,
                  animationDuration: Duration(milliseconds: 1000),
                  autoDismiss: true)
              .show(context);
          print("Il manque fichier ?? charger");
          Flushbar(
            margin: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            message: "Il manque fichier ?? charger",
          );
        }
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Panegerycs()));
              //Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          //backgroundColor: Colors.black,
          title: Text(
            "Ajout de pan??gyrique",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics:
              ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
          child: Center(
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * .25,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/panigeriques/shango.jpg"),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            Container(
                              child: TextFormField(
                                controller: _famille,

                                validator: (input) {
                                  if (input!.isEmpty)
                                    return 'Veuillez indiquer la famille';

                                  return null;
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  errorText: validate ? null : errorText,
                                  labelText: 'Nom de famille',
                                  labelStyle: TextStyle(color: Colors.white),
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlutterSwitch(
                                  activeText: "Format audio",
                                  inactiveText: "Format video",
                                  value: typeFichier,
                                  valueFontSize: 16.0,
                                  width: 140,
                                  height: 30,
                                  borderRadius: 30.0,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      typeFichier = val;
                                    });
                                  },
                                ),
                                FlutterSwitch(
                                  activeText: "Panegyric",
                                  inactiveText: "Story",
                                  value: isPanegyric,
                                  valueFontSize: 16.0,
                                  width: 140,
                                  height: 30,
                                  borderRadius: 30.0,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      isPanegyric = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            CSCPicker(
                              onCountryChanged: (value) {
                                setState(() {
                                  countryValue = value;
                                  print(countryValue.substring(0, 3));
                                });
                              },
                              onStateChanged: (value) {
                                setState(() {
                                  stateValue = value.toString();
                                });
                              },
                              onCityChanged: (value) {
                                setState(() {
                                  cityValue = value.toString();
                                });
                              },
                              selectedItemStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              dropdownItemStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              dropdownHeadingStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            /*  Container(
                              child: TextFormField(
                                controller: country,
                                validator: (input) {
                                  if (input!.isEmpty) return 'Indiquez le pays';
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
                                    return 'Indiquez la r??gion';
                                  return null;
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  errorText: validate ? null : errorText,
                                  labelText: 'R??gion',
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
                            ), */
                            const SizedBox(height: 10),
                            const SizedBox(height: 40),
                            typeFichier
                                ? _recordProvider.recordedFilePath.isEmpty
                                    ? _recordingSection()
                                    : _audioPlayingSection()
                                : _recordProvider.recordedFilePath.isEmpty
                                    ? _recordingVideoNPickSection()
                                    : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:[ Icon(
                Icons.video_file,
                color: Colors.white,
                size: 22,
              ),_recordProvider.pickedVideoFilename.length>=20? Text(_recordProvider.pickedVideoFilename.substring(0,20), style:TextStyle(color: Colors.white, fontSize: 14)):Text(_recordProvider.pickedVideoFilename, style:TextStyle(color: Colors.white, fontSize: 14)), SizedBox(width: 1),
          GestureDetector(
              onTap: () {
                final _recordProvider =
                    Provider.of<RecordAudioProvider>(context, listen: false);
                _recordProvider.clearOldData();
              },
              child: Icon(
                Icons.delete_rounded,
                color: Colors.red,
                size: 35,
              ))] ),
                            if (_recordProvider.recordedFilePath.isNotEmpty &&
                                !_playProvider.isSongPlaying)
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
                                          onPressed: savePanegyrique,
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
          ),
        ));
  }
}
