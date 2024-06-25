import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final String docId; // Document ID

  const ItemDetailsScreen({super.key, required this.item, required this.docId});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController koduController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController eniController = TextEditingController();
  TextEditingController gramajController = TextEditingController();
  TextEditingController currentPriceController = TextEditingController();
  TextEditingController currentDateController = TextEditingController();
  List<Map<String, dynamic>> previousPrices = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    koduController.text = widget.item['kodu'];
    nameController.text = widget.item['name'];
    eniController.text = widget.item['eni'];
    gramajController.text = widget.item['gramaj'];
    currentPriceController.text = widget.item['current price'];
    currentDateController.text = widget.item['current tarih'];

    // Initialize previous prices
    if (widget.item.containsKey('previous_prices')) {
      previousPrices = List<Map<String, dynamic>>.from(widget.item['previous_prices']);
    }
  }

  Future<void> updateItemData() async {
    // Prepare updated data
    Map<String, dynamic> itemData = {
      'kodu': koduController.text,
      'name': nameController.text,
      'eni': eniController.text,
      'gramaj': gramajController.text,
      'current price': currentPriceController.text,
      'current tarih': currentDateController.text,
      'previous_prices': previousPrices,
    };

    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.docId) // Use the document ID received from ItemsScreen
          .update(itemData);

      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item updated successfully'),
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update item: $e'),
        ),
      );
    }
  }

  void addNewPrice() {
    setState(() {
      previousPrices.add({
        'date': DateTime.now(), // Default to current date
        'price': '', // Empty price initially
      });
    });
  }

  void removePrice(int index) {
    setState(() {
      previousPrices.removeAt(index);
    });
  }

  Future<void> showDatePickerAndSetDate(int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        previousPrices[index]['date'] = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        actions: [
          IconButton(
            onPressed: updateItemData,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: koduController,
              decoration: const InputDecoration(labelText: 'Kodu'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: eniController,
              decoration: const InputDecoration(labelText: 'Eni'),
            ),
            TextField(
              controller: gramajController,
              decoration: const InputDecoration(labelText: 'Gramaj'),
            ),
            TextField(
              controller: currentPriceController,
              decoration: const InputDecoration(labelText: 'Current Price'),
            ),
            TextField(
              controller: currentDateController,
              decoration: const InputDecoration(labelText: 'Current Date'),
            ),
            const SizedBox(height: 20),
            Text(
              'Previous Prices',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Actions')),
              ],
              rows: List.generate(
                previousPrices.length,
                    (index) => DataRow(
                  cells: [
                    DataCell(
                      GestureDetector(
                        onTap: () => showDatePickerAndSetDate(index),
                        child: Text(
                          '${previousPrices[index]['date'].day}-${getMonthName(previousPrices[index]['date'].month)}-${previousPrices[index]['date'].year}',
                        ),
                      ),
                    ),
                    DataCell(
                      TextField(
                        controller: TextEditingController(
                          text: previousPrices[index]['price'],
                        ),
                        onChanged: (value) {
                          setState(() {
                            previousPrices[index]['price'] = value;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removePrice(index),
                      ),
                    ),
                  ],
                ),
              )..addAll([
                // Add an "Add" button row
                DataRow(cells: [
                  DataCell(
                    Center(
                      child: ElevatedButton(
                        onPressed: addNewPrice,
                        child: const Text('Add Price'),
                      ),
                    ),
                  ),
                  DataCell(Container()), // Empty cell for price
                  DataCell(Container()), // Empty cell for actions
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
