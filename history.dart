import 'package:flutter/material.dart';
import '../db/app_db.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final db = AppDB();
  List<Map<String,dynamic>> sales = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    sales = await db.allSales();
    setState(() {});
  }

  Future _exportJson() async {
    final dir = await getTemporaryDirectory();
    final f = File('${dir.path}/sales_export.json');
    await f.writeAsString(jsonEncode(sales));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export JSON créé: ' + f.path)));
  }

  Future _exportPdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (c) {
      return pw.Column(children: sales.map((s) => pw.Text('${s['date']} - ${s['productName']} x${s['quantity']} = ${s['amount']} FCFA - ${s['clientName']} (${s['city']})')).toList());
    }));
    final bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (format) => bytes);
  }

  Future _clearAll() async {
    await db.deleteAllSales();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(children: [
        Text('Historique des ventes', style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
        SizedBox(height:8),
        ...sales.map((s) => Card(child: ListTile(
          title: Text('${s['productName']} - ${s['amount']} FCFA'),
          subtitle: Text('Client: ${s['clientName']} - ${s['clientPhone']}\nVille: ${s['city']}\nDate: ${s['date']}'),
        ))).toList(),
        SizedBox(height:12),
        Row(children: [
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Accueil')),
          SizedBox(width:8),
          ElevatedButton(onPressed: _clearAll, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text('Effacer tout')),
          SizedBox(width:8),
          ElevatedButton(onPressed: _exportPdf, child: Text('Exporter en PDF')),
          SizedBox(width:8),
          ElevatedButton(onPressed: _exportJson, child: Text('Exporter données (.json)')),
        ])
      ]),
    );
  }
}
