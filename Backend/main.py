"""
Nexora Math API - FastAPI Backend
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.endpoints import get_level

# FastAPI app oluştur
app = FastAPI(
    title="Nexora Math API",
    description="Nexora Math uygulaması için backend API",
    version="1.0.0"
)

# CORS ayarları
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Geliştirme için tüm originler, production'da değiştirin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Router'ları ekle
app.include_router(
    get_level.router,
    prefix="/api/v1",
    tags=["Levels"]
)


@app.get("/")
async def root():
    """API ana endpoint"""
    return {
        "message": "Nexora Math API",
        "version": "1.0.0",
        "status": "running"
    }


@app.get("/health")
async def health_check():
    """Sağlık kontrolü endpoint"""
    return {"status": "healthy"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True  # Geliştirme için otomatik reload
    )