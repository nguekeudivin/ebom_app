import 'package:ebom/generated/locale_keys.g.dart';
import 'package:ebom/src/screens/app_layout.dart';
import 'package:ebom/src/screens/entreprise_details_screen.dart';
import 'package:ebom/src/screens/home_screen.dart';
import 'package:ebom/src/screens/login/opt_verification_screen.dart';
import 'package:ebom/src/screens/register/register_screen_1.dart';
import 'package:ebom/src/screens/register/register_screen_2.dart';
import 'package:ebom/src/screens/welcome_screen.dart';
import 'package:ebom/src/types/auth_types.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'config/app_themes.dart';

/// The Widget that configures your application.
class EbomApp extends StatelessWidget {
  const EbomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateTitle: (_) => LocaleKeys.app_title.tr(),
      themeMode: ThemeMode.light,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      // Remplace `WelcomeScreen` par ta SCREEN pour la tester et à la fin remet
      // `WelcomeScreen` comme tu vois.
      home: AppLayout(),
    );
  }
}
