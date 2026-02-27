from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime, timezone
from enum import Enum

class Priority(str, Enum):
    critical = "critical"
    high = "high"
    medium = "medium"
    low = "low"

class TaskStatus(str, Enum):
    todo = "todo"
    inProgress = "inProgress"
    done = "done"
    blocked = "blocked"

class ProjectStatus(str, Enum):
    active = "active"
    done = "done"

# Project Models
class ProjectBase(BaseModel):
    name: str
    description: Optional[str] = None
    priority: Priority = Priority.medium
    status: ProjectStatus = ProjectStatus.active
    deadline: Optional[datetime] = None

class ProjectCreate(ProjectBase):
    pass

class ProjectUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    priority: Optional[Priority] = None
    status: Optional[ProjectStatus] = None
    deadline: Optional[datetime] = None

class ProjectResponse(ProjectBase):
    id: str
    created_at: datetime

# SubTask
class SubTask(BaseModel):
    id: str
    title: str
    is_done: bool = False
    priority: Priority = Priority.medium

# Task Models
class TaskBase(BaseModel):
    project_id: Optional[str] = None
    title: str
    description: Optional[str] = None
    priority: Priority = Priority.medium
    status: TaskStatus = TaskStatus.todo
    deadline: Optional[datetime] = None
    subtasks: List[SubTask] = []

class TaskCreate(TaskBase):
    pass

class TaskUpdate(BaseModel):
    project_id: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    priority: Optional[Priority] = None
    status: Optional[TaskStatus] = None
    deadline: Optional[datetime] = None
    subtasks: Optional[List[SubTask]] = None

class TaskResponse(TaskBase):
    id: str
    created_at: datetime

# Focus Session Models
class FocusSessionBase(BaseModel):
    task_id: Optional[str] = None
    duration_seconds: int
    started_at: datetime
    ended_at: datetime
    session_type: str = "work" # 'work' or 'break'

class FocusSessionCreate(FocusSessionBase):
    pass

class FocusSessionResponse(FocusSessionBase):
    id: str

# Standup Models
class StandupBase(BaseModel):
    date: str # YYYY-MM-DD
    yesterday_notes: str
    today_notes: str
    blockers: str

class StandupCreate(StandupBase):
    pass

class StandupUpdate(BaseModel):
    yesterday_notes: Optional[str] = None
    today_notes: Optional[str] = None
    blockers: Optional[str] = None

class StandupResponse(StandupBase):
    id: str
    created_at: datetime
