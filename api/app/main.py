from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

# Create FastAPI app
app = FastAPI(title="Fintech Data API")

# Database connection
DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Dependency for database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Root endpoint
@app.get("/")
def read_root():
    return {"message": "Welcome to Fintech Data API"}

# Health check endpoint
@app.get("/health")
def health_check():
    return {"status": "healthy"}

# Include routers for different data types
# This is a placeholder - you'll create these in step 6
# from app.routers import stocks, financials, economics
# app.include_router(stocks.router)
# app.include_router(financials.router)
# app.include_router(economics.router)