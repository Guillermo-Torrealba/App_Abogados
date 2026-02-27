import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import 'case_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<LegalCase> cases;

  const DashboardScreen({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    // Calculamos KPIs
    double totalHonorarios = cases.fold(0, (sum, c) => sum + c.totalHonorarios);
    double totalGastos = cases.fold(0, (sum, c) => sum + c.totalGastos);

    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'es_CL',
      decimalDigits: 0,
    );

    // Tomar los 3 más recientes para el dashboard
    final recentCases = List<LegalCase>.from(cases)
      ..sort((a, b) => b.creationDate.compareTo(a.creationDate));
    final displayCases = recentCases.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen Financiero',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildKPICard(
                      title: 'Total por Cobrar',
                      amount: formatCurrency.format(totalHonorarios),
                      color: Colors.green,
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildKPICard(
                      title: 'Gastos Pendientes',
                      amount: formatCurrency.format(totalGastos),
                      color: Colors.redAccent,
                      icon: Icons.receipt_long,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Expedientes Recientes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...displayCases.map((c) => _buildCaseCard(context, c)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseCard(BuildContext context, LegalCase legalCase) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey[100],
          child: const Icon(Icons.folder, color: Colors.blueGrey),
        ),
        title: Text(
          legalCase.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(legalCase.clientName),
            const SizedBox(height: 4),
            Text(
              'Creado: ${DateFormat('dd/MM/yyyy').format(legalCase.creationDate)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaseDetailScreen(legalCase: legalCase),
            ),
          );
        },
      ),
    );
  }
}
