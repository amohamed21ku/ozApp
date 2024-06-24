import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Widgets/mycard.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({Key? key}) : super(key: key);

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<Map<String, dynamic>> itemsToDelete = [];
  TextEditingController searchController = TextEditingController();
  bool showDateColumn = false; // Track visibility of Date column

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    DateTime initialDate =
        DateTime.tryParse(filteredList[index]['current tarih']) ??
            DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xffa4392f)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        filteredList[index]['current tarih'] = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> saveChangesToFirebase() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      for (int i = 0; i < filteredList.length; i++) {
        if (filteredList[i].containsKey('isNew') && filteredList[i]['isNew']) {
          // Add new item to Firebase
          DocumentReference newDoc =
          FirebaseFirestore.instance.collection('items').doc();
          batch.set(newDoc, {
            'kodu': filteredList[i]['kodu'],
            'name': filteredList[i]['name'],
            'eni': filteredList[i]['eni'],
            'gramaj': filteredList[i]['gramaj'],
            'current price': filteredList[i]['current price'],
            'current tarih': filteredList[i]['current tarih'],
          });
        } else {
          // Update existing item in Firebase
          DocumentReference docRef = FirebaseFirestore.instance
              .collection('items')
              .doc(filteredList[i]['documentId']);
          batch.update(docRef, {
            'kodu': filteredList[i]['kodu'],
            'name': filteredList[i]['name'],
            'eni': filteredList[i]['eni'],
            'gramaj': filteredList[i]['gramaj'],
            'current price': filteredList[i]['current price'],
            'current tarih': filteredList[i]['current tarih'],
          });
        }
      }

      for (var item in itemsToDelete) {
        DocumentReference docRef =
        FirebaseFirestore.instance.collection('items').doc(item['documentId']);
        batch.delete(docRef);
      }

      itemsToDelete.clear();

      await batch.commit();
      await fetchDataFromFirestore();
    } catch (e) {
      print('Error saving changes: $e');
    } finally {
      // setState(() => isLoading = false);
    }
  }

  Future<void> fetchDataFromFirestore() async {
    setState(() => isLoading = true);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('items').get();

    dataList = querySnapshot.docs.map((doc) {
      var data = doc.data();
      data['documentId'] = doc.id; // Store document ID
      return data;
    }).toList();

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

  void toggleDateColumnVisibility() {
    setState(() {
      showDateColumn = !showDateColumn;
    });
  }

  void addNewItem() {
    setState(() {
      filteredList.insert(0, {
        'kodu': '',
        'name': '',
        'eni': '',
        'gramaj': '',
        'current price': '',
        'current tarih': '',
        'isNew': true, // Flag to identify new items
      });
    });
  }

  Future<bool?> confirmDeleteItem(int index) async {
    return await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Item"),
          content: Text(
              "Are you sure you want to delete the item with code ${filteredList[index]['kodu']}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteItem(int index) async {
    // If it's an existing item, delete directly from Firebase
    if (!filteredList[index].containsKey('isNew')) {
      try {
        await FirebaseFirestore.instance
            .collection('items')
            .doc(filteredList[index]['documentId'])
            .delete();
      } catch (e) {
        print('Error deleting item: $e');
        // Handle error if deletion fails
      }
    }
    setState(() {
      filteredList.removeAt(index);
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
            saveChangesToFirebase();
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xffa4392f),
        title: Text(
          'Items Screen',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
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
                          borderSide: const BorderSide(color: Color(0xffa4392f), width: 2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // ElevatedButton.icon(
                        //   onPressed: saveChangesToFirebase,
                        //   icon: const Icon(Icons.save, color: Colors.white),
                        //   label: const Text(
                        //     'Save',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: const Color(0xffa4392f),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //   ),
                        // ),

                        Text(
                          'Item Count: ${filteredList.length}',
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: toggleDateColumnVisibility,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: toggleDateColumnVisibility,
                                icon: Icon(
                                  size: 20,
                                  showDateColumn ? Icons.visibility_off : Icons.visibility,
                                  color: Color(0xffa4392f),
                                ),
                              ),
                              Text(
                                showDateColumn ? 'Hide Date' : 'Show Date',
                                style: GoogleFonts.poppins(
                                  color: Color(0xffa4392f),
                                  fontSize: 14, // Adjust font size as needed
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
                    children: [
                      const Expanded(
                        child: Text(
                          "Kodu",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Eni",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Gramaj",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Price",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (showDateColumn)
                        const Expanded(
                          child: Text(
                            "Date",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
                    return EditCard(
                      index: index,
                      item: filteredList[index],
                      showDateColumn: showDateColumn,

                      onDelete: (int index) {
                        deleteItem(index);
                      },
                      selectDate: _selectDate,
                      confirmDeleteItem: confirmDeleteItem,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
            onPressed: addNewItem,
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Color(0xffa4392f),
          ),
      //     // SizedBox(height: 10),
      //     // FloatingActionButton(
      //     //   onPressed: saveChangesToFirebase,
      //     //   child: Icon(Icons.save),
      //     //   backgroundColor: Color(0xffa4392f),
      //     // ),
      //   ],
      // ),
    );
  }
}
