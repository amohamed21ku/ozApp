import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/infocard.dart';
import 'CustomerItemsScreen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [];
  bool showSpinner = false; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    setState(() {
      showSpinner = true; // Show loading HUD
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('customers').get();
      customers.clear(); // Clear existing data
      querySnapshot.docs.forEach((doc) {
        final name = doc['name'] as String;
        final company = doc['company'] as String;
        final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '';
        final Map<String, dynamic> items = doc['items'] as Map<String, dynamic>;
        final cid = doc.id;
        final goods = doc['goods'];
        customers.add(Customer(name: name, company: company, initial: initial, items: items, cid: cid, goods: goods));
      });
    } catch (error) {
      print('Error fetching customers: $error');
    }

    setState(() {
      showSpinner = false; // Hide loading HUD
    });
  }

  Future<void> _handleRefresh() async {
    await fetchCustomers();
  }
  Future<void> _addCustomer(BuildContext context) async {
    String name = '';
    String company = '';
    Map<String, dynamic> items = {}; // Initialize items map
    Map<String, dynamic> goods = {}; // Initialize goods map

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Customer',
            style: GoogleFonts.poppins(
              color: Color(0xffa4392f), // Title color
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color(0xffa4392f)), // Label color
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffa4392f)), // Underline color when focused
                  ),
                ),
                cursorColor: Color(0xffa4392f), // Cursor color
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Company',
                  labelStyle: TextStyle(color: Color(0xffa4392f)), // Label color
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffa4392f)), // Underline color when focused
                  ),
                ),
                cursorColor: Color(0xffa4392f), // Cursor color
                onChanged: (value) => company = value,
              ),
              // TextField(
              //   decoration: InputDecoration(labelText: 'Items'),
              //   onChanged: (value) => items = jsonDecode(value), // Convert string to map
              // ),
              // TextField(
              //   decoration: InputDecoration(labelText: 'Goods'),
              //   onChanged: (value) => goods = jsonDecode(value), // Convert string to map
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without adding
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Color(0xffa4392f), // Button text color
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Add customer to Firestore
                await FirebaseFirestore.instance.collection('customers').add({
                  'name': name,
                  'company': company,
                  'items': items, // Add items to Firestore
                  'goods': goods, // Add goods to Firestore
                  // Add other fields as needed
                });
                Navigator.of(context).pop(); // Close dialog after adding
                await fetchCustomers(); // Refresh customer list
              },
              child: Text(
                'Add',
                style: GoogleFonts.poppins(
                  color: Colors.white, // Button text color
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffa4392f), // Button background color
              ),
            ),
          ],
        );


      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color(0xffa4392f),
        title: Text(
          'Customers',
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffa4392f),
        onPressed: () => _addCustomer(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: showSpinner
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Color(0xffa4392f), // Change refresh indicator color to theme color
        backgroundColor: Colors.grey[200], // Change background color of refresh indicator
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Customer List',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return infoCard(
                      name: customer.name,
                      company: customer.company,
                      onpress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomerItemsScreen(customer: customer),
                        ));
                      },
                      initial: customer.initial, customerId: customer.cid,
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

class Customer {
  final String cid;
  final String name;
  final String company;
  final String initial;
  final Map<String, dynamic> items;
  final Map<String, dynamic> goods;

  Customer({
    required this.cid,
    required this.name,
    required this.company,
    required this.initial,
    required this.items,
    required this.goods,
  });
}

