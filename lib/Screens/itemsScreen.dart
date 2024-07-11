import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
  List<String> columnOrder = [
    'Kodu', 'Name', 'Eni', 'Gramaj', 'Price', 'Date', 'Supplier', 'Kalite', 'NOT', 'Item No.'
  ];
  Map<String, bool> columnVisibility = {
    'Kodu': true,
    'Name': true,
    'Eni': true,
    'Gramaj': true,
    'Price': true,
    'Date': false,
    'Supplier': false,
    'Kalite': false,
    'NOT': false,
    'Item No.': false,
  };

  @override
  void initState() {
    super.initState();
    fetchDataFromCache();
    fetchDataFromFirestore();
  }

  DateTime excelSerialDateToDateTime(int serialDate) {
    return DateTime(1899, 12, 30).add(Duration(days: serialDate));
  }

  String formatDateString(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MMM-yy');
    return formatter.format(date);
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

    // Sort dataList based on "Kodu" field
    dataList.sort((a, b) => a['Kodu'].compareTo(b['Kodu']));

    filteredList = dataList;

    // Cache the data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('itemsData', jsonEncode(dataList)); // Use jsonEncode here

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
      item['Kodu'].toLowerCase().contains(query.toLowerCase()) ||
          item['Item Name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showColumnSelector() {
    List<String> newColumnOrder = List.from(columnOrder);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Select Columns to Display',
                style: GoogleFonts.poppins(color: Color(0xffa4392f)),
              ),
              content: Container(
                width: double.maxFinite,
                height: 400, // Set a fixed height to avoid oversized drag targets
                child: IgnorePointer(
                  ignoring: false,
                  child: ReorderableListView(
                    physics: ClampingScrollPhysics(), // Use clamping physics to prevent bouncing
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final String item = newColumnOrder.removeAt(oldIndex);
                        newColumnOrder.insert(newIndex, item);
                      });
                    },
                    children: newColumnOrder.map((String key) {
                      return CheckboxListTile(
                        key: Key(key),
                        title: Text(
                          key,
                          style: GoogleFonts.poppins(color: Colors.black , fontWeight: FontWeight.w400),
                        ),
                        value: columnVisibility[key],
                        onChanged: (bool? value) {
                          setState(() {
                            columnVisibility[key] = value!;
                          });
                        },
                        activeColor: Color(0xffa4392f),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: GoogleFonts.poppins(color: Color(0xffa4392f)),
                  ),
                  onPressed: () {
                    setState(() {
                      columnOrder = newColumnOrder;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Update the state of the ItemsScreen when the dialog is dismissed
      setState(() {});
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
                        hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w200),
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
                          onTap: showColumnSelector,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: showColumnSelector,
                                icon: Icon(
                                  size: 20,
                                  Icons.view_column,
                                  color: const Color(0xffa4392f),
                                ),
                              ),
                              Text(
                                'Select Columns',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xffa4392f),
                                  fontSize: 14,
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
                color: const Color(0xffa4392f),
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: columnOrder
                        .where((column) => columnVisibility[column]!)
                        .map((column) => Expanded(
                      child: Text(
                        column,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                        .toList(),
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
                              docId: filteredList[index]['id'],
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
                            children: columnOrder
                                .where((column) => columnVisibility[column]!)
                                .map((column) {
                              final value = filteredList[index][column] ??
                                  filteredList[index]['Item $column'];
                              return Expanded(
                                child: Text(
                                  column == 'Date' && value is int
                                      ? formatDateString(
                                      excelSerialDateToDateTime(value))
                                      : value.toString(),
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              );
                            }).toList(),
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
