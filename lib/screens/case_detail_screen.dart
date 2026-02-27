import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class CaseDetailScreen extends StatefulWidget {
  final LegalCase legalCase;

  const CaseDetailScreen({super.key, required this.legalCase});

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  void _addTransaction(String desc, double amount, TransactionType type) {
    setState(() {
      widget.legalCase.transactions.add(
        FinancialTransaction(
          id: DateTime.now().toString(),
          description: desc,
          amount: amount,
          date: DateTime.now(),
          type: type,
        ),
      );
    });
    Navigator.pop(context);
  }

  void _showAddTransactionDialog(BuildContext context) {
    String description = '';
    String amountStr = '';
    TransactionType selectedType = TransactionType.gasto;

    showDialog(
      context: context,
      builder: (ctx) {
        // Usamos StatefulBuilder para actualizar el dropdown dentro del diálogo
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Nuevo Movimiento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Descripción (ej: Notaría)',
                    ),
                    onChanged: (val) => description = val,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Monto'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => amountStr = val,
                  ),
                  DropdownButton<TransactionType>(
                    value: selectedType,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        value: TransactionType.gasto,
                        child: Text('Gasto (Salida)'),
                      ),
                      DropdownMenuItem(
                        value: TransactionType.honorario,
                        child: Text('Honorario (Cobro)'),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => selectedType = val!);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (description.isNotEmpty && amountStr.isNotEmpty) {
                      _addTransaction(
                        description,
                        double.parse(amountStr),
                        selectedType,
                      );
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'es_CL',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.legalCase.title)),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.blueGrey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Gastos', style: TextStyle(color: Colors.red)),
                    Text(
                      formatCurrency.format(widget.legalCase.totalGastos),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Honorarios', style: TextStyle(color: Colors.green)),
                    Text(
                      formatCurrency.format(widget.legalCase.totalHonorarios),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.legalCase.transactions.length,
              itemBuilder: (context, index) {
                final tx = widget.legalCase.transactions[index];
                return ListTile(
                  leading: Icon(
                    tx.type == TransactionType.gasto
                        ? Icons.remove_circle
                        : Icons.add_circle,
                    color: tx.type == TransactionType.gasto
                        ? Colors.red
                        : Colors.green,
                  ),
                  title: Text(tx.description),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(tx.date)),
                  trailing: Text(formatCurrency.format(tx.amount)),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context),
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}
