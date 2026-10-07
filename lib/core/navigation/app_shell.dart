import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/messages/presentation/messages_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import '../theme/app_colors.dart';

/// Holds the main pages and switches between them using bottom navigation.
class AppShell extends StatefulWidget {
  const AppShell({this.onLogout, super.key});

  final VoidCallback? onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

/// Remembers the selected bottom tab while the user moves around the app.
class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Keeps each tab alive so scroll and search state are not lost.
    final screens = [
      HomeScreen(onOpenProfile: () => setState(() => _currentIndex = 3)),
      const ServicesScreen(),
      const MessagesScreen(),
      ProfileScreen(onLogout: widget.onLogout),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.pageBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: AppBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
