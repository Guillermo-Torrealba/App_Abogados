enum TransactionType { gasto, honorario, abono }

class FinancialTransaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final bool isReimbursable;

  FinancialTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    this.isReimbursable = true,
  });
}

class LegalCase {
  final String id;
  final String title;
  final String clientName;
  final DateTime creationDate;
  final int urgency; // 1: Low, 2: Medium, 3: High
  final List<FinancialTransaction> transactions;

  LegalCase({
    required this.id,
    required this.title,
    required this.clientName,
    required this.creationDate,
    required this.urgency,
    required this.transactions, // Cambiado a required para evitar errores
  });

  double get totalGastos => transactions
      .where((t) => t.type == TransactionType.gasto)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalHonorarios => transactions
      .where((t) => t.type == TransactionType.honorario)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalAbonos => transactions
      .where((t) => t.type == TransactionType.abono)
      .fold(0, (sum, t) => sum + t.amount);
}
