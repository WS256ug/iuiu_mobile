import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'features/authentication/presentation/login_screen.dart';

/// Configures the application theme and opens the sign-in flow.
class IuiuApp extends StatelessWidget {
  const IuiuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IUIU Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: AppColors.pageBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: Colors.white,
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
