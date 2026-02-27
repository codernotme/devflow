from fastapi import APIRouter, HTTPException, Depends
from typing import List
from database import get_database
from models import FocusSessionCreate, FocusSessionResponse
from datetime import datetime, timezone
from bson import ObjectId

router = APIRouter(prefix="/sessions", tags=["Focus Sessions"])

def format_session(doc) -> dict:
    doc["id"] = str(doc["_id"])
    return doc

@router.get("/", response_model=List[FocusSessionResponse])
async def get_sessions(db=Depends(get_database)):
    sessions = await db.focus_sessions.find().sort("started_at", -1).to_list(1000)
    return [format_session(s) for s in sessions]

@router.post("/", response_model=FocusSessionResponse)
async def create_session(session: FocusSessionCreate, db=Depends(get_database)):
    doc = session.model_dump()
    result = await db.focus_sessions.insert_one(doc)
    doc["_id"] = result.inserted_id
    return format_session(doc)
