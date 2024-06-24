import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({Key? key}) : super(key: key);

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
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

  Future<void> _selectDate(BuildContext context, int index) async {
    DateTime initialDate = DateTime.tryParse(
        filteredList[index]['current tarih']) ?? DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xffa4392f)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
                        hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w200),
                        labelStyle: GoogleFonts.poppins(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xffa4392f),
                              width: 2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: toggleDateColumnVisibility,
                          icon: Icon(
                            showDateColumn ? Icons.visibility : Icons
                                .visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Item Count: ${filteredList.length}',
                          style: GoogleFonts.poppins(color: Colors.black,
                              fontSize: 14),
                        ),
                        IconButton( // This is the icon button
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditItemScreen()),
                            );
                          },
                          icon: const Icon(Icons.add),
                          tooltip: 'Add Item',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                color: const Color(0xffa4392f), // Set background color
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                  text: filteredList[index]['kodu'].toString(),
                                ),
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                  text: filteredList[index]['name'].toString(),
                                ),
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                  text: filteredList[index]['eni'].toString(),
                                ),
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                  text: filteredList[index]['gramaj']
                                      .toString(),
                                ),
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                  text: filteredList[index]['current price']
                                      .toString(),
                                ),
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ),
                            if (showDateColumn) // Show Date value only if showDateColumn is true
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context, index),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: TextEditingController(
                                        text: filteredList[index]['current tarih']
                                            .toString(),
                                      ),
                                      style: GoogleFonts.poppins(fontSize: 12),
                                    ),
                                  ),
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