import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:adorafrika/models/categorie_music.dart';
import 'package:adorafrika/models/rythme_musical.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:adorafrika/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path/path.dart' as pathfile;

class AddMusic extends StatefulWidget {
  const AddMusic({Key? key}) : super(key: key);

  @override
  State<AddMusic> createState() => _AddMusicState();
}

class _AddMusicState extends State<AddMusic> with WidgetsBindingObserver {
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController yearproduction = TextEditingController();
  TextEditingController blazArtistCtrl = TextEditingController();
  TextEditingController language = TextEditingController();
  TextEditingController pays = TextEditingController();
  bool isTraditional = true;
  int idRythme = 0;
  String codepays = "";
  ImagePicker picker = ImagePicker();
  late File _videoselected = File("");
  late File _audioselected = File("");
  var coverImage;
  final countryPicker = const FlCountryCodePicker();
  bool iscovered = false;
  bool isfilechoosen = false;
  VideoPlayerController? _videoPlayerController;
  bool validate = false;
  Logger log = Logger();
  late String errorText = "";
  bool isloading = false;
  late final PlayerController playerController;

  String? path;
  String? musicFile;
  bool isRecording = false;
  late Directory appDirectory;

  late SingleValueDropDownController _cnt;
  Widget card(
      {String? type, int? index, String? text, StateSetter? setModalState}) {
    return GestureDetector(
      onTap: () {
        setModalState!(() {
          plan = index!;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                width: 2,
                color: index == plan
                    ? SizeConfig.primaryColor
                    : Color(0xff25232c))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(type!,
                    style: TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700)),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: index == plan
                              ? SizeConfig.primaryColor
                              : Colors.grey,
                          width: index == plan ? 6 : 2)),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            /*  Text(
                text!,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white),
              ), */
          ],
        ),
      ),
    );
  }

  //Audio player code
  void _playOrPausePlayer(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);
  }

  Future<ByteData> _loadAsset(String path) async {
    return await rootBundle.load(path);
  }

  void _preparePlayers(File file) async {
    ///audio-1
    final file1 = file;
    await file1.writeAsBytes(
        (await _loadAsset('assets/audios/audio1.mp3')).buffer.asUint8List());
    playerController.preparePlayer(file1.path);
  }

  //End Audio player

  bool isNotNull(String? input) {
    return input?.isNotEmpty ?? false;
  }

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  saveMusic() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = Hive.box('settings').get('currentUser')['id'].toString();

    setState(() {
      isloading = true;
    });

    if ((isfilechoosen || iscovered) &&
        idRythme != 0 &&
        titleCtrl.text.length >= 3) {
      if (_videoselected.path.isNotEmpty || _audioselected.path.isNotEmpty) {
        DataConnectionStatus status = await isConnected();

        if (status == DataConnectionStatus.connected) {
          /*    var data = {
            "typefile": plan == 0 ? "AUDIO" : "VIDEO",
            "statut": "NOUVEAU",
            "country": pays.text.trim(),
            "titre": titleCtrl.text.trim(),
            "blazartiste": blazArtistCtrl.text.trim(),
            "compte_clients_id": int.parse(userId),
            "categories_id": idCategory,
            "yearofproduction": yearproduction.text.length == 4
                ? int.parse(yearproduction.text.trim())
                : 1974,
          };
          print(data); */
          // Map<String, String> obj = {"musicData": json.encode(data).toString()};
          var request = http.MultipartRequest(
              'POST', Uri.parse(NetworkHandler.baseurl + "/musique/creation"));
          request.files.add(await http.MultipartFile.fromPath("fichier",
              plan == 0 ? _audioselected.path : _videoselected.path));
          if (iscovered) {
            request.files.add(await http.MultipartFile.fromPath(
                "thumbnail", coverImage.path));
          } else {
            request.fields['thumbnail'] = "";
          }
          request.fields['typefile'] = plan == 0 ? "AUDIO" : "VIDEO";
          request.fields['statut'] = "NOUVEAU";
          request.fields['country_libelle'] = pays.text.trim();
          request.fields['country_code'] = codepays;
          request.fields['titre'] = titleCtrl.text.trim();
          request.fields['blazartiste'] = blazArtistCtrl.text.trim();
          request.fields['compte_clients_id'] = userId;
          request.fields['categorie'] =
              isTraditional ? 0.toString() : 1.toString();
          request.fields['rythme_musicals_id'] = idRythme.toString();
          request.fields['yearofproduction'] = yearproduction.text.length == 4
              ? yearproduction.text.trim().toString()
              : "1974";

          request.headers.addAll({
            "Content-type": "multipart/form-data",
            //"Authorization": "Bearer $token"
          });
          EasyLoading.show(status: 'Chargement du fichier...');

          try {
            final streamedResponse = await request.send();

            final response = await http.Response.fromStream(streamedResponse);
            if (response.statusCode == 200 || response.statusCode == 201) {
              Map<String, dynamic> output = json.decode(response.body);
              EasyLoading.showSuccess('Musique enregistr??e!');
              print("Upload done");
              EasyLoading.dismiss();
              setState(() {
                isloading = false;
              });
              playerController.stopAllPlayers();
              playerController.dispose();

              Navigator.pop(context);
            } else {
              print("response ${response.body}");
              if (response.statusCode == 500) {
                Map<String, dynamic> output = json.decode(response.body);

                log.e(output);
                setState(() {
                  validate = false;
                  errorText = output['statusText'];

                  CherryToast.error(
                          title: Text("Erreur"),
                          displayTitle: false,
                          description: Text(errorText,
                              style: TextStyle(color: Colors.black)),
                          animationType: AnimationType.fromRight,
                          animationDuration: Duration(milliseconds: 1000),
                          autoDismiss: true)
                      .show(context);
                  isloading = false;
                });
              }
            }
          } catch (e) {
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
                description: Text("Il manque au moins un fichier ?? charger",
                    style: TextStyle(color: Colors.black)),
                animationType: AnimationType.fromRight,
                animationDuration: Duration(milliseconds: 2000),
                autoDismiss: true)
            .show(context);
        // print("Il manque au moins un fichier ?? charger");

      }
    } else {
      setState(() {
        isloading = false;
      });
      CherryToast.error(
              title: Text("Erreur"),
              displayTitle: false,
              description: Text("Il manque des donn??es importantes",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 2000),
              autoDismiss: true)
          .show(context);
    }
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

  loadVideoPlayer(File file) {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

    _videoPlayerController = VideoPlayerController.file(file);
    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  _pickVideo() async {
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoselected = File(pickedFile.path);
        loadVideoPlayer(_videoselected);
      });
    } else {
      print('No video picked');
    }

    _videoPlayerController = VideoPlayerController.file(_videoselected)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
    print("Chemin: ${_videoselected.path}");
  }

  _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'aac', 'wav'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String dir = pathfile.dirname(file.path);
      String newPath = pathfile.join(
          dir,
          (DateTime.now().microsecond.toString()) +
              '.' +
              file.path.split('.').last);
      File f = await File(file.path).copy(newPath);
      await playerController.preparePlayer(f.path);
      setState(() {
        isfilechoosen = true;
        _audioselected = f;
      });
      _playOrPausePlayer(playerController);
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

  List<Step> getSteps() => [
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            title: Text('Cat??gorisation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            content: Column(children: [
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
        padding: EdgeInsets.all(14.0),
        child: Center(
          child: Text('Quel est la cat??gorie de la musique ?',
              style: TextStyle(fontSize: 15)),
        )
          ),
                           Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
            
              children: [
                Radio(
                  value: true,
                  groupValue: isTraditional,
                  onChanged: (val) {
                    setState(() {
                      isTraditional = val as bool;
                      
                    });
                  },
                ), Text(
              'Normal',
              style: new TextStyle(fontSize: 17.0),
            ),
 

              ],
            ),
           
            Row(
              children: [
                Radio(
                  value: false,
                  groupValue: isTraditional,
                  onChanged: (val) {
                    setState(() {
                       isTraditional = val as bool;
                    });
                  },
                ),
                Text(
              'R??ligieux',
              style: new TextStyle(
                fontSize: 17.0,
              ),
            ),
              ],
            ),
            
            
           
          ],
        ),
                        Text('Quel est le format du fichier ?',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          SizedBox(
                            height: 12,
                          ),
                          card(
                              index: 0,
                              text: '\$2/mois',
                              type: 'Audio',
                              setModalState: setModalState),
                          SizedBox(
                            height: 10,
                          ),
                          card(
                              index: 1,
                              text: '\$10/mois',
                              type: 'Vid??o',
                              setModalState: setModalState),
                          SizedBox(
                            height: 10,
                          ),
                        ]));
              }),
              SizedBox(
                height: 10,
              ),
              DropdownSearch<RythmeMusical>(
                itemAsString: (RythmeMusical u) => u.userAsString(),
                popupProps: PopupProps.menu(
                    showSearchBox: true,
                    menuProps: MenuProps(
                      elevation: 8,
                    )),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "D??finissez le rythme musical",
                      labelStyle: TextStyle(color: Colors.white)),
                ),
                asyncItems: (String filter) async {
                  var response = await Dio().get(
                    "https://backend.adorafrika.com/api/rythme",
                    queryParameters: {"libelle": filter},
                  );
                  print(response.data['rythmes']);
                  var models =
                      RythmeMusical.fromJsonList(response.data['rythmes']);
                  return models;
                },
                onChanged: (RythmeMusical? data) {
                  setState(() {
                    idRythme = data!.id;
                    print(idRythme);
                  });
                },
              )
            ]),
            isActive: currentStep >= 1),
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            title: Text('Identification',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            content: Column(
              children: [
                TextFormField(
                  controller: titleCtrl,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Titre de la chanson'),
                ),
                TextFormField(
                  controller: blazArtistCtrl,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: "Nom de l'artiste"),
                ),
                TextFormField(
                  controller: yearproduction,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Ann??e de production"),
                )
              ],
            ),
            isActive: currentStep >= 0),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            title: Text('Couverture',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            content: Column(children: [
              Center(
                  child: iscovered
                      ? Card(
                          elevation: 10,
                          child: GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * .6,
                              height: MediaQuery.of(context).size.height * .3,
                              child: Image.file(coverImage),
                            ),
                            onTap: () {},
                          ),
                        )
                      : GestureDetector(
                          child: Card(
                            elevation: 10,
                            child: Container(
                                width: MediaQuery.of(context).size.width * .6,
                                height: MediaQuery.of(context).size.height * .3,
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
              TextFormField(
                controller: language,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Langue"),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: codepays.isEmpty
                    ? FloatingActionButton.extended(
                        heroTag: "selection-country",
                        elevation: 8,
                        label: Text(
                          'S??lectionnez le pays',
                          style: TextStyle(color: Colors.black),
                        ), // <-- Text
                        backgroundColor: Colors.white,
                        icon: Icon(
                          // <-- Icon
                          FontAwesomeIcons.flag,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          final code =
                              await countryPicker.showPicker(context: context);
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
                          final code =
                              await countryPicker.showPicker(context: context);
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
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(labelText: "Pays s??ctionn??"),
                        ),
                      ),
              )
            ]),
            isActive: currentStep >= 2),
        Step(
            state: currentStep > 3 ? StepState.complete : StepState.indexed,
            title: Text('Chargement',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            content: plan == 1
                ? Column(children: [
                    if (_videoselected.path != null)
                      _videoPlayerController != null
                          ? AspectRatio(
                              aspectRatio:
                                  _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController!))
                          : Center(
                              child: FloatingActionButton.extended(
                                heroTag: "select-video",
                                label: Text(
                                  'S??lectionnez la vid??o',
                                  style: TextStyle(color: Colors.black),
                                ), // <-- Text
                                backgroundColor: Colors.white,
                                icon: Icon(
                                  // <-- Icon
                                  Icons.upload_rounded,
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  if (plan == 0)
                                    _pickAudio();
                                  else
                                    _pickVideo();
                                },
                              ),
                            )
                    else
                      SizedBox(
                        width: MediaQuery.of(context).size.height * .1,
                      ),
                  ])
                : Column(children: [
                    if (_audioselected.path != null)
                      isfilechoosen
                          ? Center(
                              child: AudioFileWaveforms(
                                  enableSeekGesture: true,
                                  size: Size(
                                      MediaQuery.of(context).size.width, 100.0),
                                  playerController: playerController,
                                  density: 1.5,
                                  playerWaveStyle: const PlayerWaveStyle(
                                      scaleFactor: 0.8,
                                      fixedWaveColor: Colors.red,
                                      liveWaveColor: Colors.yellow,
                                      waveCap: StrokeCap.butt)),
                            )
                          : Center(
                              child: FloatingActionButton.extended(
                                heroTag: "select-fichierr",
                                label: Text('S??lectionnez le fichier',
                                    style: TextStyle(
                                        color: Colors.black)), // <-- Text
                                backgroundColor: Colors.white,
                                icon: Icon(
                                  // <-- Icon
                                  Icons.upload_rounded,
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  _pickAudio();
                                },
                              ),
                            )
                    else
                      SizedBox(
                        width: MediaQuery.of(context).size.height * .1,
                      ),
                  ]),
            isActive: currentStep >= 3),
      ];
  int currentStep = 0;
  bool isCompleted = false;
  int plan = 0;
  late PermissionStatus _permissionStatus;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
    () async {
      _permissionStatus = await Permission.storage.status;

      if (_permissionStatus != PermissionStatus.granted) {
        PermissionStatus permissionStatus = await Permission.storage.request();
        setState(() {
          _permissionStatus = permissionStatus;
        });
      }
    }();
    playerController = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() async {
    playerController.stopAllPlayers();
    playerController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      playerController.dispose();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Material(
      color: Colors.black,
      child: Theme(
        data: AppTheme.darkTheme(
          context: context,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 10),
              child: Column(
                children: [
                  Center(
                    child: Text("Chargement de musique",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "adorAfrika vous permet de charger la musique que vous aimez gratuitement",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            Stepper(
              steps: getSteps(),
              type: StepperType.vertical,
              currentStep: currentStep,
              onStepTapped: (step) => setState(() {
                currentStep = step;
              }),
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                if (isLastStep) {
                  setState(() {
                    isCompleted = true;
                  });
                  saveMusic();
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if (currentStep == 0) {
                  null;
                } else {
                  setState(() {
                    currentStep -= 1;
                  });
                }
              },
              controlsBuilder: (context, ControlsDetails controls) {
                final isLastStep = currentStep == getSteps().length - 1;

                return Container(
                    margin: EdgeInsets.only(
                      top: 50,
                    ),
                    child: Row(children: [
                      if (currentStep != 0)
                        Expanded(
                            child: ElevatedButton(
                                child: Text("Pr??c??dant"),
                                onPressed: controls.onStepCancel)),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: isloading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.red))
                              : ElevatedButton(
                                  child:
                                      Text(isLastStep ? "Envoyer" : "Suivant"),
                                  onPressed: controls.onStepContinue)),
                    ]));
              },
            ),
            Container(
              height: 600,
            )
          ],
        ),
      ),
    ));
  }
}
