import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oz/Screens/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/todo.dart';
import '../components.dart';
import '../models/user.dart';

class homeScreen extends StatefulWidget {
  final myUser? currentUser;

  homeScreen({this.currentUser});

  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late SharedPreferences logindata;
  late String username;
  late String password;
  late String name;
  late String email;
  late myUser current_user;

  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initial();
    if (widget.currentUser != null) {
      current_user = widget.currentUser!;
    } else {
      current_user = myUser(
        username: 'default_username',
        password: 'default_password',
        name: 'Default Name',
        email: 'default@example.com',
        initial: 'D',
      );
    }
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
      password = logindata.getString('password')!;
      email = logindata.getString('email')!;
      name = logindata.getString('name')!;
      current_user = myUser(username: username, password: password, name: name, email: email, initial: name[0]);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => loginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          buildHomePage(),
          buildToDoPage(),
          buildProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'ToDo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xffa4392f),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildHomePage() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white10, Colors.white],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38,
                                ),
                              ),
                              Text(
                                current_user.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              _onItemTapped(2);
                            },
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Hero(
                                tag: 'profile_pic',
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: AssetImage('images/profile.jpg'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButtonSmall(
                            colour: Colors.white,
                            title: 'Items',
                            onPressed: () {
                              Navigator.pushNamed(context, 'itemsscreen');
                            },
                            width: 10,
                            height: 100,
                            icon: Icons.list_alt,
                            iconColor: Color(0xffa4392f),
                            textcolor: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RoundedButtonSmall(
                            colour: Colors.white,
                            title: 'Customers',
                            onPressed: () {
                              Navigator.pushNamed(context, 'customerscreen');
                            },
                            width: 0,
                            height: 100,
                            icon: Icons.person,
                            iconColor: Color(0xffa4392f),
                            textcolor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButtonSmall(
                            colour: Colors.white,
                            title: 'Sheet',
                            onPressed: () {
                              Navigator.pushNamed(context, "balancesheet");
                              // Handle sheet button tap
                            },
                            width: 10,
                            height: 100,
                            icon: Icons.newspaper,
                            iconColor: Color(0xffa4392f),
                            textcolor: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RoundedButtonSmall(
                            colour: Colors.white,
                            title: 'Users',
                            onPressed: () {
                              Navigator.pushNamed(context, "usersscreen");
                              // Navigate to customers screen
                            },
                            width: 0,
                            height: 100,
                            icon: Icons.supervised_user_circle_outlined,
                            iconColor: Color(0xffa4392f),
                            textcolor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          RoundedButtonSmall(
                            colour: Color(0xffa4392f),
                            title: 'Add requested Sample by Customer',
                            onPressed: () {
                              Navigator.pushNamed(context, "customerscreen");
                            },
                            width: 0,
                            height: 50,
                            icon: Icons.add,
                            iconColor: Colors.white,
                            textcolor: Colors.white,
                          ),
                          RoundedButtonSmall(
                            colour: Color(0xffa4392f),
                            title: 'Add given Sample',
                            onPressed: () {
                              // Navigate to advanced search page
                            },
                            width: 0,
                            height: 50,
                            icon: Icons.add_box,
                            iconColor: Colors.white,
                            textcolor: Colors.white,
                          ),
                          RoundedButtonSmall(
                            colour: Color(0xffa4392f),
                            title: 'Random Data',
                            onPressed: () {
                              // Navigate to query screen
                            },
                            width: 0,
                            height: 50,
                            icon: Icons.book,
                            iconColor: Colors.white,
                            textcolor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildToDoPage() {
    return ToDoPage();  // Define the ToDoPage below or import it if it's defined elsewhere
  }

  Widget buildProfilePage() {
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
        automaticallyImplyLeading: false, // This line removes the default arrow icon
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
                current_user.name,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                current_user.email,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _logout(context),
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
