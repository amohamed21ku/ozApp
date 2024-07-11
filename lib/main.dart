import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oz/Screens/itemsScreen.dart';
import 'package:oz/Screens/usersScreen.dart';
import 'package:oz/models/GsheetAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/balancesheet.dart';
import 'Screens/customerScreen.dart';
import 'Screens/homeScreen.dart';
import 'Screens/login_screen.dart';
import 'Screens/profile_screen.dart';
import 'Screens/welcome_screen.dart';

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyD4EvUylj5qVZaIgRksLpQQnbfMdfrC9_Q",
        appId: "1:995891442462:android:350e0338e00eda4f6b0f0f",
        messagingSenderId: "995891442462",
        projectId: "ozcevahir-333a5")
  );
  GsheetAPI().uploadDataToFirestore();
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
        "profilescreen": (context) => const ProfileScreen(),
        "customerscreen": (context) => const CustomerScreen(),
        "balancesheet": (context) => const BalanceSheet(),
        "usersscreen": (context) => const UsersScreen(),
      },
    );
  }
}