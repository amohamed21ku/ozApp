import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/Customers.dart';

class Spreadsheet extends StatefulWidget {
  final Customer customer;

  const Spreadsheet({super.key, required this.customer});

  @override
  _SpreadsheetState createState() => _SpreadsheetState();
}

class _SpreadsheetState extends State<Spreadsheet> {
  bool isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> _data = [];
  final List<Map<String, dynamic>> _otherExpenses = [];
  final List<TextEditingController> _descriptionControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  final List<TextEditingController> _unitPriceControllers = [];
  final List<TextEditingController> _otherDescControllers = [];
  final List<TextEditingController> _otherAmountControllers = [];

  double otherExpenseTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData(widget.customer);
  }

  Future<void> _fetchData(Customer customer) async {
    setState(() => isLoading = true);

    DocumentSnapshot customerDoc =
    await _firestore.collection('customers').doc(customer.cid).get();
    if (customerDoc.exists) {
      Map<String, dynamic> goods = customerDoc['goods'];
      goods.forEach((key, value) {
        if (key.contains('good')) {
          _data.add({
            'description': value['goods_descriptions'],
            'quantity': value['quantity'],
            'unitPrice': value['unit_price'],
          });
        } else if (key.contains('other_expense')) {
          _otherExpenses.add({
            'description': value['description'],
            'amount': value['amount'],
          });
        }
      });

      for (var row in _data) {
        _descriptionControllers
            .add(TextEditingController(text: row['description']));
        _quantityControllers
            .add(TextEditingController(text: row['quantity'].toString()));
        _unitPriceControllers
            .add(TextEditingController(text: row['unitPrice'].toString()));
      }

      for (var expense in _otherExpenses) {
        _otherDescControllers
            .add(TextEditingController(text: expense['description']));
        _otherAmountControllers
            .add(TextEditingController(text: expense['amount'].toString()));
      }
    }
    setState(() => isLoading = false);
  }


  @override
  void dispose() {
    for (var controller in _descriptionControllers) {
      controller.dispose();
    }
    for (var controller in _quantityControllers) {
      controller.dispose();
    }
    for (var controller in _unitPriceControllers) {
      controller.dispose();
    }
    for (var controller in _otherDescControllers) {
      controller.dispose();
    }
    for (var controller in _otherAmountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveData() async {
    Map<String, Map<String, dynamic>> updatedGoods = {};
    for (int i = 0; i < _data.length; i++) {
      updatedGoods['good_$i'] = {
        'goods_descriptions': _data[i]['description'],
        'quantity': _data[i]['quantity'],
        'unit_price': _data[i]['unitPrice'],
        'amount': _data[i]['quantity'] * _data[i]['unitPrice'],
      };
    }

    // Include other expenses in the updatedGoods map
    for (int i = 0; i < _otherExpenses.length; i++) {
      updatedGoods['other_expense_$i'] = {
        'description': _otherExpenses[i]['description'],
        'amount': _otherExpenses[i]['amount'],
      };
    }

    await _firestore.collection('customers').doc(widget.customer.cid).update({
      'goods': updatedGoods,
    });
  }


  void _addNewRow() {
    setState(() {
      _data.add({'description': '', 'quantity': 0.0, 'unitPrice': 0.0});
      _descriptionControllers.add(TextEditingController());
      _quantityControllers.add(TextEditingController());
      _unitPriceControllers.add(TextEditingController());
    });
  }

  void _deleteRow(int index) {
    setState(() {
      _data.removeAt(index);
      _descriptionControllers[index].dispose();
      _quantityControllers[index].dispose();
      _unitPriceControllers[index].dispose();
      _descriptionControllers.removeAt(index);
      _quantityControllers.removeAt(index);
      _unitPriceControllers.removeAt(index);
    });
  }

  void _addOtherExpenseRow() {
    setState(() {
      _otherExpenses.add({'description': '', 'amount': 0.0});
      _otherDescControllers.add(TextEditingController());
      _otherAmountControllers.add(TextEditingController());
    });
  }

  void _deleteOtherExpenseRow(int index) {
    setState(() {
      _otherExpenses.removeAt(index);
      _otherDescControllers[index].dispose();
      _otherAmountControllers[index].dispose();
      _otherDescControllers.removeAt(index);
      _otherAmountControllers.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    double totalGoodsAmount = _calculateTotalGoodsAmount();
    double totalOtherExpenses = _calculateTotalOtherExpenses();
    double totalAmount = totalGoodsAmount + totalOtherExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spreadsheet'),
      ),
      body: ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa4392f)),
          strokeWidth: 5.0,
        ),
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Text(
                        widget.customer.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DataTable(
                        columnSpacing: 10,
                        headingRowHeight: 30,
                        columns: [
                          DataColumn(label: Text('Goods', style: GoogleFonts.poppins(fontSize: 14))),
                          DataColumn(label: Text('Quantity', style: GoogleFonts.poppins(fontSize: 14))),
                          DataColumn(label: Text('Price', style: GoogleFonts.poppins(fontSize: 14))),
                          DataColumn(label: Text('Amount', style: GoogleFonts.poppins(fontSize: 14))),
                          DataColumn(label: Text('', style: GoogleFonts.poppins(fontSize: 14))),
                        ],
                        rows: List.generate(_data.length, (index) {
                          return DataRow(cells: [
                            DataCell(
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _descriptionControllers[index],
                                  style: GoogleFonts.poppins(fontSize: 12),
                                  cursorColor: const Color(0xffa4392f),
                                  // Set the cursor color here
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffa4392f), width: 1.5),
                                    ),
                                  ),

                                  onChanged: (value) {
                                    setState(() {
                                      _data[index]['description'] = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: _quantityControllers[index],
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.poppins(fontSize: 12),
                                  cursorColor: const Color(0xffa4392f), // Set the cursor color here
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffa4392f), width: 1.5),
                                    ),
                                  ),


                                  onChanged: (value) {
                                    setState(() {
                                      _data[index]['quantity'] = double.tryParse(value) ?? 0;
                                    });
                                  },
                                ),

                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 60,
                                child:TextField(
                                  controller: _unitPriceControllers[index],
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.poppins(fontSize: 12),
                                  cursorColor: const Color(0xffa4392f), // Set the cursor color here
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffa4392f), width: 1.5),
                                    ),
                                    prefixText: '\$', // Add the dollar sign as a prefix
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _data[index]['unitPrice'] = double.tryParse(value) ?? 0;
                                    });
                                  },
                                ),

                              ),
                            ),
                            DataCell(Text('\$'+(_data[index]['quantity'] * _data[index]['unitPrice']).toStringAsFixed(2), style: GoogleFonts.poppins(fontSize: 14))),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteRow(index),
                              ),
                            ),
                          ]);
                        }),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black45,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: _addOtherExpenseRow,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Text(
                                'Add Other Expense',
                                style: GoogleFonts.poppins(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_otherExpenses.isNotEmpty)
                          DataTable(
                            columnSpacing: 10,
                            headingRowHeight: 30,
                            columns: [
                              DataColumn(label: Text('Description', style: GoogleFonts.poppins(fontSize: 14))),
                              DataColumn(label: Text('Amount', style: GoogleFonts.poppins(fontSize: 14))),
                              DataColumn(label: Text('', style: GoogleFonts.poppins(fontSize: 14))),
                            ],
                            rows: List.generate(_otherExpenses.length, (index) {
                              return DataRow(cells: [
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _otherDescControllers[index],
                                      style: GoogleFonts.poppins(fontSize: 12),
                                      cursorColor: const Color(0xffa4392f), // Set the cursor color here

                                      decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffa4392f),width: 1.5),),


                                      ),

                                      onChanged: (value) {
                                        setState(() {
                                          _otherExpenses[index]['description'] = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller: _otherAmountControllers[index],
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.poppins(fontSize: 12),
                                      cursorColor: const Color(0xffa4392f), // Set the cursor color here


                                      decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffa4392f),width: 1.5),),

                                        prefixText: '\$',
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _otherExpenses[index]['amount'] = double.tryParse(value) ?? 0.0;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteOtherExpenseRow(index),
                                  ),
                                ),
                              ]);
                            }),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'TOTAL: \$${totalAmount.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _saveData,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffa4392f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffa4392f),
        onPressed: _addNewRow,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  double _calculateTotalGoodsAmount() {
    double total = 0;
    for (var row in _data) {
      total += row['quantity'] * row['unitPrice'];
    }
    return total;
  }

  double _calculateTotalOtherExpenses() {
    double total = 0;
    for (var expense in _otherExpenses) {
      total += expense['amount'];
    }
    return total;
  }}
