import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
        print(doc['items']);
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
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa4392f)), // Change spinner color to theme color
          strokeWidth: 5.0, // Adjust spinner thickness if needed
        ),
        inAsyncCall: showSpinner,
        child: RefreshIndicator(
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
                        initial: customer.initial,
                      );
                    },
                  ),
                ),
              ],
            ),
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
