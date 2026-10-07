import 'package:flutter/material.dart';

import '../../services/data/service_data.dart';
import '../../results/presentation/results_screen.dart';
import '../../fees/presentation/fees_screen.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/service_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/utils/context_extensions.dart';
import '../../../shared/models/service_item.dart';
import '../../../shared/widgets/app_icon_badge.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/service_list_tile.dart';

/// Shows the dashboard with student greeting, quick information, and services.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    this.studentName = AppConstants.studentName,
    this.currentTime,
    this.onOpenProfile,
    super.key,
  });

  final String studentName;

  /// Allows tests to supply a stable local time.
  final DateTime? currentTime;
  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final localTime = currentTime ?? DateTime.now();
    final greeting = AppFormatters.greetingFor(localTime);
    final isEvening = localTime.hour >= 17;

    return Column(
      children: [
        const _UniversityBanner(),
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Builds the scrollable dashboard content below the banner.
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.pagePadding,
                  18,
                  AppConstants.pagePadding,
                  24,
                ),
                sliver: SliverList.list(
                  children: [
                    _WelcomeCard(
                      studentName: studentName,
                      greeting: greeting,
                      timeIcon: isEvening
                          ? Icons.nightlight_round
                          : Icons.wb_sunny_outlined,
                      timeIconColor: isEvening
                          ? AppColors.purple
                          : AppColors.yellow,
                    ),
                    const SizedBox(height: 14),
                    const SectionHeader(title: 'Quick Info'),
                    const SizedBox(height: 6),
                    _QuickInfoRow(onOpenProfile: onOpenProfile),
                    const SizedBox(height: 14),
                    const SectionHeader(title: 'Other Services'),
                    const SizedBox(height: 6),
                    _ServiceList(items: ServiceData.homeServices),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Displays the university name and mobile portal identity.
/// Shows the university logo, name, and campus photograph at the top.
class _UniversityBanner extends StatelessWidget {
  const _UniversityBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF087A62), AppColors.primary],
        ),
      ),
      child: Stack(
        children: [
          // Uses an official IUIU campus image as a subtle banner background.
          Positioned.fill(
            child: Image.asset(
              'assets/images/iuiu_campus.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),

          // Keeps text readable over the campus image.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xF000745B), Color(0xB8008D6B)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Displays the official university crest.
                      Container(
                        width: 66,
                        height: 66,
                        padding: const EdgeInsets.all(2),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33003429),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/IUIU - Islamic University In Uganda Logo Vector.svg .png',
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'ISLAMIC UNIVERSITY IN UGANDA',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .2,
                                  shadows: [
                                    Shadow(
                                      color: Color(0x33000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'ACADEMICA ERP MOBILE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: .8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Greets the signed-in student and shows a simple local avatar.
/// Greets the current student and shows a compact identity summary.
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.studentName,
    required this.greeting,
    required this.timeIcon,
    required this.timeIconColor,
  });

  final String studentName;
  final String greeting;
  final IconData timeIcon;
  final Color timeIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          ProfileAvatar(name: studentName, square: true),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting,',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  studentName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Have a productive day!',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          AppIconBadge(
            icon: timeIcon,
            color: timeIconColor,
            size: 42,
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}

/// Groups the three most useful student shortcuts in one row.
/// Arranges the most important student shortcuts in one responsive row.
class _QuickInfoRow extends StatelessWidget {
  const _QuickInfoRow({this.onOpenProfile});

  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickInfoCard(
            icon: Icons.person,
            title: 'My Profile',
            subtitle: 'View & update your details',
            onTap: onOpenProfile ?? () => context.showComingSoon('My Profile'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickInfoCard(
            icon: Icons.bar_chart,
            title: 'My Results',
            subtitle: 'Check your performance',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ResultsScreen()),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickInfoCard(
            icon: Icons.account_balance_wallet,
            title: 'Fees Info',
            subtitle: 'View balances & payments',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const FeesScreen())),
          ),
        ),
      ],
    );
  }
}

/// Displays one shortcut with an icon, label, and short explanation.
/// Draws one tappable shortcut with an icon, title, and explanation.
class _QuickInfoCard extends StatelessWidget {
  const _QuickInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 156,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              children: [
                AppIconBadge(icon: icon, color: AppColors.primary),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps service rows in one rounded white surface.
/// Converts service data into the grouped list displayed on Home.
class _ServiceList extends StatelessWidget {
  const _ServiceList({required this.items});

  final List<ServiceItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return ServiceListTile(
            item: item,
            showDivider: index != items.length - 1,
            onTap: () => openService(context, item),
          );
        }),
      ),
    );
  }
}
