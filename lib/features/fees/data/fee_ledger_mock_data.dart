import '../models/fee_ledger.dart';

/// Replaceable fee-ledger content used during the UI-only phase.
abstract final class FeeLedgerMockData {
  static const FeeLedger ledger = FeeLedger(
    currentBalance: 149940,
    balanceType: FeeBalanceType.debit,
    entries: [
      FeeLedgerEntry(
        id: 'billing-2023-08-20-tuition',
        date: '20th August, 2023',
        type: FeeLedgerEntryType.billing,
        amount: 1040325,
        description: 'Tuition fees for Semester 1, 2023/2024',
      ),
      FeeLedgerEntry(
        id: 'billing-2023-08-20-functional',
        date: '20th August, 2023',
        type: FeeLedgerEntryType.billing,
        amount: 498065,
        description: 'Functional fees for Semester 1, 2023/2024',
      ),
      FeeLedgerEntry(
        id: 'payment-18916226',
        date: '30th August, 2023',
        type: FeeLedgerEntryType.payment,
        amount: 700000,
        description:
            'Fees payment for Semester 1, 2023/2024 through STANBIC BANK · TNo: 18916226',
      ),
      FeeLedgerEntry(
        id: 'payment-18952359',
        date: '2nd September, 2023',
        type: FeeLedgerEntryType.payment,
        amount: 100000,
        description:
            'Fees payment for Semester 1, 2023/2024 through STANBIC BANK · TNo: 18952359',
      ),
      FeeLedgerEntry(
        id: 'payment-19029406',
        date: '8th September, 2023',
        type: FeeLedgerEntryType.payment,
        amount: 300000,
        description:
            'Fees payment for Semester 1, 2023/2024 through STANBIC BANK · TNo: 19029406',
      ),
      FeeLedgerEntry(
        id: 'payment-20018822',
        date: '27th September, 2023',
        type: FeeLedgerEntryType.payment,
        amount: 100000,
        description:
            'Fees payment for Semester 1, 2023/2024 through STANBIC BANK · TNo: 20018822',
      ),
      FeeLedgerEntry(
        id: 'payment-22582869',
        date: '23rd January, 2024',
        type: FeeLedgerEntryType.payment,
        amount: 650000,
        description:
            'Fees payment for Semester 2, 2023/2024 through STANBIC BANK · TNo: 22582869',
      ),
      FeeLedgerEntry(
        id: 'billing-2024-01-25-tuition',
        date: '25th January, 2024',
        type: FeeLedgerEntryType.billing,
        amount: 1040325,
        description: 'Tuition fees for Semester 2, 2023/2024',
      ),
      FeeLedgerEntry(
        id: 'billing-2024-01-25-functional',
        date: '25th January, 2024',
        type: FeeLedgerEntryType.billing,
        amount: 643065,
        description: 'Functional fees for Semester 2, 2023/2024',
      ),
    ],
  );
}
