import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/utils/context_extensions.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../data/fee_ledger_mock_data.dart';
import '../models/fee_ledger.dart';

/// Displays the current fee balance and chronological payment ledger.
class FeesScreen extends StatelessWidget {
  const FeesScreen({this.ledger = FeeLedgerMockData.ledger, super.key});

  final FeeLedger ledger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Fees Info', showBackButton: true),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 760 ? 2 : 1;
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.pagePadding,
                          20,
                          AppConstants.pagePadding,
                          14,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 960),
                              child: Column(
                                children: [
                                  const Text(
                                    'FEES PAYMENT LEDGER',
                                    style: AppTextStyles.screenHeading,
                                  ),
                                  const SizedBox(height: 14),
                                  _BalanceCard(
                                    ledger: ledger,
                                    onPayFees: () => context.showComingSoon(
                                      'SchoolPay fees payment',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.pagePadding,
                          0,
                          AppConstants.pagePadding,
                          28,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 132,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _LedgerCard(entry: ledger.entries[index]),
                            childCount: ledger.entries.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Highlights the current balance and offers the represented payment action.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.ledger, required this.onPayFees});

  final FeeLedger ledger;
  final VoidCallback onPayFees;

  @override
  Widget build(BuildContext context) {
    final balanceSuffix = ledger.balanceType == FeeBalanceType.credit
        ? 'CR'
        : 'DR';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'CURRENT BALANCE: ${AppFormatters.wholeNumber(ledger.currentBalance)} $balanceSuffix',
            style: const TextStyle(
              color: AppColors.red,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'CR indicates a positive balance; DR indicates a negative balance.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const Text(
            'Fee ledgers are subject to regular adjustments in billings and payments.',
            style: AppTextStyles.supporting,
          ),
          const SizedBox(height: 18),
          Center(
            child: FilledButton.icon(
              key: const ValueKey('pay-fees-button'),
              onPressed: onPayFees,
              icon: const Icon(Icons.account_balance_wallet_outlined, size: 19),
              label: const Text('PAY FEES (SCHOOLPAY)'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(250, 50),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays one billing or payment entry in the chronological ledger.
class _LedgerCard extends StatelessWidget {
  const _LedgerCard({required this.entry});

  final FeeLedgerEntry entry;

  @override
  Widget build(BuildContext context) {
    final isPayment = entry.type == FeeLedgerEntryType.payment;
    final accent = isPayment ? AppColors.primary : AppColors.textPrimary;
    return Container(
      key: ValueKey('fee-ledger-${entry.id}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: isPayment ? AppColors.primary : AppColors.orange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Text(
                  entry.date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  isPayment ? 'Payment' : 'Billing',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  AppFormatters.wholeNumber(entry.amount),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 2, color: AppColors.primary),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              entry.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isPayment
                    ? AppColors.primaryDark
                    : AppColors.textPrimary,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
