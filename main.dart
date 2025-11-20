import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/products.dart';
import 'screens/sell.dart';
import 'screens/history.dart';
import 'screens/pin_lock.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String appName = 'GESTION DE VENTE';
  static final storage = FlutterSecureStorage();

  Future<bool> _isLocked() async {
    String? pin = await storage.read(key: 'app_pin');
    if (pin == null) {
      // set default PIN = 1234 and force change on first run (flag)
      await storage.write(key: 'app_pin', value: '1234');
      await storage.write(key: 'require_pin_change', value: 'true');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primaryColor: Color(0xFFFFA500),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
      ),
      home: FutureBuilder<bool>(
        future: _isLocked(),
        builder: (context, snap) {
          if (!snap.hasData) return CircularProgressIndicator();
          return PinLockScreen(child: MainPage(title: appName));
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;
  MainPage({required this.title});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final pages = [DashboardScreen(), ProductsScreen(), SellScreen(), HistoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title + '\nBoutique Tata Camm Solaire', style: TextStyle(fontSize: 16))),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        onTap: (i) => setState(() => currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Tableau'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produits'),
          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: 'Vente'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historique'),
        ],
      ),
    );
  }
}
