from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# MySQL database URL
SQLALCHEMY_DATABASE_URL = "mysql+mysqlconnector://myuser:mypassword@db:3306/mydatabase"

# Create a SQLAlchemy engine with the MySQL URL and some additional arguments
engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True)

# Create a SessionLocal class for creating sessions with the database
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create a declarative base class for defining database models
Base = declarative_base()