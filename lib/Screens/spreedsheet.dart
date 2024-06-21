import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'balancesheet.dart';

class Spreadsheet extends StatefulWidget {
  final Customer customer;

  Spreadsheet({required this.customer});
  @override
  _SpreadsheetState createState() => _SpreadsheetState();
}

class _SpreadsheetState extends State<Spreadsheet> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _data = [];
  List<TextEditingController> _descriptionControllers = [];
  List<TextEditingController> _quantityControllers = [];
  List<TextEditingController> _unitPriceControllers = [];
  String _customerName = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Replace 'your_customer_id' with the actual customer ID
    DocumentSnapshot customerDoc = await _firestore.collection('customers').doc('DGi0bj5A5qzc8f5Shp8z').get();
    if (customerDoc.exists) {
      _customerName = customerDoc['name'];
      Map<String, dynamic> goods = customerDoc['goods'];
      goods.forEach((key, good) {
        _data.add({
          'description': good['goods_descriptions'],
          'quantity': good['quantity'],
          'unitPrice': good['unit_price']
        });
      });

      _data.forEach((row) {
        _descriptionControllers.add(TextEditingController(text: row['description']));
        _quantityControllers.add(TextEditingController(text: row['quantity'].toString()));
        _unitPriceControllers.add(TextEditingController(text: row['unitPrice'].toString()));
      });

      setState(() {});
    }
  }

  @override
  void dispose() {
    _descriptionControllers.forEach((controller) => controller.dispose());
    _quantityControllers.forEach((controller) => controller.dispose());
    _unitPriceControllers.forEach((controller) => controller.dispose());
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
    await _firestore.collection('customers').doc('DGi0bj5A5qzc8f5Shp8z').update({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spreadsheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DataTable(
                  columnSpacing: 20,
                  headingRowHeight: 30,
                  dataRowHeight: 40,
                  columns: [
                    DataColumn(label: Text('Goods Descriptions', style: TextStyle(fontSize: 14))),
                    DataColumn(label: Text('Quantity', style: TextStyle(fontSize: 14))),
                    DataColumn(label: Text('Unit Price', style: TextStyle(fontSize: 14))),
                    DataColumn(label: Text('Amount', style: TextStyle(fontSize: 14))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontSize: 14))),
                  ],
                  rows: List.generate(_data.length, (index) {
                    return DataRow(cells: [
                      DataCell(
                        Container(
                          width: 100,
                          child: TextField(
                            controller: _descriptionControllers[index],
                            style: TextStyle(fontSize: 12),
                            onChanged: (value) {
                              setState(() {
                                _data[index]['description'] = value;
                              });
                            },
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 60,
                          child: TextField(
                            controller: _quantityControllers[index],
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 12),
                            onChanged: (value) {
                              setState(() {
                                _data[index]['quantity'] = double.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 60,
                          child: TextField(
                            controller: _unitPriceControllers[index],
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 12),
                            onChanged: (value) {
                              setState(() {
                                _data[index]['unitPrice'] = double.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ),
                      DataCell(Text((_data[index]['quantity'] * _data[index]['unitPrice']).toStringAsFixed(2), style: TextStyle(fontSize: 14))),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteRow(index),
                        ),
                      ),
                    ]);
                  }),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'TOTAL: ${_calculateTotalAmount().toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffa4392f),
        onPressed: _addNewRow,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  double _calculateTotalAmount() {
    double total = 0;
    for (var row in _data) {
      total += row['quantity'] * row['unitPrice'];
    }
    return total;
  }
}
