from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

# MySQL database URL
def get_url():
    """ 環境変数が設定してあれば、そっちを使う。なければローカル """
    user = os.getenv("MYSQL_USER", "myuser")
    password = os.getenv("MYSQL_PASSWORD", "mypassword")
    server = os.getenv("MYSQL_SERVER", "db:3306")
    db = os.getenv("MYSQL_DB", "mydatabase")
    return f"mysql+mysqlconnector://{user}:{password}@{server}/{db}"

# Create a SQLAlchemy engine with the MySQL URL and some additional arguments
SQLALCHEMY_DATABASE_URL = get_url()
engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True)

# Create a SessionLocal class for creating sessions with the database
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create a declarative base class for defining database models
Base = declarative_base()