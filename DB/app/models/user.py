"""
User (Kullanıcı) Tablosu
"""
from sqlalchemy import Column, Integer, String, DateTime, func
from app.database import Base


class User(Base):
    """
    Kullanıcı tablosu
    """
    __tablename__ = "users"

    # Primary Key
    id = Column(Integer, primary_key=True, index=True, autoincrement=True, comment="Otomatik artan ID")
    
    # Kullanıcı Kimliği
    user_id = Column(String(255), unique=True, nullable=False, index=True, comment="Random unique user ID")
    username = Column(String(100), nullable=False, index=True, comment="Kullanıcı adı")
    email = Column(String(255), unique=True, nullable=False, index=True, comment="E-posta adresi")
    password = Column(String(255), nullable=False, comment="Hash'lenmiş şifre")
    
    # Misafir Kontrolü
    is_guest = Column(Integer, default=0, nullable=False, comment="0: Normal kullanıcı, 1: Misafir")
    
    # Lokalizasyon
    locale = Column(String(10), default="tr", nullable=True, comment="Dil kodu (tr, en, vb.)")
    country = Column(String(5), default="TR", nullable=True, comment="Ülke kodu (TR, US, vb.)")
    
    # Seviye Sistemi
    xp = Column(Integer, default=0, nullable=False, comment="Kullanıcının toplam XP seviyesi")
    xp_dd = Column(Integer, default=0, nullable=False, comment="XP kesir/detay - her 100'de xp +1")
    
    # Para Birimleri
    diamond = Column(Integer, default=0, nullable=False, comment="Elmas bakiyesi")
    hints = Column(Integer, default=3, nullable=False, comment="İpucu (hint) bakiyesi")
    
    # Oyun İlerlemesi
    level = Column(Integer, default=1, nullable=False, comment="Kullanıcının ulaştığı seviye numarası")
    
    # Durum
    status = Column(String(50), default="active", nullable=False, comment="Hesap durumu: active, banned, suspended")
    
    # Avatar
    avatar_path = Column(String(500), nullable=True, comment="Kullanıcı profil fotoğrafı yolu")
    
    # Zaman Damgaları
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False, comment="Hesap oluşturulma tarihi")
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False, comment="Son güncellenme tarihi")
    last_login_at = Column(DateTime(timezone=True), nullable=True, comment="Son giriş tarihi")
    deleted_at = Column(DateTime(timezone=True), nullable=True, comment="Soft delete - silinme tarihi")
    
    def __repr__(self):
        return f"<User(id={self.id}, user_id='{self.user_id}', username='{self.username}', email='{self.email}')>"
