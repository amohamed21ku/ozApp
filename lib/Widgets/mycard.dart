import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatefulWidget {
  final ValueChanged<String> onChangedKodu;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedDate;
  final ValueChanged<String> onChangedPrice;
  final ValueChanged<bool> onChangedYardage;
  final ValueChanged<bool> onChangedHanger;
  final VoidCallback onPressedDelete;
  final String kodu;
  final String name;
  final String date;
  final String price;
  final bool yardage;
  final bool hanger;

  MyCard({
    required this.onChangedKodu,
    required this.onChangedName,
    required this.onChangedDate,
    required this.onChangedPrice,
    required this.onChangedYardage,
    required this.onChangedHanger,
    required this.onPressedDelete,
    required this.kodu,
    required this.name,
    required this.date,
    required this.price,
    required this.yardage,
    required this.hanger,
  });

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: widget.onChangedKodu,
                    decoration: InputDecoration(
                      labelText: 'Kodu',
                      labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffa4392f)),
                      ),
                    ),
                    cursorColor: Color(0xffa4392f),
                    controller: TextEditingController(text: widget.kodu),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: widget.onChangedName,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffa4392f)),
                      ),
                    ),
                    cursorColor: Color(0xffa4392f),
                    controller: TextEditingController(text: widget.name),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        onChanged: widget.onChangedDate,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffa4392f)),
                          ),
                        ),
                        cursorColor: Color(0xffa4392f),
                        controller: TextEditingController(text: widget.date),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: widget.onChangedPrice,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffa4392f)),
                      ),
                    ),
                    cursorColor: Color(0xffa4392f),
                    controller: TextEditingController(text: widget.price),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: widget.yardage,
                        onChanged: (value) => widget.onChangedYardage(value ?? false),
                        activeColor: Color(0xffa4392f),
                      ),
                      Text(
                        'Yardage',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: widget.hanger,
                        onChanged: (value) => widget.onChangedHanger(value ?? false),
                        activeColor: Color(0xffa4392f),
                      ),
                      Text(
                        'Hanger',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: widget.onPressedDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        widget.onChangedDate(picked.toString().split(' ')[0]);
// Continued from the previous code snippet
      });
    }
  }
}
