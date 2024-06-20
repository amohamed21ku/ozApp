import 'package:flutter/material.dart';

class Spreadsheet extends StatefulWidget {
  @override
  _SpreadsheetState createState() => _SpreadsheetState();
}

class _SpreadsheetState extends State<Spreadsheet> {
  final List<Map<String, dynamic>> _data = [
    {'description': 'RABIA PD', 'quantity': 18698.50, 'unitPrice': 2.10},
    {'description': 'TOKYO PD', 'quantity': 17244.50, 'unitPrice': 2.10},
    {'description': 'TOKYO FB', 'quantity': 7075.00, 'unitPrice': 2.25},
  ];

  final List<TextEditingController> _quantityControllers = [];
  final List<TextEditingController> _unitPriceControllers = [];

  @override
  void initState() {
    super.initState();
    _data.forEach((row) {
      _quantityControllers.add(TextEditingController(text: row['quantity'].toString()));
      _unitPriceControllers.add(TextEditingController(text: row['unitPrice'].toString()));
    });
  }

  @override
  void dispose() {
    _quantityControllers.forEach((controller) => controller.dispose());
    _unitPriceControllers.forEach((controller) => controller.dispose());
    super.dispose();
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
                  ],
                  rows: List.generate(_data.length, (index) {
                    return DataRow(cells: [
                      DataCell(Text(_data[index]['description'], style: TextStyle(fontSize: 12))),
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
              ],
            ),
          ),
        ),
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
