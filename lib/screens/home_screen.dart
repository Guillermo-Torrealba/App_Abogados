import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'case_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Datos de prueba iniciales
  List<LegalCase> cases = [
    LegalCase(
      id: '1',
      title: 'Sucesión Familia Gonzalez',
      clientName: 'María Gonzalez',
      transactions: [],
    ),
    LegalCase(
      id: '2',
      title: 'Despido Injustificado vs Empresa X',
      clientName: 'Juan Pérez',
      transactions: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión Bufete')),
      body: ListView.builder(
        itemCount: cases.length,
        itemBuilder: (context, index) {
          final legalCase = cases[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                legalCase.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(legalCase.clientName),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CaseDetailScreen(legalCase: legalCase),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
          );
        },
      ),
    );
  }
}
