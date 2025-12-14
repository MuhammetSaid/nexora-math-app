"""
User service helpers
"""
from datetime import datetime, timezone
from typing import Optional
from uuid import uuid4
import hashlib
import hmac
import secrets
from sqlalchemy.orm import Session

from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate

def get_password_hash(password: str) -> str:
    # Lightweight salted hash without external deps
    salt = secrets.token_hex(16)
    digest = hashlib.sha256(f"{salt}{password}".encode("utf-8")).hexdigest()
    return f"{salt}${digest}"


def verify_password(password: str, stored_hash: str) -> bool:
    """
    Verify a plaintext password against a stored salted hash.
    """
    try:
        salt, digest = stored_hash.split("$", 1)
    except ValueError:
        return False
    candidate = hashlib.sha256(f"{salt}{password}".encode("utf-8")).hexdigest()
    return hmac.compare_digest(candidate, digest)


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


def authenticate_user(db: Session, email: str, password: str) -> Optional[User]:
    user = get_user_by_email(db, email)
    if not user:
        return None

    if not verify_password(password, user.password):
        return None

    return user


def touch_last_login(db: Session, user: User) -> User:
    user.last_login_at = datetime.now(timezone.utc)
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
    if payload.level is not None:
        db_user.level = payload.level

    db.commit()
    db.refresh(db_user)
    return db_user
