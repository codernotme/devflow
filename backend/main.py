from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import projects, tasks, sessions, standups

app = FastAPI(title="DevFlow API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(projects.router)
app.include_router(tasks.router)
app.include_router(sessions.router)
app.include_router(standups.router)

@app.get("/")
def read_root():
    return {"status": "ok", "app": "DevFlow API Backend"}
