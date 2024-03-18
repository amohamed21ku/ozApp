import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Map<String, String>> dataList = [
    {
      'Kodu': '101 001',
      'Eni': '170 CM',
      'Gramaj': '160 GSM',
      'Supplier': 'Supplier A',
      'S/Item Name': 'Item 1',
      'USD': '\$2.12',
      'Tarih': '17-Jan-23',
    },
    {
      'Kodu': '101 002',
      'Eni': '172 CM',
      'Gramaj': '176 GSM',
      'S/Item Name': 'Item 2',
      'USD': "\$3.7",
      'Tarih': '21-Jun-23',
    },
    // Add more data as needed
  ];

  List<Map<String, String>> filteredList = [];

  TextEditingController searchController = TextEditingController();

  String? selectedPrice;

  @override
  void initState() {
    super.initState();
    filteredList = dataList;
  }

  void filterData(String query) {
    setState(() {
      filteredList = dataList
          .where((item) =>
      item['Gramaj']!.toLowerCase().contains(query.toLowerCase()) ||
          item['S/Item Name']!.toLowerCase().contains(query.toLowerCase()))
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterData(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 15,
                headingRowHeight: 50,
                dataRowHeight: 60,
                headingTextStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                columns: const [
                  DataColumn(label: Text('Kodu')),
                  DataColumn(label: Text('Eni')),
                  DataColumn(label: Text('Gramaj')),
                  DataColumn(label: Text('S/Item Name')),
                  DataColumn(label: Text('USD')),
                  DataColumn(label: Text('Tarih')), // Add Tarih column
                ],
                rows: filteredList.map((data) {
                  int index = dataList.indexOf(data);
                  return DataRow(cells: [
                    DataCell(Text(data['Kodu']!)),
                    DataCell(Text(data['Eni']!)),
                    DataCell(Text(data['Gramaj']!)),
                    DataCell(Text(data['S/Item Name']!)),
                    DataCell(
                      GestureDetector(
                        onDoubleTapDown: (details) {
                          // Show popup menu on double tap
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              details.globalPosition.dx,
                              details.globalPosition.dy,
                              details.globalPosition.dx,
                              details.globalPosition.dy,
                            ),
                            items: [
                              const PopupMenuItem(
                                enabled: false,
                                child: Text('Previous Prices'),
                              ),
                              ...dataList
                                  .where((item) => item['USD'] != null)
                                  .map((item) => PopupMenuItem(
                                child: Text(
                                  '${item['Tarih']}: ${item['USD']}',
                                ),
                              ))
                                  .toList(),
                            ],
                          );
                        },
                        child: Text(data['USD']!),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField<String>(
                          items: (data['Tarih']!.isEmpty
                          ? ['Select Date'] + ['17-Jan-23', 'other_date']
                                  : <String>[data['Tarih']!] + ['17-Jan-23', 'other_date'])
                              .toSet()
                              .toList()
                              .map<DropdownMenuItem<String>>(
                                (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              data['Tarih'] = newValue!;
                              // Update the price here based on the selected date
                            });
                          },
                          value: data['Tarih']!.isEmpty ? null : data['Tarih'],
                          decoration: InputDecoration(
                            border: InputBorder.none, // Remove default border
                            enabledBorder: UnderlineInputBorder( // Add underline border
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder( // Add focused border
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            isDense: true, // Reduce padding
                            contentPadding: EdgeInsets.zero, // Remove default content padding
                          ),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                          icon: Icon(Icons.arrow_drop_down), // Add dropdown icon
                        ),
                      ),
                    ),

                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
