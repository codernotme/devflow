from fastapi import APIRouter, HTTPException, Depends
from typing import List
from database import get_database
from models import TaskCreate, TaskUpdate, TaskResponse
from datetime import datetime, timezone
from bson import ObjectId

router = APIRouter(prefix="/tasks", tags=["Tasks"])

def format_task(doc) -> dict:
    doc["id"] = str(doc["_id"])
    return doc

@router.get("/", response_model=List[TaskResponse])
async def get_tasks(db=Depends(get_database)):
    tasks = await db.tasks.find().to_list(1000)
    return [format_task(t) for t in tasks]

@router.post("/", response_model=TaskResponse)
async def create_task(task: TaskCreate, db=Depends(get_database)):
    doc = task.model_dump()
    doc["created_at"] = datetime.now(timezone.utc)
    # Generate IDs for initial subtasks if they don't have them
    for st in doc.get("subtasks", []):
        if not st.get("id"):
            st["id"] = str(ObjectId())
            
    result = await db.tasks.insert_one(doc)
    doc["_id"] = result.inserted_id
    return format_task(doc)

@router.put("/{id}", response_model=TaskResponse)
async def update_task(id: str, task_update: TaskUpdate, db=Depends(get_database)):
    update_data = {k: v for k, v in task_update.model_dump().items() if v is not None}
    if not update_data:
        raise HTTPException(status_code=400, detail="No fields provided for update")
    
    result = await db.tasks.find_one_and_update(
        {"_id": ObjectId(id)},
        {"$set": update_data},
        return_document=True
    )
    if not result:
        raise HTTPException(status_code=404, detail="Task not found")
    return format_task(result)

@router.delete("/{id}")
async def delete_task(id: str, db=Depends(get_database)):
    result = await db.tasks.delete_one({"_id": ObjectId(id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Task not found")
    return {"status": "success"}
