import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'SelectedItemScreen.dart'; // Import the SelectedItemScreen

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  bool showSpinner = false; // Track loading state

  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> _handleRefresh() async {
    await fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    setState(() {
      showSpinner = true; // Show loading HUD
    });
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('new_items').get();

    dataList = querySnapshot.docs.map((doc) => doc.data()).toList();
    filteredList = dataList;
    // Sort the dataList by 'Kodu' field
    dataList.sort((a, b) => a['kodu'].compareTo(b['kodu']));
    setState(() {
      showSpinner = false; // Hide loading HUD
    });
  }

  void filterData(String query) {
    setState(() {
      filteredList = dataList
          .where((item) =>
      item['kodu'].toLowerCase().contains(query.toLowerCase()) ||
          item['sItemName']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
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
        inAsyncCall: showSpinner,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
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
                      onChanged: (value) {
                        filterData(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Search by Kodu or Name',
                        hintStyle:
                        GoogleFonts.poppins(fontWeight: FontWeight.w200),
                        labelStyle: GoogleFonts.poppins(color: Colors.grey),
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xffa4392f), width: 2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Item Count: ${filteredList.length}',
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),


              ),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      decoration: BoxDecoration( // Custom decoration to remove the box
                        border: Border.all(color: Colors.transparent), // Set border color to transparent
                      ),
                      child: DataTable(
                        columnSpacing: 22,
                        headingRowHeight: 40,
                        dataRowHeight: 60,
                        headingTextStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        headingRowColor: MaterialStateColor.resolveWith(
                                (states) => const Color(0xffa4392f)),
                        dividerThickness: 1,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Kodu',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Name',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Eni',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Gramaj',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'USD',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tarih',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                        rows: filteredList.map((data) {
                          return DataRow(
                            onSelectChanged: (selected) {
                              if (selected != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectedItemScreen(
                                      selectedItem: data,
                                    ),
                                  ),
                                );
                              }
                            },
                            cells: [
                              DataCell(
                                Text(data['kodu'].toString()),
                              ),
                              DataCell(
                                Text(data['sItemName'].toString()),
                              ),
                              DataCell(
                                Text(data['eni'].toString()),
                              ),
                              DataCell(
                                Text(data['gramaj'].toString()),
                              ),
                              DataCell(
                                Text(data['pricesAndDates[0]'].toString()),
                              ),
                              DataCell(
                                Text(data['Tarih'].toString()),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

