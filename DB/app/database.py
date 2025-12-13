from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

DATABASE_URL = "mysql+pymysql://root:root@localhost:8889/nexora_math"

engine = create_engine(
    DATABASE_URL,
    echo=True  # SQL sorgularını terminalde gösterir
)

SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False
)

Base = declarative_base()
