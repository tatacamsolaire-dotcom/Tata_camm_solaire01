import 'package:flutter/material.dart';
import '../db/app_db.dart';
import '../models/product.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final db = AppDB();
  List<Product> products = [];
  int stockTotal = 0;
  int stockValue = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    products = await db.allProducts();
    stockTotal = products.fold(0, (p, e) => p + (e.stock as int));
    stockValue = products.fold(0, (p, e) => p + (e.stock * e.salePrice));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tableau de bord', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height:8),
                  Row(children: [Text('Nombre de produits: '), SizedBox(width:8), Text('${products.length}')]),
                  SizedBox(height:8),
                  Row(children: [Text('Stock total: '), SizedBox(width:8), Text('\$${stockTotal}')]),
                  SizedBox(height:8),
                  Row(children: [Text('Valeur du stock (FCFA): '), SizedBox(width:8), Text('${stockValue} FCFA')]),
                  SizedBox(height:12),
                  Row(children: [
                    ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductsScreen())).then((_) => _load()), child: Text('Gérer produit')),
                    SizedBox(width:8),
                    ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellScreen())).then((_) => _load()), child: Text('Vente')),
                    SizedBox(width:8),
                    ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreen())).then((_) => _load()), child: Text('Historique')),
                  ])
                ],
              ),
            ),
          ),
          SizedBox(height:12),
          Card(
            color: Colors.grey[200],
            child: Container(
              height: 220,
              padding: EdgeInsets.all(12),
              child: Center(child: Text('Graphique barre (placeholder)\n(Changer de vue)', textAlign: TextAlign.center)),
            ),
          ),
          SizedBox(height:20),
          Center(child: Text('PDG Dramane Traore', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
