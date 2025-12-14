"""
Level model
"""
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text
from datetime import datetime
from app.db.database import Base


class Level(Base):
    __tablename__ = "levels"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    level_id = Column(String(50), unique=True, nullable=False)  # lvl_001, lvl_002
    level_no = Column(Integer, nullable=False, index=True)
    difficulty = Column(Integer)  # 1: Kolay, 2: Orta, 3: Zor
    level_mode = Column(String(50), nullable=False, index=True)  # classic, time_trial, challenge
    answer_value = Column(String(100))
    is_active = Column(Boolean, default=True, index=True)
    hint1 = Column(Text)  # JSON: {"tr": "İpucu", "en": "Hint"}
    hint2 = Column(Text)  # JSON: {"tr": "İpucu", "en": "Hint"}
    solution_explanation = Column(Text)  # JSON: {"tr": "Açıklama", "en": "Explanation"}
    image_path = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
