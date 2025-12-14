"""
User schemas (Pydantic models)
"""
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr, field_validator


class UserBase(BaseModel):
    username: str
    email: EmailStr
    locale: Optional[str] = "tr"
    country: Optional[str] = "TR"

    @field_validator("username")
    @classmethod
    def validate_username(cls, value: str) -> str:
        if not value or not value.strip():
            raise ValueError("username is required")
        return value.strip()


class UserCreate(UserBase):
    password: str

    @field_validator("password")
    @classmethod
    def validate_password(cls, value: str) -> str:
        if not value or len(value) < 4:
            raise ValueError("password must be at least 4 characters")
        return value


class UserLogin(BaseModel):
    email: EmailStr
    password: str

    @field_validator("password")
    @classmethod
    def validate_password(cls, value: str) -> str:
        if not value:
            raise ValueError("password is required")
        return value


class UserUpdate(BaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None
    locale: Optional[str] = None
    country: Optional[str] = None
    level: Optional[int] = None


class UserResponse(BaseModel):
    id: int
    user_id: str
    username: str
    email: EmailStr
    locale: Optional[str]
    country: Optional[str]
    level: int
    xp: int
    xp_dd: int
    diamond: int
    hints: int
    avatar_path: Optional[str]
    status: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
