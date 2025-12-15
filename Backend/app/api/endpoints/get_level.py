"""
Level endpoints
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models.level import Level
from app.schemas.level import LevelResponse
from typing import List

router = APIRouter()


@router.get("/levels", response_model=List[LevelResponse])
async def list_levels(db: Session = Depends(get_db)):
    """
    Return all active levels for the classic mode ordered by level number.
    """
    levels = (
        db.query(Level)
        .filter(Level.is_active == 1, Level.level_mode == "level")
        .order_by(Level.level_no.asc())
        .all()
    )
    return levels


@router.get("/levels/{level_number}", response_model=LevelResponse)
async def get_level(level_number: int, db: Session = Depends(get_db)):
    """
    Level numarasına göre aktif level'ı getirir
    
    Şartlar:
    - level_no = level_number
    - is_active = 1
    - level_mode = "level"
    """
    level = db.query(Level).filter(
        Level.level_no == level_number,
        Level.is_active == 1,
        Level.level_mode == "level"
    ).first()
    
    if not level:
        raise HTTPException(
            status_code=404,
            detail=f"Level {level_number} bulunamadı veya aktif değil"
        )
    
    return level
