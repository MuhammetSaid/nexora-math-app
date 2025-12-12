# 🎯 Nexora Math App - Proje Klasör Yapısı

## 📁 Ana Proje Yapısı

```
NexoraMathApp/
├── Backend/          # FastAPI Backend
├── frontend/         # Flutter Mobil Uygulama
├── DB/              # Veritabanı dosyaları ve migrasyonlar
└── PROJE_YAPISI.md  # Bu dosya
```

---

## 🐍 Backend Klasör Yapısı (FastAPI + Python)

```
Backend/
├── app/
│   ├── __init__.py
│   ├── main.py                    # FastAPI ana uygulama dosyası
│   │
│   ├── api/                       # API endpoint'leri
│   │   ├── __init__.py
│   │   ├── endpoints/             # Tüm API endpoint'leri
│   │   │   ├── __init__.py
│   │   │   ├── auth.py           # Login, register, logout
│   │   │   ├── users.py          # Kullanıcı profil işlemleri
│   │   │   ├── levels.py         # Seviye listesi ve detayları
│   │   │   ├── game.py           # Oyun oynama, soru getirme
│   │   │   ├── leaderboard.py    # Lider tablosu
│   │   │   ├── shop.py           # Mağaza işlemleri
│   │   │   ├── tournament.py     # Turnuva işlemleri
│   │   │   └── bot.py            # Bot ile oynama
│   │   │
│   │   └── dependencies/          # API bağımlılıkları
│   │       ├── __init__.py
│   │       └── auth.py           # JWT token kontrolü, current_user
│   │
│   ├── core/                      # Çekirdek yapılandırmalar
│   │   ├── __init__.py
│   │   ├── config.py             # Ayarlar (.env'den okunan)
│   │   ├── security.py           # Password hashing, JWT
│   │   └── database.py           # Veritabanı bağlantı yönetimi
│   │
│   ├── models/                    # SQLAlchemy ORM modelleri
│   │   ├── __init__.py
│   │   ├── user.py               # User tablosu
│   │   ├── level.py              # Level tablosu
│   │   ├── question.py           # Question tablosu
│   │   ├── user_level.py         # Kullanıcı seviye ilerleme
│   │   ├── game_session.py       # Oyun oturumu kayıtları
│   │   ├── leaderboard.py        # Lider tablosu
│   │   ├── shop_item.py          # Mağaza ürünleri
│   │   └── tournament.py         # Turnuva kayıtları
│   │
│   ├── schemas/                   # Pydantic şemaları (request/response)
│   │   ├── __init__.py
│   │   ├── user.py               # UserCreate, UserResponse, etc.
│   │   ├── auth.py               # Login, Token response
│   │   ├── level.py              # Level response şemaları
│   │   ├── question.py           # Question şemaları
│   │   ├── game.py               # Game session şemaları
│   │   ├── leaderboard.py        # Leaderboard şemaları
│   │   └── shop.py               # Shop item şemaları
│   │
│   ├── services/                  # İş mantığı katmanı
│   │   ├── __init__.py
│   │   ├── auth_service.py       # Login, register mantığı
│   │   ├── user_service.py       # Kullanıcı işlemleri
│   │   ├── level_service.py      # Seviye ve soru servisleri
│   │   ├── game_service.py       # Oyun mantığı
│   │   ├── leaderboard_service.py # Sıralama hesaplamaları
│   │   ├── shop_service.py       # Mağaza işlemleri
│   │   ├── bot_service.py        # Bot AI mantığı
│   │   └── iq_calculator.py      # IQ hesaplama algoritması
│   │
│   ├── db/                        # Veritabanı yönetimi
│   │   ├── __init__.py
│   │   ├── session.py            # DB session yönetimi
│   │   └── base.py               # Base model
│   │
│   └── utils/                     # Yardımcı fonksiyonlar
│       ├── __init__.py
│       ├── validators.py         # Özel validasyonlar
│       ├── helpers.py            # Genel yardımcı fonksiyonlar
│       └── constants.py          # Sabitler
│
├── tests/                         # Test dosyaları
│   ├── __init__.py
│   ├── api/                      # API testleri
│   │   ├── __init__.py
│   │   ├── test_auth.py
│   │   ├── test_game.py
│   │   └── test_leaderboard.py
│   └── services/                 # Servis testleri
│       ├── __init__.py
│       └── test_game_service.py
│
├── requirements.txt               # Python paketleri
├── .gitignore                    # Git ignore dosyası
└── README.md                     # Backend dokümantasyonu
```

---

## 📱 Frontend Klasör Yapısı (Flutter)

```
frontend/
├── lib/
│   ├── main.dart                 # Ana giriş noktası
│   │
│   ├── screens/                  # Ekranlar
│   │   ├── auth/                # Giriş/Kayıt ekranları
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   │
│   │   ├── home/                # Ana sayfa
│   │   │   └── home_screen.dart
│   │   │
│   │   ├── game/                # Oyun ekranları
│   │   │   ├── game_mode_screen.dart    # Oyun modları
│   │   │   ├── question_screen.dart     # Soru gösterimi
│   │   │   └── result_screen.dart       # Sonuç ekranı
│   │   │
│   │   ├── levels/              # Seviyeler
│   │   │   └── levels_screen.dart
│   │   │
│   │   ├── profile/             # Profil
│   │   │   └── profile_screen.dart
│   │   │
│   │   ├── leaderboard/         # Lider tablosu
│   │   │   └── leaderboard_screen.dart
│   │   │
│   │   ├── shop/                # Mağaza
│   │   │   └── shop_screen.dart
│   │   │
│   │   ├── settings/            # Ayarlar
│   │   │   └── settings_screen.dart
│   │   │
│   │   └── tournament/          # Turnuva
│   │       └── tournament_screen.dart
│   │
│   ├── widgets/                  # Özel widget'lar
│   │   ├── common/              # Genel widget'lar
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── loading_indicator.dart
│   │   │   └── custom_app_bar.dart
│   │   │
│   │   └── game/                # Oyun widget'ları
│   │       ├── question_card.dart
│   │       ├── answer_button.dart
│   │       ├── timer_widget.dart
│   │       └── score_display.dart
│   │
│   ├── models/                   # Veri modelleri
│   │   ├── user/
│   │   │   └── user_model.dart
│   │   │
│   │   ├── game/
│   │   │   ├── question_model.dart
│   │   │   ├── game_session_model.dart
│   │   │   └── answer_model.dart
│   │   │
│   │   └── level/
│   │       └── level_model.dart
│   │
│   ├── services/                 # Servisler
│   │   ├── api/                 # API çağrıları
│   │   │   └── api_service.dart
│   │   │
│   │   ├── auth/                # Auth servisleri
│   │   │   └── auth_service.dart
│   │   │
│   │   └── game/                # Oyun servisleri
│   │       └── game_service.dart
│   │
│   ├── utils/                    # Yardımcı fonksiyonlar
│   │   ├── constants.dart       # Sabitler
│   │   ├── validators.dart      # Validasyonlar
│   │   └── helpers.dart         # Yardımcı fonksiyonlar
│   │
│   ├── config/                   # Konfigürasyon
│   │   ├── api_config.dart      # API ayarları
│   │   └── app_config.dart      # Uygulama ayarları
│   │
│   └── theme/                    # Tema ayarları
│       ├── app_theme.dart       # Ana tema
│       ├── colors.dart          # Renkler
│       └── text_styles.dart     # Yazı stilleri
│
├── assets/                       # Görseller, fontlar
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── test/                         # Test dosyaları
│   └── widget_test.dart
│
├── android/                      # Android platform dosyaları
├── ios/                          # iOS platform dosyaları
├── pubspec.yaml                  # Flutter bağımlılıkları
└── README.md                     # Frontend dokümantasyonu
```

---

## 🗄️ DB Klasör Yapısı (MySQL)

```
DB/
├── migrations/                   # Alembic migration dosyaları
│   └── .gitkeep
│
├── scripts/                      # SQL script'leri
│   ├── init_database.sql        # Veritabanı başlangıç script'i
│   ├── seed_data.sql            # Örnek veri
│   └── schema.sql               # Tablo yapıları
│
└── backups/                      # Veritabanı yedekleri
    └── .gitkeep
```

---

## 🗂️ Veritabanı Tabloları (Planlanmış)

### 1. **users** - Kullanıcı bilgileri
- id, username, email, password_hash, iq_score, created_at, updated_at

### 2. **levels** - Seviye bilgileri
- id, level_number, difficulty, required_iq, total_questions, is_active

### 3. **questions** - Sorular
- id, level_id, question_text, option_a, option_b, option_c, option_d, correct_answer, difficulty

### 4. **user_levels** - Kullanıcı seviye ilerlemeleri
- id, user_id, level_id, is_completed, score, completed_at

### 5. **game_sessions** - Oyun oturumları
- id, user_id, game_mode, score, iq_earned, started_at, completed_at

### 6. **leaderboard** - Lider tablosu
- id, user_id, total_iq, rank, last_updated

### 7. **shop_items** - Mağaza ürünleri
- id, item_name, description, price, item_type

### 8. **user_purchases** - Kullanıcı satın alımları
- id, user_id, shop_item_id, purchased_at

### 9. **tournaments** - Turnuvalar
- id, name, start_date, end_date, prize, status

### 10. **tournament_participants** - Turnuva katılımcıları
- id, tournament_id, user_id, score, rank

---

## 🚀 Özellikler ve İlgili Klasörler

### ✅ Login/Register Sistemi
- **Backend**: `app/api/endpoints/auth.py`, `app/services/auth_service.py`
- **Frontend**: `lib/screens/auth/`, `lib/services/auth/`

### ✅ Seviye Sistemi (100 Seviye)
- **Backend**: `app/api/endpoints/levels.py`, `app/services/level_service.py`
- **Frontend**: `lib/screens/levels/`

### ✅ Soru Çözme ve Oyun Modu
- **Backend**: `app/api/endpoints/game.py`, `app/services/game_service.py`
- **Frontend**: `lib/screens/game/`, `lib/widgets/game/`

### ✅ IQ Sistemi
- **Backend**: `app/services/iq_calculator.py`
- **Database**: `users.iq_score`, `game_sessions.iq_earned`

### ✅ Lider Tablosu
- **Backend**: `app/api/endpoints/leaderboard.py`, `app/services/leaderboard_service.py`
- **Frontend**: `lib/screens/leaderboard/`

### ✅ Robota Karşı Oynama
- **Backend**: `app/api/endpoints/bot.py`, `app/services/bot_service.py`
- **Frontend**: `lib/screens/game/game_mode_screen.dart`

### ✅ Turnuva Sistemi
- **Backend**: `app/api/endpoints/tournament.py`
- **Frontend**: `lib/screens/tournament/`

### ✅ Mağaza
- **Backend**: `app/api/endpoints/shop.py`, `app/services/shop_service.py`
- **Frontend**: `lib/screens/shop/`

### ✅ Profil ve Ayarlar
- **Backend**: `app/api/endpoints/users.py`
- **Frontend**: `lib/screens/profile/`, `lib/screens/settings/`

---

## 📝 Geliştirme Sırası (Önerilen)

1. **Veritabanı Kurulumu** → MySQL schema oluşturma
2. **Backend Auth Sistemi** → Login/Register API'leri
3. **Frontend Auth Ekranları** → Login/Register UI
4. **Seviye Sistemi Backend** → Level ve Question CRUD
5. **Oyun Motoru** → Soru getirme, cevap kontrol, IQ hesaplama
6. **Frontend Oyun Ekranları** → Question screen, game flow
7. **Lider Tablosu** → Backend + Frontend
8. **Bot Sistemi** → AI mantığı
9. **Turnuva Sistemi**
10. **Mağaza Sistemi**

---

## 🛠️ Kullanılacak Teknolojiler

### Backend
- **FastAPI** - Modern, hızlı Python web framework
- **SQLAlchemy** - ORM
- **Alembic** - Veritabanı migration
- **JWT** - Authentication
- **bcrypt** - Password hashing
- **MySQL Connector** - Veritabanı bağlantısı

### Frontend
- **Flutter** - Cross-platform mobil uygulama
- **Provider/Bloc** - State management
- **HTTP/Dio** - API istekleri
- **Shared Preferences** - Lokal veri saklama

### Database
- **MySQL** - İlişkisel veritabanı

---

## 📞 İletişim ve Notlar

Proje dosya yapısı hazır! Artık kodlamaya başlayabilirsiniz. 

**Sıradaki Adım:** Backend'de veritabanı modelleri ve API endpoint'lerini oluşturmak.

**İyi Kodlamalar! 🎉**

