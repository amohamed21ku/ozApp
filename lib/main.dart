import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oz/Screens/itemsScreen.dart';
import 'package:oz/Screens/usersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/balancesheet.dart';
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

  SharedPreferences logindata = await SharedPreferences.getInstance();
  bool isNew = logindata.getBool('login') ?? true;

  runApp(MyApp(isNew: isNew));
}

class MyApp extends StatelessWidget {
  final bool isNew;

  const MyApp({Key? key, required this.isNew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      initialRoute: isNew ? 'welcomescreen' : 'homescreen',
      routes: {
        "welcomescreen": (context) => welcomeScreen(),
        "loginscreen": (context) => loginScreen(),
        "homescreen": (context) => homeScreen(),
        "itemsscreen": (context) => ItemsScreen(),
        "profilescreen": (context) => profileScreen(),
        "customerscreen": (context) => CustomerScreen(),
        "balancesheet": (context) => BalanceSheet(),
        "usersscreen": (context) => UsersScreen(),
      },
    );
  }
}