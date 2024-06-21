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
  late TextEditingController _koduController;
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _priceController;
  late bool _yardage;
  late bool _hanger;

  @override
  void initState() {
    super.initState();
    _koduController = TextEditingController(text: widget.kodu);
    _nameController = TextEditingController(text: widget.name);
    _dateController = TextEditingController(text: widget.date);
    _priceController = TextEditingController(text: widget.price);
    _yardage = widget.yardage;
    _hanger = widget.hanger;
  }

  @override
  void dispose() {
    _koduController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    super.dispose();
  }

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
                    onChanged: (value) {
                      widget.onChangedKodu(value);
                      setState(() {
                        _koduController.text = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Kodu',
                      labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffa4392f)),
                      ),
                    ),
                    cursorColor: Color(0xffa4392f),
                    controller: _koduController,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      widget.onChangedName(value);
                      setState(() {
                        _nameController.text = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffa4392f)),
                      ),
                    ),
                    cursorColor: Color(0xffa4392f),
                    controller: _nameController,
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
                        onChanged: (value) {
                          widget.onChangedDate(value);
                          setState(() {
                            _dateController.text = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffa4392f)),
                          ),
                        ),
                        cursorColor: Color(0xffa4392f),
                        controller: _dateController,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      widget.onChangedPrice(value);
                      setState(() {
                        _priceController.text = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffa4392f)),
                      ),
                    ),
                    cursorColor: Color(0xffa4392f),
                    controller: _priceController,
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
                        value: _yardage,
                        onChanged: (value) {
                          widget.onChangedYardage(value ?? false);
                          setState(() {
                            _yardage = value ?? false;
                          });
                        },
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
                        value: _hanger,
                        onChanged: (value) {
                          widget.onChangedHanger(value ?? false);
                          setState(() {
                            _hanger = value ?? false;
                          });
                        },
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
      String formattedDate = picked.toString().split(' ')[0];
      widget.onChangedDate(formattedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }
}
