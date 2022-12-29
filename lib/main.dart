import 'dart:async';
import 'dart:io';
import 'package:adorafrika/pages/navigator/home.dart';
import 'package:adorafrika/providers/user_info_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adorafrika/helpers/config.dart';
import 'package:adorafrika/helpers/countrycodes.dart';
import 'package:adorafrika/helpers/handle_native.dart';
import 'package:adorafrika/helpers/route_handler.dart';
import 'package:adorafrika/pages/account/abonnement.dart';
import 'package:adorafrika/pages/auth/create-new-account.dart';
import 'package:adorafrika/pages/auth/forgot-password.dart';
import 'package:adorafrika/pages/auth/login-screen.dart';
import 'package:adorafrika/pages/auth/pref.dart';
import 'package:adorafrika/pages/panegyriques/create_panegyrique.dart';
import 'package:adorafrika/pages/player.dart';
import 'package:adorafrika/pages/playlist/Player/audioplayer.dart';
import 'package:adorafrika/pages/projects/projectdetails.dart';
import 'package:adorafrika/pages/navigator/projects.dart';
import 'package:adorafrika/providers/play_audio_provider.dart';
import 'package:adorafrika/providers/record_audio_provider.dart';
import 'package:adorafrika/services/audio_service.dart';
import 'package:adorafrika/theme/app_theme.dart';
import 'package:adorafrika/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:audio_service/audio_service.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('adorAfrika');
  } else {
    await Hive.initFlutter();
  }
  await openHiveBox('settings');
  await openHiveBox('downloads');
  await openHiveBox('Favorite Songs');
  await openHiveBox('cache', limit: true);
  if (Platform.isAndroid) {
    setOptimalDisplayMode();
  }
  await startService();
    
  runApp(const MyApp());
  configLoading();
}

Future<void> setOptimalDisplayMode() async {
  final List<DisplayMode> supported = await FlutterDisplayMode.supported;
  final DisplayMode active = await FlutterDisplayMode.active;

  final List<DisplayMode> sameResolution = supported
      .where(
        (DisplayMode m) => m.width == active.width && m.height == active.height,
      )
      .toList()
    ..sort(
      (DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate),
    );

  final DisplayMode mostOptimalMode =
      sameResolution.isNotEmpty ? sameResolution.first : active;

  await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}

Future<void> startService() async {
  final AudioPlayerHandler audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.stanleylab.adorafrika.channel.audio',
      androidNotificationChannelName: 'adorAfrika',
      androidNotificationOngoing: true,
      androidNotificationIcon: 'drawable/ic_stat_music_note',
      androidShowNotificationBadge: true,
      // androidStopForegroundOnPause: Hive.box('settings')
      // .get('stopServiceOnPause', defaultValue: true) as bool,
      notificationColor: Colors.grey[900],
    ),
  );
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
  GetIt.I.registerSingleton<MyTheme>(MyTheme());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/AdorAfrika/$boxName.hive');
      lockFile = File('$dirPath/AdorAfrika/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
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
    ..maskColor = Colors.green.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

   static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');

  late StreamSubscription _intentDataStreamSubscription;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final String systemLangCode = Platform.localeName.substring(0, 2);
    if (ConstantCodes.languageCodes.values.contains(systemLangCode)) {
      _locale = Locale(systemLangCode);
    } else {
      final String lang =
          Hive.box('settings').get('lang', defaultValue: 'English') as String;
      _locale = Locale(ConstantCodes.languageCodes[lang] ?? 'en');
    }

    AppTheme.currentTheme.addListener(() {
      setState(() {});
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen(
      (String value) {
        handleSharedText(value, navigatorKey);
      },
      onError: (err) {
        // print("ERROR in getTextStream: $err");
      },
    );

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then(
      (String? value) {
        if (value != null) handleSharedText(value, navigatorKey);
      },
    );
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  Widget initialFuntion() {
    return Hive.box('settings').get('currentUser')['id'] != null
        ? HomePage()
        : PrefScreen();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppTheme.themeMode == ThemeMode.dark
            ? Colors.black38
            : Colors.white,
        statusBarIconBrightness: AppTheme.themeMode == ThemeMode.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness: AppTheme.themeMode == ThemeMode.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    /// LocalJsonLocalization.delegate.directories = ['assets/translations'];

     return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RecordAudioProvider()),
          ChangeNotifierProvider(create: (_) => PlayAudioProvider()),
          ChangeNotifierProvider(create: (_) => UserInformationProvider()),
 
        ],
//GetMaterialApp(
        child: 

     MaterialApp(
      title: 'adorAfrika',
      debugShowCheckedModeBanner: false,
      /* theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.white,
              ),
          iconTheme: const IconThemeData(size: 22.0, color: Colors.black87),
          primaryColor: SizeConfig.primaryColor),
      //home: const Navigation(), */
       themeMode: AppTheme.themeMode,
      theme: AppTheme.lightTheme(
        context: context,
      ),
      darkTheme: AppTheme.darkTheme(
        context: context,
      ),
      builder: EasyLoading.init(),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: ConstantCodes.languageCodes.entries
          .map((languageCode) => Locale(languageCode.value, ''))
          .toList(),
      routes: {
        '/': (context) => initialFuntion(),
        '/pref': (context) => const PrefScreen(),
        '/login': (context) =>  LoginScreen(),
      },
      navigatorKey: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return HandleRoute.handleRoute(settings.name);
      },
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
