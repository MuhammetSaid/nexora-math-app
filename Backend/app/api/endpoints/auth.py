from __future__ import annotations

from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.schemas.auth import GoogleSignInRequest, TokenResponse
from app.schemas.user import UserResponse
from app.services.auth_service import (
    create_access_token,
    get_or_create_google_user,
    verify_google_token,
)

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/google", response_model=TokenResponse)
def sign_in_with_google(payload: GoogleSignInRequest, db: Session = Depends(get_db)):
    token_info = verify_google_token(payload.id_token)
    email = payload.email or token_info.get("email")
    name = payload.name or token_info.get("name")
    avatar = payload.avatar or token_info.get("picture")

    if not email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email not provided in Google token.",
        )

    user = get_or_create_google_user(db, email=email, name=name, avatar=avatar)
    access_token = create_access_token({"sub": user.user_id})
    return TokenResponse(
        access_token=access_token,
        issued_at=datetime.utcnow(),
        user=UserResponse.model_validate(user),
    )
