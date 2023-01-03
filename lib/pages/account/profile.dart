import 'package:adorafrika/pages/auth/login-screen.dart';
import 'package:adorafrika/pages/services/networkHandler.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:profile/profile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  NetworkHandler networkHandler = NetworkHandler();
  Logger log = Logger();
  late String errorText = "";
  var box = Hive.box('settings');
  final currentUser = Hive.box('settings').get("currentUser") as Map;
  bool _isOpen = false;
  PanelController _panelController = PanelController();

  logout() async {
     Map<String, dynamic> data = {
      "id": currentUser['id'],
    };
    DataConnectionStatus status = await isConnected();
    if (status == DataConnectionStatus.connected) {}
    var response = await networkHandler
        .unsecurepost(NetworkHandler.baseurl + "/client/logout",data);
    log.v(response.statusCode);
    if (response.statusCode == 422) {
      errorText = response.data['message'];
      print(errorText);
      CherryToast.error(
              title: Text(errorText, style: TextStyle(color: Colors.black)),
              displayTitle: false,
              description: Text(errorText),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
    } else if (response.statusCode == 200) {
      if (response.data['statusCode'] == 422) {
        errorText = response.data['message'];
        CherryToast.error(
                title: Text(errorText, style: TextStyle(color: Colors.black)),
                displayTitle: false,
                description:
                    Text(errorText, style: TextStyle(color: Colors.black)),
                animationType: AnimationType.fromRight,
                animationDuration: Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(context);
      } else {

        Hive.box('settings').delete('currentUser');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }
  }

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  var _imageList = [
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
    'assets/images/header.jpg',
  ];

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://images.pexels.com/photos/1670045/pexels-photo-1670045.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),

          /// Sliding Panel
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
        ],
      ),
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************
  /// Panel Body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_imageList[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Action Section
  Row _actionSection({required double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.edit,
                size: 20.0,
              ),
              onPressed: () => _panelController.open(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              // borderSide: BorderSide(color: Colors.blue),
              label: Text(
                AppLocalizations.of(context)!.editProfil,
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: SizedBox(
            width: 16,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: TextButton.icon(
                icon: Icon(
                  Icons.logout,
                  size: 20.0,
                ),
                onPressed: () {
                  logout();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                label: Text(
                  AppLocalizations.of(context)!.logout,
                  style: TextStyle(
                    fontFamily: 'NimbusSanL',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info Section
  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _infoCell(
            title: AppLocalizations.of(context)!.username,
            value: currentUser['username']),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(
            title: AppLocalizations.of(context)!.subscription,
            value: "Active "),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(
            title: AppLocalizations.of(context)!.location, value: 'Dusseldorf'),
      ],
    );
  }

  /// Info Cell
  Column _infoCell({required String title, required String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: Colors.black),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black),
        ),
      ],
    );
  }

  /// Title Section
  Column _titleSection() {
    return Column(
      children: <Widget>[
        Text(
          currentUser['nom'],
          style: TextStyle(
              fontFamily: 'NimbusSanL',
              fontWeight: FontWeight.w700,
              fontSize: 30,
              color: Colors.black),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          currentUser['prenom'],
          style: TextStyle(
              fontFamily: 'NimbusSanL',
              fontWeight: FontWeight.w700,
              fontSize: 23,
              color: Colors.black),
        ),
      ],
    );
  }
}
