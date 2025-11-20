import 'package:flutter/material.dart';
import '../db/app_db.dart';
import '../models/product.dart';
import '../models/sale.dart';
import 'package:intl/intl.dart';

class SellScreen extends StatefulWidget {
  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final db = AppDB();
  List<Product> products = [];
  Product? selected;
  int qty = 1;
  String clientName = '';
  String clientPhone = '';
  String city = '';
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    products = await db.allProducts();
    setState(() {});
  }

  Future _sell() async {
    if (selected == null) return;
    if (selected!.stock < qty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stock insuffisant')));
      return;
    }
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    final amount = selected!.salePrice * qty;
    selected!.stock = selected!.stock - qty;
    await db.updateProduct(selected!);
    final s = Sale(productId: selected!.id!, productName: selected!.name, quantity: qty, amount: amount, clientName: clientName, clientPhone: clientPhone, city: city, date: now);
    await db.insertSale(s);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vente enregistrée')));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(children: [
        DropdownButton<Product>(
          isExpanded: true,
          value: selected,
          hint: Text('Sélection du produit'),
          items: products.map((p) => DropdownMenuItem(value: p, child: Text('${p.name} - ${p.salePrice} FCFA (stock ${p.stock})'))).toList(),
          onChanged: (v) => setState(()=> selected = v),
        ),
        TextField(decoration: InputDecoration(labelText: 'Quantité'), keyboardType: TextInputType.number, onChanged: (v)=> qty = int.tryParse(v) ?? 1),
        TextField(decoration: InputDecoration(labelText: 'Ville du client'), onChanged: (v)=> city = v),
        TextField(decoration: InputDecoration(labelText: 'Nom du client'), onChanged: (v)=> clientName = v),
        TextField(decoration: InputDecoration(labelText: 'Numéro du client'), keyboardType: TextInputType.phone, onChanged: (v)=> clientPhone = v),
        SizedBox(height:8),
        ElevatedButton(onPressed: _sell, child: Text('Enregistrer & Facturer')),
        SizedBox(height:8),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Accueil')),
      ]),
    );
  }
}
