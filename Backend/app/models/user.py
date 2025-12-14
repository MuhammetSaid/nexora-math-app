from __future__ import annotations

from sqlalchemy import Column, DateTime, Integer, String, func

from app.db.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True)
    username = Column(String(100), nullable=False, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    password = Column(String(255), nullable=False)

    is_guest = Column(Integer, default=0, nullable=False)

    locale = Column(String(10), default="tr", nullable=True)
    country = Column(String(5), default="TR", nullable=True)

    xp = Column(Integer, default=0, nullable=False)
    xp_dd = Column(Integer, default=0, nullable=False)

    diamond = Column(Integer, default=0, nullable=False)
    hints = Column(Integer, default=3, nullable=False)

    level = Column(Integer, default=1, nullable=False)

    status = Column(String(50), default="active", nullable=False)

    avatar_path = Column(String(500), nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )
    last_login_at = Column(DateTime(timezone=True), nullable=True)
    deleted_at = Column(DateTime(timezone=True), nullable=True)

    def __repr__(self) -> str:
        return f"<User(id={self.id}, user_id='{self.user_id}', username='{self.username}', email='{self.email}')>"
