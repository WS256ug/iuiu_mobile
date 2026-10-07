/// Says whether a ledger row adds a charge or records a payment.
enum FeeLedgerEntryType { billing, payment }

/// Says whether the final balance is money owed or money in credit.
enum FeeBalanceType { credit, debit }

/// One billing or payment transaction in the student's fee ledger.
/// Stores one dated financial movement shown in the fee history.
class FeeLedgerEntry {
  const FeeLedgerEntry({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
    required this.description,
  });

  final String id;
  final String date;
  final FeeLedgerEntryType type;
  final int amount;
  final String description;
}

/// Current balance and transactions displayed by the fee-ledger screen.
/// Groups a student's fee summary and the rows that explain it.
class FeeLedger {
  const FeeLedger({
    required this.currentBalance,
    required this.balanceType,
    required this.entries,
  });

  final int currentBalance;
  final FeeBalanceType balanceType;
  final List<FeeLedgerEntry> entries;
}
