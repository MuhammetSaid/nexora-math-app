"""
Bot endpoints - Bot ile oyun için API
"""
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
from app.services.bot_service import bot_service

router = APIRouter()


class BotSolveRequest(BaseModel):
    """Bot çözüm isteği"""
    level_id: str
    difficulty: int
    hint1: str
    hint2: str
    solution_explanation: str
    answer_value: str


class BotSolveResponse(BaseModel):
    """Bot çözüm yanıtı"""
    answer: str
    solve_time: float
    success: bool
    method: str
    difficulty: int
    thinking_messages: list[str] = []
    solved_message: str = ""


@router.post("/bot/solve", response_model=BotSolveResponse)
async def solve_question(request: BotSolveRequest):
    """
    Bot'un soruyu çözmesi için endpoint
    
    Seviyeye göre zorluk ayarlı çözüm süresi döndürür:
    - Seviye 1 (Başlangıç): 8-12 saniye (kolay)
    - Seviye 2 (Amatör): 6-10 saniye
    - Seviye 3 (Orta): 5-8 saniye
    - Seviye 4 (İleri): 4-7 saniye
    - Seviye 5 (Uzman): 3-6 saniye
    """
    try:
        result = await bot_service.solve_question(
            level_id=request.level_id,
            difficulty=request.difficulty,
            hint1=request.hint1,
            hint2=request.hint2,
            solution_explanation=request.solution_explanation,
            answer_value=request.answer_value
        )
        
        return BotSolveResponse(**result)
        
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Bot çözüm hatası: {str(e)}"
        )
