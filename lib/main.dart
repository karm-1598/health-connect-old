import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect2/config/themeData.dart';
import 'package:health_connect2/controllers/theme_controller.dart';
// import 'package:health_connect2/notification_services.dart';
import 'package:health_connect2/routes/app_navigator.dart';
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
    themeData themeController=Get.put(themeData());
    return Obx(()=>GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.theme,
      home: Splash(),
    ));
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
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void getData() async {
    var prefs = await SharedPreferences.getInstance();
    bool logincheck = prefs.getBool('keepLogedIn') ?? false;
    bool logincheck2 = prefs.getBool('keepLogedIn2') ?? false;

    print(logincheck);
    print(logincheck2);

    if (logincheck) {
      goto.gobackHome();
      print('User');
      
    } else if(logincheck2){
      goto.openProviderHome();
      print('Provider');
    } else {
      goto.openUserOrProvider();
    }
  }
}
