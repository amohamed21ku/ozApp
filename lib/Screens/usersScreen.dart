import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/infocard.dart';
import '../models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<myUser> users = [];
  bool showSpinner = false; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    setState(() {
      showSpinner = true; // Show loading HUD
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      users = querySnapshot.docs.map((doc) {
        final name = doc['name'] as String;
        final email = doc['email'] as String;
        final username = doc['username'] as String;
        final password = doc['password'] as String;
        final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '';
        return myUser(
          name: name,
          email: email,
          initial: initial,
          username: username,
          password: password,
        );
      }).toList();
    } catch (error) {
      print('Error fetching customers: $error');
    }

    setState(() {
      showSpinner = false; // Hide loading HUD
    });
  }

  Future<void> _handleRefresh() async {
    await fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xffa4392f),
        title: Text(
          'Users',
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffa4392f),
        onPressed: () {
          // Add functionality to add new customers here
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa4392f)), // Change spinner color to theme color
          strokeWidth: 5.0, // Adjust spinner thickness if needed
        ),
        inAsyncCall: showSpinner,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Color(0xffa4392f), // Change refresh indicator color to theme color
          backgroundColor: Colors.grey[200], // Change background color of refresh indicator
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Users List',
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return infoCard(
                        name: user.name,
                        company: user.email,
                        onpress: () {
                          print(user.name);
                        },
                        initial: user.initial,
                        customerId: '', // Assuming this is needed for the infoCard widget
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
