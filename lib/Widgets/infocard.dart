import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class infoCard extends StatelessWidget {
  final VoidCallback onpress;
  final String name;
  final IconData icon;
  final String company;
  late var Prof_icon;
  final String initial;
  final String customerId; // Add customerId to uniquely identify customers

  infoCard({
    this.icon = Icons.person,
    required this.name,
    required this.company,
    required this.onpress,
    required this.initial,
    required this.customerId,
  });

  Future<void> deleteCustomer(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('customers').doc(customerId).delete();
    } catch (e) {
      print('Error deleting customer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting customer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.name == "") {
      Prof_icon = Icon(Icons.person);
    } else {
      Prof_icon = Text(
        '$initial',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return Dismissible(
      key: UniqueKey(), // Unique key for each card
      direction: DismissDirection.endToStart, // Swipe direction
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Confirm Delete',
                style: GoogleFonts.poppins(
                  color: Color(0xffa4392f), // Specify the color
                ),
              ),
              content: Text(
                'Do you want to delete this customer?',
                style: GoogleFonts.poppins(), // Use default Poppins style
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel deletion
                  },
                  child: Text(
                    'No',
                    style: GoogleFonts.poppins(
                      color: Color(0xffa4392f), // Specify the color
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirm deletion
                  },
                  child: Text(
                    'Yes',
                    style: GoogleFonts.poppins(
                      color: Color(0xffa4392f), // Specify the color
                    ),
                  ),
                ),
              ],
            );

          },
        );
      },
      onDismissed: (direction) async {
        // Perform deletion here if confirmed
        await deleteCustomer(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name deleted')),
        );
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onpress,
        child: Material(
          elevation: 6, // Add elevation to the whole container
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 5),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Prof_icon,
                      backgroundColor: Color(0xffa4392f),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${this.name}',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${this.company}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
