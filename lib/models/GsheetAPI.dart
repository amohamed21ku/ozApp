import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsheets/gsheets.dart';

class GsheetAPI {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheetoz",
  "private_key_id": "454cf1b2ccc44327ee153d6d0a6bab20469230dc",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDPy/TUkp6Vbw7w\n1C497e+MH3g2v5dsZPmt5j5trVAEg/vRHZ/OsDcMixWGgpOsEwnxAYocU235cKaE\n+ZR3NSX4pWerIjJqFPfns6bHX1d5IUa46NpRyLvDpH0++L9LnIijroRuwjZW/SJz\n7hlpo6EWV0Cb8I2Iwcy8RtZTCw3/xToz8B/rZKyhdhnoR7V4xJzIqvbRLQZ8bN0O\nOSgnpUy809LozUD4XjwEAJTlhkpM5fPB0xYo3ludYDFWV6Rge+AHYPF41B5OFANZ\n5YsHuXYUTpW6eBw/DbR3LM9IXiAeF2WPet4w8nWziZMuHJsjQuZWtYI/vLTmxS78\njCUX5IgXAgMBAAECggEABR+bQzktXAk1v9/u+p16sgD997HUiEw3SY3SUOXAEBqp\nbguFuRTL3cmkHsjOF4ibwHnTzAwb5irqjmM8FqsGQIqpukFBtaD/ZD11Zgm4UhVC\ng7MXaoLPiCW1yUuVev8BnFwA30DpEk7lfnYKxUDPB6bDwg1uqpuNjtyifU5Z6pFB\nuVA/A8JyuXNA8Mb0OKC4eF2h0n7Yrzj4oYTOpz0VhwffqUqLoS1xDMRB5Zmdibkv\nKKbVEzAroyqgMwavr8Zxvz8QWOcdE19CH+onE3wC7cpAt7bkZPVnWi4RVQRJZdS8\naX85c3dqXD4zxmyYFzvfY41x80NXjeeaLXfe+GzgAQKBgQD2adw52B6Dpz26T6Nz\nFndMrET5SaXlaQofDKbOgP0AGX+HxnxTSmbX2pzrA7XyL+omLB4tpa3Uq3Hm9oy9\nHdN8fE0oAy1t7Kl3C3HzFhlQwv+zBpsgGasytaT0RZ74X75Xt1O4VhQbls+CT0In\nrBa82JN/ixJkg9FyBV1zZT2wAQKBgQDX4X6S1Ha4bCru6i1+CUsCT0o8YxJgGd2H\nTnZjFDUE9UcoXBLs+++uKrIw4l3MIi9vAy5S9FH3F85RgXe0VRE8xxkh2XCUs77F\nHnmG9jA/pdyUVuAwZc72WoWgd6xXqGS0NVSJXFeKaoNjYcvP0gJ3tKzxCxo1ttKz\nsfo4eNm4FwKBgQCv2t67PVyRkmJAO6Ond8oOIwdabVACyBLcE9hbmbx1PL1B9co2\nWuvIcpD4O/62Z7GQKn4jD5FeLDiunxfTw5xxw/gAbTwXrgVHGxjoZcYNWAzKBBXj\nM8508yNU3PbVxOZ/jSsna+8PvXI8SjopO+xCO8IQDP1EVLq9x8xolUEQAQKBgCIG\n/wZxyszC7/l8m/MTz+jrSo4+J3VSXmKncW2oj7raVn78FFeaVmsje7bM13AHq2Za\nIAEfVZQXAoRCXfXkurTTxRhax64IrvcvGIS3ZV+C60POdcPrKDYYipuCgX3Hoyfs\niAimr3230EHn9lIpjg4EQoYz88unp4p/cStZkSe9AoGBAJKQ9NmdO/FoOBFEHoAr\n7oCqYEt+kztnyXaC/1RR4qrVNEd5lZndDiGjgI5aNvODgJVG7sL0lm4YugRuNr/Y\n1fplQEdpNCuUJemYNaCqpT28l3IBEmzu4yWMxqYbcdKThU4tmBw1yazEmJ26W0U3\na4qSjv46tO/Mukv7dvbdcOPL\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheetoz@gsheetoz.iam.gserviceaccount.com",
  "client_id": "110937739275803744550",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheetoz%40gsheetoz.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  static final _spreadsheetId = '1sSOWqyP0VTg_Qn-Bo_dUeG20lTmrUcSXaVniPZ56sIU';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  Future<void> init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Items') ?? await ss.addWorksheet('Items');
  }

  Future<List<Map<String, dynamic>>> fetchSheetData() async {
    if (_worksheet == null) {
      await init();
    }

    final rows = await _worksheet!.values.allRows();
    List<Map<String, dynamic>> items = [];

    if (rows.isEmpty || rows[0].isEmpty) {
      return items;
    }

    final headers = rows[0];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.isEmpty || row[0].isEmpty) {
        continue;
      }

      Map<String, dynamic> item = {};
      for (int j = 0; j < headers.length; j++) {
        if(headers[j] == 'S/Item No.'){
          headers[j] = 'Item No.';
        }
        if(headers[j] == 'S/Item Name'){headers[j] = 'Item Name';}
        item[headers[j]] = row.length > j ? row[j] : '';
      }
      item.remove('USD');
      item.remove('C/F');
      item.remove('Tarih');

      Map<String, dynamic> previous_prices = {
        'price_1_1': row.length > 10 ? row[10] : '',
        'price_1_2': row.length > 11 ? row[11] : '',
        'price_1_3': row.length > 12 ? row[12] : '',
        'price_2_1': row.length > 13 ? row[13] : '',
        'price_2_2': row.length > 14 ? row[14] : '',
        'price_2_3': row.length > 15 ? row[15] : '',
        'price_3_1': row.length > 16 ? row[16] : '',
        'price_3_2': row.length > 17 ? row[17] : '',
        'price_3_3': row.length > 18 ? row[18] : '',
      };

      item['Previous_Prices'] = previous_prices;

      items.add(item);
    }

    return items;
  }

  Future<void> uploadDataToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final sheetData = await fetchSheetData();
    final firestoreData = await fetchFirestoreData();

    final sheetDataMap = {for (var item in sheetData) if (item['Kodu'] != null && item['Kodu'].toString() !='') item['Kodu']: item};

    for (var docId in firestoreData.keys) {
      if (!sheetDataMap.containsKey(docId)) {
        await firestore.collection('items').doc(docId).delete();
      }
    }

    for (var item in sheetData) {
      final docId = item['Kodu'];
      if (docId != null && docId.toString().isNotEmpty) {
        await firestore.collection('items').doc(docId).set(item);
      }
    }
  }

  Future<Map<String, dynamic>> fetchFirestoreData() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('items').get();
    final items = <String, dynamic>{};

    for (var doc in querySnapshot.docs) {
      items[doc.id] = doc.data();
    }

    return items;
  }

  Future<void> syncSheetToFirestore() async {
    final sheetData = await fetchSheetData();
    final firestoreData = await fetchFirestoreData();
    final firestore = FirebaseFirestore.instance;

    final sheetDataMap = {for (var item in sheetData) item['Kodu']: item};

    for (var firestoreItem in firestoreData.values) {
      if (!sheetDataMap.containsKey(firestoreItem['Kodu'])) {
        await firestore.collection('items').doc(firestoreItem['Kodu']).delete();
      }
    }

    for (var item in sheetData) {
      final id = item['Kodu'];
      if (id == null || id.isEmpty) {
        continue;
      }

      if (firestoreData.containsKey(id)) {
        final firestoreItem = firestoreData[id];
        bool hasChanged = false;

        Map<String, dynamic> updatedData = {};
        if (item['Kalite'] != firestoreItem['Kalite']) {
          updatedData['Kalite'] = item['Kalite'];
          hasChanged = true;
        }
        if (item['Eni'] != firestoreItem['Eni']) {
          updatedData['Eni'] = item['Eni'];
          hasChanged = true;
        }
        if (item['Gramaj'] != firestoreItem['Gramaj']) {
          updatedData['Gramaj'] = item['Gramaj'];
          hasChanged = true;
        }
        if (item['NOT'] != firestoreItem['NOT']) {
          updatedData['NOT'] = item['NOT'];
          hasChanged = true;
        }
        if (item['Supplier'] != firestoreItem['Supplier']) {
          updatedData['Supplier'] = item['Supplier'];
          hasChanged = true;
        }
        if (item['Item No.'] != firestoreItem['Item No.']) {
          updatedData['Item No.'] = item['Item No.'];
          hasChanged = true;
        }
        if (item['Item Name'] != firestoreItem['Item Name']) {
          updatedData['Item Name'] = item['Item Name'];
          hasChanged = true;
        }
        if (item['Price'] != firestoreItem['Price']) {
          updatedData['Price'] = item['Price'];
          hasChanged = true;
        }
        if (item['Date'] != firestoreItem['Date']) {
          updatedData['Date'] = item['Date'];
          hasChanged = true;
        }

        if (item['Previous_Prices'] != firestoreItem['Previous_Prices']) {
          updatedData['Previous_Prices'] = item['Previous_Prices'];
          hasChanged = true;
        }

        if (hasChanged) {
          await firestore.collection('items').doc(id).update(updatedData);
        }
      } else {
        await firestore.collection('items').doc(id).set(item);
      }
    }
  }
}
