import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/l10n/app_localizations.dart';

import 'screens/home/home_screen.dart';
import 'theme/app_theme.dart';

/// Application entry point wiring localization and theming.
Future<void> main() async {
  await _bootstrap();
}

Future<void> _bootstrap() async {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const NexoraApp());
    },
    (Object error, StackTrace stackTrace) {
      debugPrint('Uncaught app error: $error\n$stackTrace');
    },
  );
}

class NexoraApp extends StatefulWidget {
  const NexoraApp({super.key});

  static _NexoraAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_NexoraAppState>();

  @override
  State<NexoraApp> createState() => _NexoraAppState();
}

class _NexoraAppState extends State<NexoraApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nexora Math',
      theme: AppTheme.light(),
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supported) {
        try {
          if (_locale != null) return _locale;
          if (locale == null) {
            return supported.first;
          }
          for (final Locale option in supported) {
            if (option.languageCode == locale.languageCode) {
              return option;
            }
          }
          return supported.first;
        } catch (error) {
          debugPrint('Locale resolution failed: $error');
          return supported.first;
        }
      },
      home: const HomeScreen(),
    );
  }
}
