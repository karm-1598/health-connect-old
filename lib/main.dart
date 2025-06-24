import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect2/home.dart';
// import 'package:health_connect2/notification_services.dart';
import 'package:health_connect2/provider_home.dart';
import 'package:health_connect2/user_or_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
}
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Questrial',
        primaryColorDark: Colors.black
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? _timer;

// NotificationServices notificationServices =NotificationServices();
  @override
  void initState() {
    super.initState();
    //  notificationServices.requestPermission();
    // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value){
    //   print('Device Token');
    //   print(value);
    // });
    // notificationServices.firebaseInit(context);
    // notificationServices.setupInteractMessage(context);
    _timer = Timer(
      Duration(seconds: 2),
      getData,
    );
    
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/healthconnect_logo.png',
          height: 150,
          width: 150,
        ),
      ),
    );
  }

  void getData() async {
    var prefs = await SharedPreferences.getInstance();
    bool logincheck = prefs.getBool('keepLogedIn') ?? false;
    bool logincheck2 = prefs.getBool('keepLogedIn2') ?? false;

    if (logincheck) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => home_screen()),
      );
    } else if(logincheck2){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ProviderHome()),
      );
    } else {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => UserOrProvider()),
      );
    }
  }
}
