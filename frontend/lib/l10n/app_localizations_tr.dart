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

  @override
  String get settings => 'Ayarlar';

  @override
  String get profileSettings => 'Profil Ayarları';

  @override
  String get changeAvatar => 'Avatarını Değiştir';

  @override
  String get loginAnotherAccount => 'Başka bir hesapla giriş yap';

  @override
  String get loginTitle => 'Giriş yap';

  @override
  String get loginSubtitle => 'Devam etmek için e-posta ve şifreni gir.';

  @override
  String get loginButton => 'Giriş yap';

  @override
  String get loginCancel => 'Kapat';

  @override
  String get loginInvalid => 'E-posta veya şifre hatalı';

  @override
  String get loginFailed => 'Giriş yapılamadı, lütfen tekrar dene';

  @override
  String get profileName => 'İsim';

  @override
  String get profileEmail => 'E-posta';

  @override
  String get profilePassword => 'Şifre';

  @override
  String get passwordOptional => 'Mevcut şifreyi korumak için boş bırak';

  @override
  String get saveProfile => 'Profili Kaydet';

  @override
  String get profileSaved => 'Profil kaydedildi';

  @override
  String get profileSaveFailed => 'Profil kaydedilemedi';

  @override
  String get clearedProfile => 'Profil önbelleği temizlendi';

  @override
  String get nameRequired => 'İsim gerekli';

  @override
  String get emailRequired => 'E-posta gerekli';

  @override
  String get invalidEmail => 'Geçerli bir e-posta girin';

  @override
  String get passwordRequired => 'Şifre gerekli';

  @override
  String get achievements => 'Başarılar';

  @override
  String get language => 'Dil';

  @override
  String get soundsOn => 'Ses Açık';

  @override
  String get soundsOff => 'Ses Kapalı';

  @override
  String get deleteData => 'Verileri Sil';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsOfService => 'Kullanım Şartları';

  @override
  String get dialogPlaceholder => 'İçerik yakında.';

  @override
  String get dailyPuzzle => 'Günlük Soru';

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
}
