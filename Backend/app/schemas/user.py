from __future__ import annotations

from datetime import datetime

from pydantic import BaseModel, ConfigDict, EmailStr


class UserResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int | None = None
    user_id: str
    username: str
    email: EmailStr
    is_guest: bool = False
    locale: str | None = None
    country: str | None = None
    level: int = 1
    xp: int = 0
    xp_dd: int = 0
    diamond: int = 0
    hints: int = 0
    status: str | None = None
    avatar_path: str | None = None
    created_at: datetime | None = None
    last_login_at: datetime | None = None
