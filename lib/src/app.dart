import 'package:ebom/src/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'config/app_themes.dart';

/// The Widget that configures your application.
class EbomApp extends StatelessWidget {
  const EbomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // restorationScopeId: 'app',
      // localizationsDelegates: context.localizationDelegates,
      // supportedLocales: context.supportedLocales,
      // locale: context.locale,
      // onGenerateTitle: (_) => LocaleKeys.app_title.tr(),
      themeMode: ThemeMode.light,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}
