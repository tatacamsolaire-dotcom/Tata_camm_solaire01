import 'package:flutter/material.dart';
import '../db/app_db.dart';
import '../models/product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final db = AppDB();
  List<Product> products = [];
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  int purchasePrice = 0;
  int salePrice = 0;
  int qty = 0;
  Product? editing;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    products = await db.allProducts();
    setState(() {});
  }

  Future _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    if (editing != null) {
      editing!.name = name;
      editing!.description = description;
      editing!.purchasePrice = purchasePrice;
      editing!.salePrice = salePrice;
      editing!.stock = qty;
      editing!.initialStock = qty;
      await db.updateProduct(editing!);
    } else {
      final p = Product(name: name, description: description, purchasePrice: purchasePrice, salePrice: salePrice, initialStock: qty, stock: qty);
      await db.insertProduct(p);
    }
    editing = null;
    _formKey.currentState!.reset();
    _load();
  }

  Future _deleteAll() async {
    await db.deleteAllProducts();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(children: [
              Text('Ajouter / Modifier produit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(decoration: InputDecoration(labelText: 'Nom du produit'), onSaved: (v)=> name = v ?? ''),
              TextFormField(decoration: InputDecoration(labelText: 'Description du produit'), onSaved: (v)=> description = v ?? ''),
              TextFormField(decoration: InputDecoration(labelText: 'Prix d\'achat (FCFA)'), keyboardType: TextInputType.number, onSaved: (v)=> purchasePrice = int.tryParse(v ?? '0') ?? 0),
              TextFormField(decoration: InputDecoration(labelText: 'Prix de vente (FCFA)'), keyboardType: TextInputType.number, onSaved: (v)=> salePrice = int.tryParse(v ?? '0') ?? 0),
              TextFormField(decoration: InputDecoration(labelText: 'Quantité'), keyboardType: TextInputType.number, onSaved: (v)=> qty = int.tryParse(v ?? '0') ?? 0),
              SizedBox(height:8),
              Row(children: [
                ElevatedButton(onPressed: _save, child: Text('Enregistrer produit')),
                SizedBox(width:8),
                ElevatedButton(onPressed: _deleteAll, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text('Supprimer tous les produits')),
                SizedBox(width:8),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Accueil')),
              ]),
            ]),
          ),
          SizedBox(height:12),
          Text('Liste des produits', style: TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
          ...products.map((p) => Card(
            child: ListTile(
              title: Text(p.name + ' - ' + p.salePrice.toString() + ' FCFA'),
              subtitle: Text('Stock: ' + p.stock.toString()),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: Icon(Icons.edit), onPressed: () {
                  setState(() {
                    editing = p;
                  });
                }),
                IconButton(icon: Icon(Icons.delete), onPressed: () async {
                  await db.deleteAllProducts(); // placeholder
                  _load();
                }),
              ]),
            ),
          )).toList()
        ],
      ),
    );
  }
}
