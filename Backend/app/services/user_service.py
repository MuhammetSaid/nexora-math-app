"""
User service helpers
"""
from typing import Optional
from uuid import uuid4
import hashlib
import secrets
from sqlalchemy.orm import Session

from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate

def get_password_hash(password: str) -> str:
    # Lightweight salted hash without external deps
    salt = secrets.token_hex(16)
    digest = hashlib.sha256(f"{salt}{password}".encode("utf-8")).hexdigest()
    return f"{salt}${digest}"


def get_user_by_user_id(db: Session, user_id: str) -> Optional[User]:
    return (
        db.query(User)
        .filter(User.user_id == user_id, User.deleted_at.is_(None))
        .first()
    )


def get_user_by_email(db: Session, email: str) -> Optional[User]:
    return (
        db.query(User)
        .filter(User.email == email, User.deleted_at.is_(None))
        .first()
    )


def create_user(db: Session, payload: UserCreate) -> User:
    user = User(
        user_id=str(uuid4()),
        username=payload.username,
        email=payload.email,
        password=get_password_hash(payload.password),
        locale=payload.locale or "tr",
        country=payload.country or "TR",
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


def update_user(db: Session, db_user: User, payload: UserUpdate) -> User:
    if payload.username is not None:
        db_user.username = payload.username
    if payload.email is not None:
        db_user.email = payload.email
    if payload.password:
        db_user.password = get_password_hash(payload.password)
    if payload.locale is not None:
        db_user.locale = payload.locale
    if payload.country is not None:
        db_user.country = payload.country

    db.commit()
    db.refresh(db_user)
    return db_user
