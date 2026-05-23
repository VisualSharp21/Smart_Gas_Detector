import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa a conexão com o Firebase configurado no seu projeto
  await Firebase.initializeApp();
  runApp(SmartGasApp());
}

class SmartGasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Gás',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GasMonitorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GasMonitorScreen extends StatefulWidget {
  @override
  _GasMonitorScreenState createState() => _GasMonitorScreenState();
}

class _GasMonitorScreenState extends State<GasMonitorScreen> {
  // Referência do nó no Firebase onde o ESP32 salva os dados do sensor
  final databaseReference = FirebaseDatabase.instance.ref("sensor/nivel_gas");
  int gasLevel = 0;

  @override
  void initState() {
    super.initState();
    // Escuta mudanças no Firebase em tempo real
    databaseReference.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          gasLevel = int.parse(data.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define o limite de perigo (mesmo configurado no ESP32)
    bool isDanger = gasLevel > 2000; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoramento Residencial'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDanger ? Icons.warning_amber_rounded : Icons.check_circle_outline,
              color: isDanger ? Colors.red : Colors.green,
              size: 120,
            ),
            SizedBox(height: 30),
            Text(
              'Leitura Atual do Sensor (MQ-5):',
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            Text(
              '$gasLevel',
              style: TextStyle(
                fontSize: 60, 
                fontWeight: FontWeight.bold,
                color: isDanger ? Colors.red : Colors.green,
              ),
            ),
            if (isDanger) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '🚨 VAZAMENTO DETECTADO 🚨',
                  style: TextStyle(color: Colors.red[900], fontSize: 22, fontWeight: FontWeight.bold),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}