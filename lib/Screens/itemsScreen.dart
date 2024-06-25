import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edititemscreen.dart';
import 'itemDetails.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  bool showDateColumn = false; // Track visibility of Date column

  @override
  void initState() {
    super.initState();
    fetchDataFromCache();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    setState(() => isLoading = true);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('items').get();

    dataList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['id'] = doc.id; // Add the document ID to the data
      return data;
    }).toList();

    // Sort dataList based on "kodu" field
    dataList.sort((a, b) => a['kodu'].compareTo(b['kodu']));

    filteredList = dataList;

    // Cache the data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('itemsData', dataList.toString());

    setState(() => isLoading = false);
  }

  Future<void> fetchDataFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('itemsData');
    if (cachedData != null) {
      dataList = List<Map<String, dynamic>>.from(
        jsonDecode(cachedData).map((item) => Map<String, dynamic>.from(item)),
      );
      setState(() => filteredList = dataList);
    }
  }

  void filterData(String query) {
    setState(() {
      filteredList = dataList
          .where((item) =>
      item['kodu'].toLowerCase().contains(query.toLowerCase()) ||
          item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleDateColumnVisibility() {
    setState(() {
      showDateColumn = !showDateColumn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xffa4392f),
        title: Text(
          'Items Screen',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditItemScreen()),
              ).then((value) {
                // This code runs when EditItemScreen is popped and control returns to this screen
                fetchDataFromFirestore();
              });
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa4392f)),
          strokeWidth: 5.0,
        ),
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: fetchDataFromFirestore,
          color: const Color(0xffa4392f),
          backgroundColor: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: filterData,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Search by Kodu or Name',
                        hintStyle:
                        GoogleFonts.poppins(fontWeight: FontWeight.w200),
                        labelStyle: GoogleFonts.poppins(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffa4392f), width: 2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Item Count: ${filteredList.length}',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: toggleDateColumnVisibility,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: toggleDateColumnVisibility,
                                icon: Icon(
                                  size: 20,
                                  showDateColumn
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xffa4392f),
                                ),
                              ),
                              Text(
                                showDateColumn ? 'Hide Date' : 'Show Date',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xffa4392f),
                                  fontSize:
                                  14, // Adjust font size as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                color: const Color(0xffa4392f), // Set background color
                margin:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Kodu",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Name",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Eni",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Gramaj",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Price",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      if (showDateColumn) // Show Date column only if showDateColumn is true
                        const Expanded(
                          child: Text(
                            "Date",
                            style: TextStyle(
                              color: Colors.white, // Set text color to white
                              fontWeight: FontWeight.bold, // Make text bold
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailsScreen(
                              item: filteredList[index],
                              docId: filteredList[index]['id'], // Pass the document ID
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  filteredList[index]['kodu'].toString(),
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  filteredList[index]['name'].toString(),
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${filteredList[index]['eni']} ',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${filteredList[index]['gramaj']} ',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${filteredList[index]['current price']}',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                              if (showDateColumn) // Show Date value only if showDateColumn is true
                                Expanded(
                                  child: Text(
                                    filteredList[index]['current tarih'].toString(),
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
