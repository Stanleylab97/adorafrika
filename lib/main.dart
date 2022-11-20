import 'package:adorafrika/pages/account/abonnement.dart';
import 'package:adorafrika/pages/auth/create-new-account.dart';
import 'package:adorafrika/pages/auth/forgot-password.dart';
import 'package:adorafrika/pages/auth/login-screen.dart';
import 'package:adorafrika/pages/navigator/dashboard.dart';
import 'package:adorafrika/pages/navigator/navigation.dart';
import 'package:adorafrika/pages/panegyriques/create_panegyrique.dart';
import 'package:adorafrika/pages/player.dart';
import 'package:adorafrika/pages/projects/projectdetails.dart';
import 'package:adorafrika/pages/navigator/projects.dart';
import 'package:adorafrika/providers/play_audio_provider.dart';
import 'package:adorafrika/providers/record_audio_provider.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordAudioProvider()),
        ChangeNotifierProvider(create: (_) => PlayAudioProvider()),
      ],
//GetMaterialApp(
  child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.black,
                  displayColor: Colors.white,
                ),
            iconTheme: const IconThemeData(size: 22.0, color: Colors.black87),
            primaryColor: SizeConfig.primaryColor),
        home: const Navigation(),
        builder: EasyLoading.init(),
       /*  getPages: [
          GetPage(name: '/', page: () => const Navigation()),
          GetPage(name: '/player', page: () => const Player()),
          GetPage(name: '/playlist', page: () => const Navigation()),
          GetPage(name: '/createProject', page: () => const Navigation()),
          GetPage(name: '/projectsList', page: () => const Projects()),
          GetPage(name: '/projectsDetails', page: () => const ProjectDetails()),
          GetPage(name: '/CreateNewAccount', page: () => CreateNewAccount()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/ForgotPassword', page: () => ForgotPassword()),
          GetPage(name: '/abonnement', page: () => Abonnement()),
          GetPage(name: '/createPanegyrique', page: () => CreatePanegyrique()),   

        ] */
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "main",
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
