import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

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

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _koduController = TextEditingController(text: widget.kodu);
    _nameController = TextEditingController(text: widget.name);
    _dateController = TextEditingController(text: widget.date);
    _priceController = TextEditingController(text: widget.price);
    _yardage = widget.yardage;
    _hanger = widget.hanger;

    _koduController.addListener(() {
      _onTextChanged(_koduController.text, widget.onChangedKodu);
    });

    _nameController.addListener(() {
      _onTextChanged(_nameController.text, widget.onChangedName);
    });

    _dateController.addListener(() {
      _onTextChanged(_dateController.text, widget.onChangedDate);
    });

    _priceController.addListener(() {
      _onTextChanged(_priceController.text, widget.onChangedPrice);
    });
  }

  void _onTextChanged(String text, ValueChanged<String> onChanged) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      onChanged(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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



class MyCard2 extends StatefulWidget {
  final ValueChanged<String> onChangedKodu;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedEni;
  final ValueChanged<String> onChangedGramaj;
  final ValueChanged<String> onChangedPrice;
  final ValueChanged<String> onChangedDate;
  final VoidCallback onPressedDelete;
  final String kodu;
  final String name;
  final String eni;
  final String gramaj;
  final String price;
  final String date;

  MyCard2({
    required this.onChangedKodu,
    required this.onChangedName,
    required this.onChangedEni,
    required this.onChangedGramaj,
    required this.onChangedPrice,
    required this.onChangedDate,
    required this.onPressedDelete,
    required this.kodu,
    required this.name,
    required this.eni,
    required this.gramaj,
    required this.price,
    required this.date,
  });

  @override
  _MyCard2State createState() => _MyCard2State();
}

class _MyCard2State extends State<MyCard2> {
  late TextEditingController _koduController;
  late TextEditingController _nameController;
  late TextEditingController _eniController;
  late TextEditingController _gramajController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _koduController = TextEditingController(text: widget.kodu);
    _nameController = TextEditingController(text: widget.name);
    _eniController = TextEditingController(text: widget.eni);
    _gramajController = TextEditingController(text: widget.gramaj);
    _priceController = TextEditingController(text: widget.price);
    _dateController = TextEditingController(text: widget.date);

    _koduController.addListener(() {
      _onTextChanged(_koduController.text, widget.onChangedKodu);
    });

    _nameController.addListener(() {
      _onTextChanged(_nameController.text, widget.onChangedName);
    });

    _eniController.addListener(() {
      _onTextChanged(_eniController.text, widget.onChangedEni);
    });

    _gramajController.addListener(() {
      _onTextChanged(_gramajController.text, widget.onChangedGramaj);
    });

    _priceController.addListener(() {
      _onTextChanged(_priceController.text, widget.onChangedPrice);
    });

    _dateController.addListener(() {
      _onTextChanged(_dateController.text, widget.onChangedDate);
    });
  }

  void _onTextChanged(String text, ValueChanged<String> onChanged) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      onChanged(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _koduController.dispose();
    _nameController.dispose();
    _eniController.dispose();
    _gramajController.dispose();
    _priceController.dispose();
    _dateController.dispose();
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
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffa4392f)),
                    ),
                  ),
                  cursorColor: Color(0xffa4392f),
                  controller: _koduController,
                ),
              ),
    Expanded(
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffa4392f)),
              ),
            ),
            cursorColor: Color(0xffa4392f),
            controller: _nameController,
          ),
        ),
    Expanded(
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffa4392f)),
              ),
            ),
            cursorColor: Color(0xffa4392f),
            controller: _eniController,
          ),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffa4392f)),
              ),
            ),
            cursorColor: Color(0xffa4392f),
            controller: _gramajController,
          ),
        ),

                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffa4392f)),
                          ),
                        ),
                        cursorColor: Color(0xffa4392f),
                        controller: _priceController,
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
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

              ],
            )
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           labelText: 'Kodu',
            //           labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
            //           isDense: true,
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Color(0xffa4392f)),
            //           ),
            //         ),
            //         cursorColor: Color(0xffa4392f),
            //         controller: _koduController,
            //       ),
            //     ),
            //     SizedBox(width: 8),
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           labelText: 'Name',
            //           labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
            //           isDense: true,
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Color(0xffa4392f)),
            //           ),
            //         ),
            //         cursorColor: Color(0xffa4392f),
            //         controller: _nameController,
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           labelText: 'Eni',
            //           labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
            //           isDense: true,
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Color(0xffa4392f)),
            //           ),
            //         ),
            //         cursorColor: Color(0xffa4392f),
            //         controller: _eniController,
            //       ),
            //     ),
            //     SizedBox(width: 8),
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           labelText: 'Gramaj',
            //           labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
            //           isDense: true,
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Color(0xffa4392f)),
            //           ),
            //         ),
            //         cursorColor: Color(0xffa4392f),
            //         controller: _gramajController,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 4),
            // Row(
            //   children: [
            //     Expanded(
            //       child: GestureDetector(
            //         onTap: () => _selectDate(context),
            //         child: AbsorbPointer(
            //           child: TextField(
            //             decoration: InputDecoration(
            //               labelText: 'Date',
            //               labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
            //               isDense: true,
            //               focusedBorder: UnderlineInputBorder(
            //                 borderSide: BorderSide(color: Color(0xffa4392f)),
            //               ),
            //             ),
            //             cursorColor: Color(0xffa4392f),
            //             controller: _dateController,
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 8),
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           labelText: 'Price',
            //           labelStyle: GoogleFonts.poppins(fontSize: 14, color: Color(0xffa4392f)),
            //           isDense: true,
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Color(0xffa4392f)),
            //           ),
            //         ),
            //         cursorColor: Color(0xffa4392f),
            //         controller: _priceController,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 4),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(
            //       icon: Icon(Icons.delete),
            //       onPressed: widget.onPressedDelete,
            //     ),
            //   ],
            // ),
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




class EditCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> item;
  final bool showDateColumn;
  final Function(int) onDelete;
  final Future<void> Function(BuildContext, int) selectDate;
  final Future<bool?> Function(int) confirmDeleteItem;

  const EditCard({
    required this.index,
    required this.item,
    required this.showDateColumn,
    required this.onDelete,
    required this.selectDate,
    required this.confirmDeleteItem,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await confirmDeleteItem(index);
      },
      onDismissed: (direction) {
        onDelete(index);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: item['kodu'].toString(),
                  ),
                  onChanged: (value) {
                    item['kodu'] = value;
                  },
                  style: GoogleFonts.poppins(fontSize: 12),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  maxLines: null,
                  controller: TextEditingController(
                    text: item['name'].toString(),
                  ),
                  onChanged: (value) {
                    item['name'] = value;
                  },
                  style: GoogleFonts.poppins(fontSize: 12),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: item['eni'].toString(),
                  ),
                  onChanged: (value) {
                    item['eni'] = value;
                  },
                  style: GoogleFonts.poppins(fontSize: 12),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: item['gramaj'].toString(),
                  ),
                  onChanged: (value) {
                    item['gramaj'] = value;
                  },
                  style: GoogleFonts.poppins(fontSize: 12),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: item['current price'].toString(),
                  ),
                  onChanged: (value) {
                    item['current price'] = value;
                  },
                  style: GoogleFonts.poppins(fontSize: 12),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (showDateColumn)
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectDate(context, index),
                    child: AbsorbPointer(
                      child: TextField(
                        maxLines: null,
                        controller: TextEditingController(
                          text: item['current tarih'].toString(),
                        ),
                        onChanged: (value) {
                          item['current tarih'] = value;
                        },
                        style: GoogleFonts.poppins(fontSize: 12),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
