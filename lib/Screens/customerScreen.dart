import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/infocard.dart';
import 'CustomerItemsScreen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = []; // List to store customer data

  @override
  void initState() {
    super.initState();
    fetchCustomers(); // Fetch customers data when screen initializes
  }

  // Function to fetch customer data
  void fetchCustomers() {
    FirebaseFirestore.instance.collection('customers').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final name = doc['name'] as String;
        final company = doc['company'] as String;
        final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '';
        final Map<String, dynamic> items = doc['items'] as Map<String, dynamic>;
        customers.add(Customer(name: name, company: company, initial: initial, items: items));
        print(doc['items']);
      });
      setState(() {}); // Update the UI after fetching customers
    }).catchError((error) {
      print('Error fetching customers: $error');
    });
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
        onPressed: () {
          // Add functionality to add new customers here
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
      body: Column(
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
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
                    initial: customer.initial,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Customer {
  final String name;
  final String company;
  final String initial;
  final Map<String, dynamic> items; // Specify the data type for keys and values in the map

  Customer({
    required this.name,
    required this.company,
    required this.initial,
    required this.items,
  });
}
