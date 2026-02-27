import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'case_detail_screen.dart';
import 'package:intl/intl.dart';

class CasesScreen extends StatefulWidget {
  final List<LegalCase> cases;
  final VoidCallback onCasesUpdated;

  const CasesScreen({
    super.key,
    required this.cases,
    required this.onCasesUpdated,
  });

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  String _sortOption = 'Fecha';

  List<LegalCase> get _sortedCases {
    List<LegalCase> sorted = List.from(widget.cases);
    switch (_sortOption) {
      case 'Nombre':
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Urgencia':
        // Descending urgency (3 is highest)
        sorted.sort((a, b) => b.urgency.compareTo(a.urgency));
        break;
      case 'Fecha':
      default:
        // Descending creation date (newest first)
        sorted.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedientes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildFiltersRow(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _sortedCases.length,
              itemBuilder: (context, index) {
                final legalCase = _sortedCases[index];
                return _buildCaseCard(context, legalCase);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Ordenar por: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Fecha', 'Nombre', 'Urgencia'].map((String option) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(option),
                      selected: _sortOption == option,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            _sortOption = option;
                          });
                        }
                      },
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
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
          backgroundColor: _getUrgencyColor(legalCase.urgency),
          child: const Icon(Icons.folder, color: Colors.white),
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
          ).then((_) {
            // Callback to update parent screen if data changed
            widget.onCasesUpdated();
            setState(() {});
          });
        },
      ),
    );
  }

  Color _getUrgencyColor(int urgency) {
    if (urgency >= 3) return Colors.redAccent;
    if (urgency == 2) return Colors.amber;
    return Colors.green;
  }
}
