import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oz/Screens/itemsScreen.dart';

import 'Screens/customerScreen.dart';
import 'Screens/homeScreen.dart';
import 'Screens/loginScreen.dart';
import 'Screens/profileScreen.dart';
import 'Screens/welcomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyC5jqnQLoXXHnICVAgqmKEMTIIPCOIifAs",
        appId: "1:648146955193:android:50dc26b187ddce90022468",
        messagingSenderId: "648146955193",
        projectId: "ozapp-310aa")
  );


      runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
    initialRoute: 'welcomescreen',
    routes: {
    "welcomescreen": (context) => welcomeScreen(),
    "loginscreen": (context) => loginScreen(),
    "homescreen": (context) => homeScreen(),
    "itemsscreen": (context) => ItemsScreen(),
    "profilescreen": (context) => profileScreen(),
    "customerscreen": (context) => CustomerScreen(),
    },

      home:welcomeScreen(),
    );
  }
}
