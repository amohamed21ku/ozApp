import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profileScreen extends StatefulWidget {
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = _firestore.collection('users').doc('RYEuRZLOOT0zEX4Dlszr').snapshots();
    // Replace 'YOUR_USER_ID' with the actual user ID in Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xffa4392f),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          var userData = snapshot.data!.data();
          var username = userData!['username'];
          var email = userData['email'];
          var profilePicture = userData['profilePicture'];

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Hero(
                    tag: 'profile_pic',
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: profilePicture =NetworkImage(profilePicture)
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    username,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Logout logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffa4392f),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
