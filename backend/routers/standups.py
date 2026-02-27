from fastapi import APIRouter, HTTPException, Depends
from typing import List
from database import get_database
from models import StandupCreate, StandupUpdate, StandupResponse
from datetime import datetime, timezone
from bson import ObjectId

router = APIRouter(prefix="/standups", tags=["Standups"])

def format_standup(doc) -> dict:
    doc["id"] = str(doc["_id"])
    return doc

@router.get("/", response_model=List[StandupResponse])
async def get_standups(db=Depends(get_database)):
    standups = await db.standups.find().sort("date", -1).to_list(1000)
    return [format_standup(s) for s in standups]

@router.post("/", response_model=StandupResponse)
async def create_standup(standup: StandupCreate, db=Depends(get_database)):
    # Check if a standup for this date already exists
    existing = await db.standups.find_one({"date": standup.date})
    if existing:
        raise HTTPException(status_code=400, detail="Standup already exists for this date")

    doc = standup.model_dump()
    doc["created_at"] = datetime.now(timezone.utc)
    result = await db.standups.insert_one(doc)
    doc["_id"] = result.inserted_id
    return format_standup(doc)

@router.put("/{id}", response_model=StandupResponse)
async def update_standup(id: str, standup_update: StandupUpdate, db=Depends(get_database)):
    update_data = {k: v for k, v in standup_update.model_dump().items() if v is not None}
    if not update_data:
        raise HTTPException(status_code=400, detail="No fields provided for update")
    
    result = await db.standups.find_one_and_update(
        {"_id": ObjectId(id)},
        {"$set": update_data},
        return_document=True
    )
    if not result:
        raise HTTPException(status_code=404, detail="Standup not found")
    return format_standup(result)

@router.delete("/{id}")
async def delete_standup(id: str, db=Depends(get_database)):
    result = await db.standups.delete_one({"_id": ObjectId(id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Standup not found")
    return {"status": "success"}
