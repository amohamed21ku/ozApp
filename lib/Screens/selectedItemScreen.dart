import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectedItemScreen extends StatelessWidget {
  final Map<String, dynamic> selectedItem;

  const SelectedItemScreen({Key? key, required this.selectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selected Item Details',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kodu: ${selectedItem['kodu']}',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Name: ${selectedItem['sItemName']}',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Eni: ${selectedItem['eni']}',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Gramaj: ${selectedItem['gramaj']}',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'USD: ${selectedItem['pricesAndDates']}',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Tarih: ${selectedItem['Tarih']}',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
