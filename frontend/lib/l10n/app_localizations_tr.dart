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
  String get startGame => 'Oyuna BaYla';

  @override
  String get chapters => 'BÇôlÇ¬mler';

  @override
  String get endlessMode => 'Sonsuz Mod';

  @override
  String get comingSoon => 'YakŽñnda';

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
  String get hint => 'Žøpucu';

  @override
  String get settings => 'Ayarlar';

  @override
  String get profileSettings => 'Profil AyarlarŽñ';

  @override
  String get achievements => 'BaYarŽñlar';

  @override
  String get language => 'Dil';

  @override
  String get soundsOn => 'Ses AÇõŽñk';

  @override
  String get soundsOff => 'Ses KapalŽñ';

  @override
  String get deleteData => 'Verileri Sil';

  @override
  String get privacyPolicy => 'Gizlilik PolitikasŽñ';

  @override
  String get termsOfService => 'KullanŽñm ?artlarŽñ';

  @override
  String get dialogPlaceholder => 'ŽøÇõerik yakŽñnda.';

  @override
  String get dailyPuzzle => 'GÇ¬nlÇ¬k Soru';

  @override
  String get levelMode => 'Seviyeler';

  @override
  String get play => 'Oyna';

  @override
  String get quiz => 'Quiz';

  @override
  String get botPlay => 'Botla Oyna';

  @override
  String get tournament => 'Turnuva';

  @override
  String get levelsPlay => 'Seviyeli Oyna';

  @override
  String get totalLevels => '100 Seviye';

  @override
  String get changeAvatar => 'AvatarŽñ DeŽYiYtir';

  @override
  String get loginAnotherAccount => 'BaYka hesapla giriY yap';

  @override
  String get name => 'Žøsim';

  @override
  String get email => 'E-posta';

  @override
  String get password => '?ifre';

  @override
  String get authChoiceTitle => 'NasŽñl devam etmek istersin?';

  @override
  String get authChoiceSubtitle =>
      'Ž°lerlemeni kaydetmek iÇîn Google ile giriÇ yapabilir ya da misafir olarak devam edebilirsin.';

  @override
  String get continueAsGuest => 'Misafir olarak devam et';

  @override
  String get continueAsGuestCaption =>
      'HŽñzlŽñ baÇla, ilerlemen bu cihazda kalŽñr.';

  @override
  String get signInWithGoogle => 'Google ile giriÇ yap';

  @override
  String get signInWithGoogleCaption =>
      'Bulut yedekleme ve liderlik tablosu iÇîn önerilir.';

  @override
  String get authMaybeLater => 'Daha sonra';

  @override
  String get authFailed => 'GiriÇ baÇarŽñsŽz, lütfen tekrar dene.';

  @override
  String authSignedInAs(String name) {
    return '$name olarak giriÇ yapŽñldŽñ';
  }
}
