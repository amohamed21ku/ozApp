import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

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
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    setState(() => isLoading = true);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('items').get();

    dataList = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Sort dataList based on "kodu" field
    dataList.sort((a, b) => a['kodu'].compareTo(b['kodu']));

    filteredList = dataList;

    setState(() => isLoading = false);
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

  Future<void> updateData(int index, String key, String newValue) async {
    setState(() => isLoading = true);

    try {
      String docId = dataList[index]['docId'];
      await FirebaseFirestore.instance
          .collection('items')
          .doc(docId)
          .update({key: newValue});

      setState(() {
        dataList[index][key] = newValue;

        // Sort dataList again based on "kodu" field after update
        dataList.sort((a, b) => a['kodu'].compareTo(b['kodu']));

        filteredList = dataList;
      });
    } catch (e) {
      print('Error updating document: $e');
    } finally {
      setState(() => isLoading = false);
    }
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
        backgroundColor: const Color(0xffa4392f),
        title: Text(
          'Items Screen',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa4392f)),
          strokeWidth: 5.0,
        ),
        inAsyncCall: isLoading,
        child: RefreshIndicator(
          onRefresh: fetchDataFromFirestore,
          color: Color(0xffa4392f),
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
                        hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w200),
                        labelStyle: GoogleFonts.poppins(color: Colors.grey),
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffa4392f), width: 2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: toggleDateColumnVisibility,
                          icon: Icon(
                            showDateColumn ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Item Count: ${filteredList.length}',
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                color: Color(0xffa4392f), // Set background color
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Kodu",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Name",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Eni",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Gramaj",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Price",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold, // Make text bold
                          ),
                        ),
                      ),
                      if (showDateColumn) // Show Date column only if showDateColumn is true
                        Expanded(
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
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
