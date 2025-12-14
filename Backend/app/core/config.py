"""
Uygulama yapılandırma ayarları
"""
from pydantic_settings import BaseSettings
from dotenv import load_dotenv
import os

load_dotenv()

# Environment variable'lardan oku
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")
DB_NAME = os.getenv("DB_NAME", "nexora_math")


class Settings(BaseSettings):
    """Uygulama ayarları"""
    
    DATABASE_URL: str = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    DEBUG: bool = True


settings = Settings()

if __name__ == "__main__":
    print(settings.DATABASE_URL)
