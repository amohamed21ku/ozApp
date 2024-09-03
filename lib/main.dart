import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oz/Screens/itemsScreen.dart';
import 'package:oz/Screens/usersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/balancesheet.dart';
import 'Screens/customerScreen.dart';
import 'Screens/homeScreen.dart';
import 'Screens/login_screen.dart';
import 'Screens/welcome_screen.dart';

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(apiKey:"AIzaSyDTLhv_YdM8Kas33R8tUdVm0S7SlBU2jWY",
  //       appId:  "1:111584263303:android:80582355518d46b5074c22",
  //       messagingSenderId: "111584263303",
  //       projectId:  "oozapp-94383")
  // );
  await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: "AIzaSyC5jqnQLoXXHnICVAgqmKEMTIIPCOIifAs",
          appId:   "1:648146955193:android:50dc26b187ddce90022468",
          messagingSenderId:  "648146955193",
          projectId: "ozapp-310aa")
  );
  // GsheetAPI().fetchDataFromFirestore();
  // GsheetAPI().fetchDataFromFirestore();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  SharedPreferences logindata = await SharedPreferences.getInstance();
  bool isNew = logindata.getBool('login') ?? true;

  runApp(MyApp(isNew: isNew));
}

class MyApp extends StatelessWidget {
  final bool isNew;

  const MyApp({super.key, required this.isNew});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      initialRoute: isNew ? 'welcomescreen' : 'homescreen',
      routes: {
        "welcomescreen": (context) => const WelcomeScreen(),
        "loginscreen": (context) => const LoginScreen(),
        "homescreen": (context) => const HomeScreen(),
        "itemsscreen": (context) => const ItemsScreen(),

        "customerscreen": (context) => const CustomerScreen(),
        "balancesheet": (context) => const BalanceSheet(),
        "usersscreen": (context) => const UsersScreen(),
      },
    );
  }
}