from __future__ import annotations

from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr, Field

from .user import UserResponse


class GoogleSignInRequest(BaseModel):
    id_token: str = Field(..., alias="idToken", description="Google ID token")
    email: Optional[EmailStr] = None
    name: Optional[str] = Field(None, description="Display name from Google")
    avatar: Optional[str] = Field(None, description="Avatar URL from Google")


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    refresh_token: str | None = None
    issued_at: datetime
    user: UserResponse
