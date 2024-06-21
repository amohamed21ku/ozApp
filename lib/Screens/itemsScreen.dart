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
  bool isLoading = false;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchDataFromFirestore() async {
    setState(() => isLoading = true);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('new_items').get();
    dataList = querySnapshot.docs.map((doc) => doc.data()).toList();
    filteredList = dataList;
    dataList.sort((a, b) => a['kodu'].compareTo(b['kodu']));
    setState(() => isLoading = false);
  }

  void filterData(String query) {
    setState(() {
      filteredList = dataList
          .where((item) =>
      item['kodu'].toLowerCase().contains(query.toLowerCase()) ||
          item['sItemName'].toLowerCase().contains(query.toLowerCase()))
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
                    ),
                    SizedBox(height: 10),
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
                  controller: _scrollController,
                  child: PaginatedDataTable(
                    header: Text(
                      'Items',
                      style: GoogleFonts.poppins(color: Color(0xffa4392f)),
                    ),
                    rowsPerPage: 200,
                    columnSpacing: 22,
                    headingRowHeight: 40,
                    dataRowHeight: 60,
                    arrowHeadColor: Color(0xffa4392f),
                    headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xffa4392f)),
                    columns: [
                      DataColumn(label: Text('Kodu', style: GoogleFonts.poppins(color: Colors.white))),
                      DataColumn(label: Text('Name', style: GoogleFonts.poppins(color: Colors.white))),
                      DataColumn(label: Text('Eni', style: GoogleFonts.poppins(color: Colors.white))),
                      DataColumn(label: Text('Gramaj', style: GoogleFonts.poppins(color: Colors.white))),
                      DataColumn(label: Text('USD', style: GoogleFonts.poppins(color: Colors.white))),
                      DataColumn(label: Text('Tarih', style: GoogleFonts.poppins(color: Colors.white))),
                    ],
                    source: RowSource(
                      myData: filteredList,
                      count: filteredList.length,
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

class RowSource extends DataTableSource {
  final List<Map<String, dynamic>> myData;
  final int count;

  RowSource({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= myData.length) return null;
    final item = myData[index];
    return DataRow(
      cells: [
        DataCell(Text(item['kodu'].toString())),
        DataCell(Text(item['sItemName'].toString())),
        DataCell(Text(item['eni'].toString())),
        DataCell(Text(item['gramaj'].toString())),
        DataCell(Text(item['price'].toString())),
        // DataCell(Text(item['Tarih'].toString())),
      ],
    );
  }

  @override
  int get rowCount => count;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
