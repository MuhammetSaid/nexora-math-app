from __future__ import annotations

import secrets
import string
from datetime import datetime, timedelta
from typing import Any, Dict, Optional

from jose import jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.core.config import settings
from app.models.user import User

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def verify_google_token(id_token: str) -> Dict[str, Any]:
    """
    Placeholder verification. In production validate the JWT with Google's public keys.
    For now we accept the token as-is and return a minimal payload.
    """
    return {
        "sub": id_token[:24],  # deterministic enough for local dev
        "email": None,
        "name": None,
        "picture": None,
    }


def _generate_random_password(length: int = 32) -> str:
    alphabet = string.ascii_letters + string.digits
    return "".join(secrets.choice(alphabet) for _ in range(length))


def _hash_password(password: str) -> str:
    return pwd_context.hash(password)


def _generate_user_id(prefix: str = "google") -> str:
    return f"{prefix}-{secrets.token_hex(8)}"


def create_access_token(data: dict, expires_minutes: Optional[int] = None) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(
        minutes=expires_minutes or settings.access_token_expire_minutes
    )
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, settings.secret_key, algorithm=settings.algorithm)


def get_or_create_google_user(
    db: Session, *, email: str, name: str | None, avatar: str | None
) -> User:
    user = db.query(User).filter(User.email == email).first()
    if user:
        user.last_login_at = datetime.utcnow()
        if name and user.username != name:
            user.username = name
        if avatar and user.avatar_path != avatar:
            user.avatar_path = avatar
        db.commit()
        db.refresh(user)
        return user

    user = User(
        user_id=_generate_user_id(),
        username=name or email.split("@")[0],
        email=email,
        password=_hash_password(_generate_random_password()),
        is_guest=0,
        avatar_path=avatar,
        last_login_at=datetime.utcnow(),
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user
