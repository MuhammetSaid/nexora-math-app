"""
Level (Seviye) Tablosu
"""
from sqlalchemy import Column, Integer, String, Boolean, JSON, DateTime, func
from app.database import Base


class Level(Base):
    """
    Seviye tablosu
    Oyun seviyelerini ve özelliklerini tutar
    """
    __tablename__ = "levels"

    # Primary Key
    id = Column(Integer, primary_key=True, index=True, autoincrement=True, comment="Otomatik artan ID")
    
    # Seviye Kimliği
    level_id = Column(String(255), unique=True, nullable=False, index=True, comment="Unique level ID (örn: lvl_001, lvl_002)")
    level_no = Column(Integer, nullable=False, index=True, comment="Seviye numarası")
    
    # Zorluk ve Mod
    difficulty = Column(Integer, nullable=False, comment="Zorluk seviyesi (1: Kolay, 2: Orta, 3: Zor, vb.)")
    level_mode = Column(String(100), nullable=False, comment="Seviye modu (classic, time_trial, challenge, vb.)")
    
    # Cevap Değeri
    answer_value = Column(Integer, nullable=False, comment="Doğru cevap değeri")
    
    # Durum
    is_active = Column(Boolean, default=True, nullable=False, comment="Seviye aktif mi? (True/False)")
    
    # İpuçları (Çoklu dil desteği - JSON)
    hint1 = Column(
        JSON, 
        nullable=True, 
        comment='Birinci ipucu - Çoklu dil: {"tr": "İpucu", "en": "Hint", "de": "Hinweis"}'
    )
    hint2 = Column(
        JSON, 
        nullable=True, 
        comment='İkinci ipucu - Çoklu dil: {"tr": "İpucu", "en": "Hint", "de": "Hinweis"}'
    )
    
    # Çözüm Açıklaması (Çoklu dil desteği - JSON)
    solution_explanation = Column(
        JSON, 
        nullable=True, 
        comment='Çözüm açıklaması - Çoklu dil: {"tr": "Açıklama", "en": "Explanation", "de": "Erklärung"}'
    )
    
    # Görsel
    image_path = Column(String(500), nullable=True, comment="Seviye görseli yolu")
    
    # Zaman Damgaları
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False, comment="Oluşturulma tarihi")
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False, comment="Güncellenme tarihi")
    
    def __repr__(self):
        return f"<Level(id={self.id}, level_id='{self.level_id}', level_no={self.level_no}, difficulty={self.difficulty})>"
    
    def get_hint1(self, locale: str = 'tr') -> str:
        """Kullanıcının diline göre hint1 getir"""
        if self.hint1 and isinstance(self.hint1, dict):
            return self.hint1.get(locale, self.hint1.get('tr', ''))
        return ''
    
    def get_hint2(self, locale: str = 'tr') -> str:
        """Kullanıcının diline göre hint2 getir"""
        if self.hint2 and isinstance(self.hint2, dict):
            return self.hint2.get(locale, self.hint2.get('tr', ''))
        return ''
    
    def get_solution(self, locale: str = 'tr') -> str:
        """Kullanıcının diline göre çözüm açıklaması getir"""
        if self.solution_explanation and isinstance(self.solution_explanation, dict):
            return self.solution_explanation.get(locale, self.solution_explanation.get('tr', ''))
        return ''

