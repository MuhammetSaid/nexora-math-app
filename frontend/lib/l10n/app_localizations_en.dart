// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Numera';

  @override
  String get homeTitle => 'NEXORA';

  @override
  String get startGame => 'Start Game';

  @override
  String get chapters => 'Chapters';

  @override
  String get endlessMode => 'Endless Mode';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get bottomIq => 'IQ';

  @override
  String get bottomLeaderboard => 'Leaderboard';

  @override
  String get bottomSettings => 'Settings';

  @override
  String get bottomSession => 'Session';

  @override
  String levelTitle(int level) {
    return 'Level $level';
  }

  @override
  String get answerLabel => 'Answer';

  @override
  String get enter => 'Enter';

  @override
  String get hint => 'Hint';

  @override
  String get settings => 'Settings';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get achievements => 'Achievements';

  @override
  String get language => 'Language';

  @override
  String get soundsOn => 'Sounds On';

  @override
  String get soundsOff => 'Sounds Off';

  @override
  String get deleteData => 'Delete Data';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get dialogPlaceholder => 'Content coming soon.';

  @override
  String get dailyPuzzle => 'Daily Puzzle';

  @override
  String get levelMode => 'Levels';

  @override
  String get play => 'Play';

  @override
  String get quiz => 'Quiz';

  @override
  String get botPlay => 'Play vs Bot';

  @override
  String get tournament => 'Tournament';

  @override
  String get levelsPlay => 'Play Levels';

  @override
  String get totalLevels => '100 Levels';
}
