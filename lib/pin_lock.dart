import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinLockScreen extends StatefulWidget {
  final Widget child;
  PinLockScreen({required this.child});

  @override
  _PinLockScreenState createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final storage = FlutterSecureStorage();
  String entered = '';
  bool locked = true;
  bool requireChange = false;

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future _checkPin() async {
    String? pin = await storage.read(key: 'app_pin');
    String? need = await storage.read(key: 'require_pin_change');
    setState(() {
      locked = (pin != null);
      requireChange = (need == 'true');
    });
  }

  void _addDigit(String d) {
    if (entered.length >= 4) return;
    setState(() { entered += d; });
    if (entered.length == 4) _validate();
  }

  Future _validate() async {
    String? pin = await storage.read(key: 'app_pin') ?? '1234';
    if (entered == pin) {
      // if require change, navigate to change screen (simple dialog)
      if (requireChange) {
        await _showChangeDialog();
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => widget.child));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PIN incorrect')));
      setState(() { entered = ''; });
    }
  }

  Future _showChangeDialog() async {
    String newPin = '';
    await showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: Text('Changer le PIN'),
        content: TextField(
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: InputDecoration(hintText: 'Nouveau PIN 4 chiffres'),
          onChanged: (v) => newPin = v,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
          TextButton(onPressed: () async {
            if (newPin.length == 4) {
              await storage.write(key: 'app_pin', value: newPin);
              await storage.write(key: 'require_pin_change', value: 'false');
              Navigator.pop(context);
            }
          }, child: Text('Enregistrer'))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return locked ? Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.all(24),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Entrer le code PIN (4 chiffres)', style: TextStyle(fontSize: 18)),
              SizedBox(height:12),
              Text('*' * entered.length, style: TextStyle(letterSpacing: 6, fontSize: 24)),
              SizedBox(height:12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                children: List.generate(9, (i) => ElevatedButton(onPressed: () => _addDigit('${i+1}'), child: Text('${i+1}'))),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(onPressed: () { setState(() { entered = ''; }); }, child: Text('Clear')),
                SizedBox(width:12),
                ElevatedButton(onPressed: () async {
                  // reset app_pin (dangerous) - for debug only
                  await storage.delete(key: 'app_pin');
                  await storage.write(key: 'app_pin', value: '1234');
                  await storage.write(key: 'require_pin_change', value: 'true');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PIN réinitialisé par défaut')));
                }, child: Text('Réinitialiser (debug)')),
              ])
            ]),
          ),
        ),
      ),
    ) : widget.child;
  }
}
