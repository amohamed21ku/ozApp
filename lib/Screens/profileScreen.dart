import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class profileScreen extends StatefulWidget {


  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {




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
      body: Row(
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
                  backgroundImage: AssetImage('images/profile.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'AbdulAziz Ashi',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Abdulaziz@ozcevahir.com',
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
      ),

    );
  }
}
