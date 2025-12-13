"""
Rating (Değerlendirme) Tablosu
"""
from sqlalchemy import Column, Integer, String, DateTime, func, CheckConstraint
from app.database import Base


class Rating(Base):
    """
    Değerlendirme tablosu
    Kullanıcıların seviyelere verdikleri yıldız puanları
    """
    __tablename__ = "rating"

    # Primary Key
    id = Column(Integer, primary_key=True, index=True, autoincrement=True, comment="Otomatik artan ID")
    
    # Referans ID'ler (Foreign Key DEĞİL - sadece referans)
    user_id = Column(String(255), nullable=False, index=True, comment="Kullanıcı ID (users.user_id referansı)")
    level_id = Column(Integer, nullable=False, index=True, comment="Seviye ID (levels.id referansı)")
    
    # Yıldız Puanı (1-3 arası)
    stars = Column(
        Integer, 
        nullable=False, 
        comment="Yıldız sayısı: 1, 2 veya 3"
    )
    
    # Zaman Damgaları
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False, comment="Oluşturulma tarihi")
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False, comment="Güncellenme tarihi")
    
    # Check constraint: stars 1-3 arası olmalı
    __table_args__ = (
        CheckConstraint('stars >= 1 AND stars <= 3', name='check_stars_range'),
    )
    
    def __repr__(self):
        return f"<Rating(id={self.id}, user_id='{self.user_id}', level_id={self.level_id}, stars={self.stars})>"

