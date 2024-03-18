import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components.dart';
import '../constants.dart';
import '../models/components/square_tile.dart';

class loginScreen extends StatefulWidget {
  loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  String username = '';
  String pass = '';

  late AnimationController controller;
  late Animation<Color?> animation;
  late Animation<Color?> animation2;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    controller.forward();
    animation = ColorTween(begin: Color(0xffa4392f), end: Colors.black)
        .animate(controller);
    animation2 = ColorTween(begin: Colors.white, end: Color(0xffa4392f))
        .animate(controller);

    controller.addListener(() {
      setState(() {});
    });
  }

  void _signInWithGoogle() async {
    setState(() {
      showSpinner = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;

        final snapshot = await FirebaseFirestore.instance
            .collection('residents')
            .where('email', isEqualTo: user!.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          Navigator.pushNamed(context, "homescreen");
        } else {
          // Navigator.pushNamed(context, "homescreen");
        }
      }

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: ModalProgressHUD(

                  progressIndicator: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa4392f)), // Change spinner color to red
                    strokeWidth: 5.0, // Adjust spinner thickness if needed
                  ),
                  inAsyncCall: showSpinner,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40,),
                        Container(
                          height: 70,
                          child: Hero(
                            tag: 'logo',
                            child: Image.asset(
                              'images/logo2.jpg',
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Access account',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              TextField(
                                style: GoogleFonts.poppins(color: Colors.black, fontSize: 18), // Increase font size
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  username = value;
                                },
                                decoration: kTextfielDecoration.copyWith(
                                  hintText: "Enter your Username",
                                  prefixIcon: Icon(
                                    Icons.perm_identity,
                                    color: Colors.grey,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Increase padding
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10), // Rounded border
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0, // Increase spacing
                              ),
                              TextField(
                                style: GoogleFonts.poppins(color: Colors.black, fontSize: 18), // Increase font size
                                obscureText: true,
                                onChanged: (value) {
                                  pass = value;
                                },
                                decoration: kTextfielDecoration.copyWith(
                                  hintText: "Enter your Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Increase padding
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10), // Rounded border
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),

                              RoundedButton(
                                title: 'Login',
                                colour: Color(0xffa4392f),
                                animation2: animation2,
                                animation: animation,
                                onPressed: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });

                                  try {
                                    final snapshot = await FirebaseFirestore
                                        .instance
                                        .collection('users')
                                        .where('username', isEqualTo: username)
                                        .where('password', isEqualTo: pass)
                                        .get();

                                    if (snapshot.docs.isNotEmpty) {
                                      Navigator.pushNamed(context, "homescreen");
                                    }
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } catch (e) {
                                    Navigator.pushNamed(context, "homescreen");
                                    print('Error: $e');
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }
                                },
                                icon: Icons.arrow_forward,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "signupscreen");
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?  ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Signup',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:  Color(0xffa4392f),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 30,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      'Or continue with',
                                      style: GoogleFonts.poppins(color: Colors.grey[700]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:  [
                                        // google button
                                        SquareTile(imagePath: 'images/google.png', ontap: _signInWithGoogle,),

                                        SizedBox(width: 40),

                                        // apple button
                                        SquareTile(imagePath: 'images/apple.png', ontap: () {  },)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
