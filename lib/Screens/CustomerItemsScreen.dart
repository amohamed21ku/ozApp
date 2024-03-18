import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customerScreen.dart';

class CustomerItemsScreen extends StatefulWidget {
  final Customer customer;

  CustomerItemsScreen({required this.customer});

  @override
  _CustomerItemsScreen createState() => _CustomerItemsScreen();
}

class _CustomerItemsScreen extends State<CustomerItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
