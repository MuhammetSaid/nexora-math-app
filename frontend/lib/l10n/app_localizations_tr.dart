// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Numera';

  @override
  String get homeTitle => 'NEXORA';

  @override
  String get startGame => 'Oyuna Başla';

  @override
  String get chapters => 'Bölümler';

  @override
  String get endlessMode => 'Sonsuz Mod';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get bottomIq => 'IQ';

  @override
  String get bottomLeaderboard => 'Liderlik';

  @override
  String get bottomSettings => 'Ayarlar';

  @override
  String get bottomSession => 'Oturum';

  @override
  String levelTitle(int level) {
    return 'Seviye $level';
  }

  @override
  String get answerLabel => 'Cevap';

  @override
  String get enter => 'Enter';

  @override
  String get hint => 'İpucu';
}
