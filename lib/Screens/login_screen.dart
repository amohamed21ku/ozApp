import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oz/Screens/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  String username = '';
  String pass = '';
  late SharedPreferences logindata;
  late bool isnew;

  // late AnimationController controller;
  // late Animation<Color?> animation;
  // late Animation<Color?> animation2;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
    // controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 1),
    // );
    // controller.forward();
  //   animation = ColorTween(begin: Color(0xffa4392f), end: Colors.black).animate(controller);
  //   animation2 = ColorTween(begin: Colors.white, end: Color(0xffa4392f)).animate(controller);
  //
  //   controller.addListener(() {
  //     setState(() {});
  //   });
  }


  // void _signInWithGoogle() async {
  //   setState(() {
  //     showSpinner = true;
  //   });
  //
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //
  //       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //       final user = userCredential.user;
  //
  //       final snapshot = await FirebaseFirestore.instance.collection('residents').where('email', isEqualTo: user!.email).get();
  //
  //       if (snapshot.docs.isNotEmpty) {
  //         // final currentUser = myUser(
  //         //   username: user.uid,
  //         //   email: '', password:'' , name: '', initial: '',
  //         //   // add other necessary fields
  //         // );
  //         Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => const HomeScreen(),
  //         ));
  //       }
  //
  //       setState(() {
  //         showSpinner = false;
  //       });
  //     }
  //   } catch (e) {
  //     // print('Error: $e');
  //     setState(() {
  //       showSpinner = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
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
                progressIndicator: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa4392f)), // Change spinner color to red
                  strokeWidth: 5.0, // Adjust spinner thickness if needed
                ),
                inAsyncCall: showSpinner,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 40,),
                      SizedBox(
                        height: 70,
                        child: Hero(
                          tag: 'logo',
                          child: Image.asset(
                            'images/logo2.jpg',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Expanded(
                        flex:1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                const SizedBox(height: 20,),
                              ],
                            ),
                          ],
                        ),
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
                                prefixIcon: const Icon(
                                  Icons.perm_identity,
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Increase padding
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), // Rounded border
                                ),
                              ),
                            ),
                            const SizedBox(
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
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Increase padding
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), // Rounded border
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),

                            RoundedButton(
                              title: 'Login',
                              colour: const Color(0xffa4392f),

                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });

                                try {
                                  final snapshot = await FirebaseFirestore.instance
                                      .collection('users')
                                      .where('username', isEqualTo: username)
                                      .where('password', isEqualTo: pass)
                                      .get();

                                  if (snapshot.docs.isNotEmpty) {
                                    final userData = snapshot.docs.first.data();
                                    // final currentUser = myUser(
                                    //   name: userData['name'],
                                    //   email: userData['email'],
                                    //   username: userData['username'],
                                    //   password: userData['password'], initial: '${userData['name'][0]}',
                                    // );
                                    logindata.setBool('login', false);
                                    logindata.setString('username', userData['username']);
                                    logindata.setString('password', userData['password']);
                                    logindata.setString('name', userData['name']);
                                    logindata.setString('email', userData['email']);
                                    logindata.setString("id",  snapshot.docs.first.id);
                                    logindata.setString('profilePic', userData['profilePicture']);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));

                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen()));
                                  } else {
                                    // Handle the case where no matching user is found
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Invalid username or password')),
                                    );
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } catch (e) {
                                  // print('Error: $e');
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
                                      color: Colors.black26,
                                    ),
                                  ),
                                  Text(
                                    'Signup',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xffa4392f),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // const SizedBox(height: 30,),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Divider(
                            //         thickness: 0.5,
                            //         color: Colors.grey[400],
                            //       ),
                            //     ),
                            //     Padding(
                            //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            //       child: Text(
                            //         'Or continue with',
                            //         style: GoogleFonts.poppins(color: Colors.grey[700]),
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: Divider(
                            //         thickness: 0.5,
                            //         color: Colors.grey[400],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 20,),
                            // Expanded(
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           // google button
                            //           SquareTile(imagePath: 'images/google.png', ontap: _signInWithGoogle,),
                            //
                            //           const SizedBox(width: 40),
                            //
                            //           // apple button
                            //           SquareTile(imagePath: 'images/apple.png', ontap: () {},)
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
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
    );
  }

  Future<void> checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    isnew = (logindata.getBool('login') ?? true);
    // print("new user");
    if(isnew == false){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }
}
