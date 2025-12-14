# 🗄️ Users Tablosu Migration Kılavuzu

## ✅ Hazırlanan Yapı

### 📁 Dosya Yapısı
```
DB/
├── alembic.ini              ✅ Yapılandırıldı
├── alembic/
│   ├── env.py              ✅ Base ve modeller import edildi
│   └── versions/           📁 Migration'lar buraya oluşacak
└── app/
    ├── database.py         ✅ SQLAlchemy bağlantısı
    └── models/
        ├── __init__.py     ✅ User export edildi
        └── user.py         ✅ Yeni tablo yapısı hazır
```

## 📊 Users Tablosu Yapısı

| Alan | Tip | Özellik | Açıklama |
|------|-----|---------|----------|
| `id` | INT | Primary Key, Auto Increment | Otomatik artan ID |
| `user_id` | VARCHAR(255) | Unique, Index | Random unique user ID |
| `username` | VARCHAR(100) | Index | Kullanıcı adı |
| `email` | VARCHAR(255) | Unique, Index | E-posta adresi |
| `password` | VARCHAR(255) | - | Hash'lenmiş şifre |
| `is_guest` | INT | Default: 0 | 0: Normal, 1: Misafir |
| `locale` | VARCHAR(10) | Default: 'tr' | Dil kodu (tr, en, vb.) |
| `country` | VARCHAR(5) | Default: 'TR' | Ülke kodu (TR, US, vb.) |
| `xp` | INT | Default: 0 | Toplam XP seviyesi |
| `xp_dd` | INT | Default: 0 | XP kesir - her 100'de xp +1 |
| `diamond` | INT | Default: 0 | Elmas bakiyesi |
| `hints` | INT | Default: 3 | İpucu bakiyesi |
| `level` | INT | Default: 1 | Kullanıcının seviye numarası |
| `status` | VARCHAR(50) | Default: 'active' | active, banned, suspended |
| `avatar_path` | VARCHAR(500) | Nullable | Profil fotoğrafı yolu |
| `created_at` | DATETIME | Auto (now) | Oluşturulma tarihi |
| `updated_at` | DATETIME | Auto (now, update) | Güncellenme tarihi |
| `last_login_at` | DATETIME | Nullable | Son giriş tarihi |
| `deleted_at` | DATETIME | Nullable | Soft delete tarihi |

## 🚀 Migration Oluşturma ve Uygulama

### ADIM 1: Migration Oluştur
```bash
cd DB
alembic revision --autogenerate -m "Create users table"
```

Bu komut `DB/alembic/versions/` klasöründe yeni bir migration dosyası oluşturacak.

### ADIM 2: Migration Dosyasını Kontrol Et
Oluşan dosyayı kontrol edin:
```bash
DB/alembic/versions/xxxx_create_users_table.py
```

### ADIM 3: Migration'ı Veritabanına Uygula
```bash
alembic upgrade head
```

Bu komut users tablosunu MySQL veritabanınızda oluşturacak.

## 🔍 Alembic Komutları

### Mevcut Durumu Kontrol Et
```bash
alembic current
```

### Migration Geçmişi
```bash
alembic history
```

### Bir Adım Geri Al
```bash
alembic downgrade -1
```

### Tümünü Geri Al
```bash
alembic downgrade base
```

### En Sona Getir
```bash
alembic upgrade head
```

## 📝 Veritabanı Bağlantı Bilgileri

`DB/alembic.ini` dosyasında:
```ini
sqlalchemy.url = mysql+pymysql://root:root@localhost:8889/nexora_math
```

## ✅ Migration Sonrası Test

### SQL ile Kontrol
```sql
USE nexora_math;

-- Tabloyu göster
SHOW TABLES;

-- Tablo yapısını göster
DESCRIBE users;

-- Test verisi ekle
INSERT INTO users (user_id, username, email, password, is_guest, xp, diamond, hints, level)
VALUES ('user_abc123', 'test_user', 'test@example.com', 'hashed_password', 0, 150, 50, 5, 2);

-- Verileri kontrol et
SELECT * FROM users;
```

## 🔄 Sonraki Adımlar

1. **Diğer tabloları ekleyin:**
   - `levels` - Seviyeler
   - `questions` - Sorular
   - `game_sessions` - Oyun oturumları
   - `achievements` - Başarımlar
   - vb...

2. **Her yeni model için:**
   - `DB/app/models/` altında yeni dosya oluştur
   - `DB/app/models/__init__.py`'ye ekle
   - Migration oluştur ve uygula

## 🛠️ Sorun Giderme

### Hata: "No module named 'app'"
```bash
# DB klasörüne __init__.py ekleyin
touch DB/__init__.py
touch DB/app/__init__.py
```

### Hata: "Target database is not up to date"
```bash
alembic stamp head
```

### Tabloyu Tamamen Sil ve Yeniden Oluştur
```sql
DROP TABLE users;
```
```bash
alembic upgrade head
```

## ✅ Başarıyla Tamamlandı!

Artık `users` tablonuz MySQL'de hazır! 🎉

