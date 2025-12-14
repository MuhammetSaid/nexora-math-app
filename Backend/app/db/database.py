"""
Veritabanı bağlantı yönetimi
"""
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import sys
import os

# Backend klasörünü path'e ekle
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

from app.core.config import settings

# SQLAlchemy engine oluştur
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,  # Bağlantı kontrolü
    pool_size=10,  # Connection pool boyutu
    max_overflow=20,  # Maksimum overflow bağlantısı
    echo=settings.DEBUG  # SQL sorgularını logla
)

# Session factory
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

# Base class for models
Base = declarative_base()


def get_db():
    """
    Database session dependency
    FastAPI route'larında kullanılır
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

