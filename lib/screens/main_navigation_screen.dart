import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'dashboard_screen.dart';
import 'cases_screen.dart';
import 'calendar_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Shared state: List of cases
  final List<LegalCase> cases = [
    LegalCase(
      id: '1',
      title: 'Sucesión Familia Gonzalez',
      clientName: 'María Gonzalez',
      creationDate: DateTime.now().subtract(const Duration(days: 30)),
      urgency: 2,
      transactions: [],
    ),
    LegalCase(
      id: '2',
      title: 'Despido Injustificado vs Empresa X',
      clientName: 'Juan Pérez',
      creationDate: DateTime.now().subtract(const Duration(days: 5)),
      urgency: 3,
      transactions: [],
    ),
    LegalCase(
      id: '3',
      title: 'Divorcio de Mutuo Acuerdo',
      clientName: 'Ana Silva',
      creationDate: DateTime.now().subtract(const Duration(days: 60)),
      urgency: 1,
      transactions: [],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showQuickActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Acciones Rápidas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.money_off, color: Colors.red),
                title: const Text('Registrar Gasto'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to create transaction (Gasto)
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.green),
                title: const Text('Registrar Ingreso'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to create transaction (Ingreso/Honorario)
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_open, color: Colors.blue),
                title: const Text('Nuevo Expediente'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to create case
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // List of screens to display for each tab
    final List<Widget> _screens = [
      DashboardScreen(cases: cases),
      CasesScreen(cases: cases, onCasesUpdated: () => setState(() {})),
      CalendarScreen(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showQuickActionsBottomSheet(context),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Expedientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
        ],
      ),
    );
  }
}
