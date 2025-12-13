"""
AdReward (Reklam Ödülleri) Tablosu
"""
from sqlalchemy import Column, Integer, String, DateTime, func
from app.database import Base


class AdReward(Base):
    """
    Reklam ödülleri tablosu
    Kullanıcıların reklam izleyerek kazandıkları ödülleri tutar
    """
    __tablename__ = "ad_rewards"

    # Primary Key
    id = Column(Integer, primary_key=True, index=True, autoincrement=True, comment="Otomatik artan ID")
    
    # Kullanıcı Referansı (Foreign Key DEĞİL)
    user_id = Column(String(255), nullable=False, index=True, comment="Kullanıcı ID (users.user_id referansı)")
    
    # Ödül Bilgileri
    rewards_type = Column(String(100), nullable=False, comment="Ödül tipi (diamond, coin, hint, xp, vb.)")
    rewards_values = Column(Integer, nullable=False, comment="Ödül miktarı")
    
    # Zaman Damgası
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False, comment="Ödül kazanılma tarihi")
    
    def __repr__(self):
        return f"<AdReward(id={self.id}, user_id='{self.user_id}', type='{self.rewards_type}', value={self.rewards_values})>"

