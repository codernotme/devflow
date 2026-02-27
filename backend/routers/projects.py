from fastapi import APIRouter, HTTPException, Depends
from typing import List
from database import get_database
from models import ProjectCreate, ProjectUpdate, ProjectResponse
from datetime import datetime, timezone
from bson import ObjectId

router = APIRouter(prefix="/projects", tags=["Projects"])

def format_project(doc) -> dict:
    doc["id"] = str(doc["_id"])
    return doc

@router.get("/", response_model=List[ProjectResponse])
async def get_projects(db=Depends(get_database)):
    projects = await db.projects.find().to_list(1000)
    return [format_project(p) for p in projects]

@router.post("/", response_model=ProjectResponse)
async def create_project(project: ProjectCreate, db=Depends(get_database)):
    doc = project.model_dump()
    doc["created_at"] = datetime.now(timezone.utc)
    result = await db.projects.insert_one(doc)
    doc["_id"] = result.inserted_id
    return format_project(doc)

@router.put("/{id}", response_model=ProjectResponse)
async def update_project(id: str, project_update: ProjectUpdate, db=Depends(get_database)):
    update_data = {k: v for k, v in project_update.model_dump().items() if v is not None}
    if not update_data:
        raise HTTPException(status_code=400, detail="No fields provided for update")
    
    result = await db.projects.find_one_and_update(
        {"_id": ObjectId(id)},
        {"$set": update_data},
        return_document=True
    )
    if not result:
        raise HTTPException(status_code=404, detail="Project not found")
    return format_project(result)

@router.delete("/{id}")
async def delete_project(id: str, db=Depends(get_database)):
    result = await db.projects.delete_one({"_id": ObjectId(id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Project not found")
    # Clean up associated tasks
    await db.tasks.delete_many({"project_id": id})
    return {"status": "success"}
