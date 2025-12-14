"""
Level schemas (Pydantic models)
"""
from pydantic import BaseModel
from typing import Optional, Union
from datetime import datetime


class LevelBase(BaseModel):
    """Base level schema"""
    level_id: str
    level_no: int
    difficulty: Optional[int] = None
    level_mode: str
    answer_value: Optional[Union[str, int]] = None  # String veya integer olabilir
    hint1: Optional[str] = None
    hint2: Optional[str] = None
    solution_explanation: Optional[str] = None
    image_path: Optional[str] = None


class LevelResponse(LevelBase):
    """Level response schema"""
    id: int
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
