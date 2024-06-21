import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/mycard.dart'; // Assuming mycard.dart is in a separate folder named Widgets
import 'customerScreen.dart';

class CustomerItemsScreen extends StatefulWidget {
  final Customer customer;

  CustomerItemsScreen({required this.customer});

  @override
  _CustomerItemsScreenState createState() => _CustomerItemsScreenState();
}

class _CustomerItemsScreenState extends State<CustomerItemsScreen> {
  List<MyCard> items = [];

  void addItem() {
    setState(() {
      items.add(MyCard(
        kodu: '',
        name: '',
        date: '',
        price: '',
        yardage: false,
        hanger: false,
        onChangedKodu: (value) {},
        onChangedName: (value) {},
        onChangedDate: (value) {},
        onChangedPrice: (value) {},
        onChangedYardage: (value) {},
        onChangedHanger: (value) {},
        onPressedDelete: () => removeItem(items.length - 1), // Pass the index to removeItem
      ));
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Items',
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Color(0xffa4392f),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Customer: ${widget.customer.name}',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return items[index];
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffa4392f),
        onPressed: addItem,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
