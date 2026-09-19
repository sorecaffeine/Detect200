import tomllib

from fastapi import FastAPI
from contextlib import asynccontextmanager
from checker import chk_services
from database import insert_chk,init_db



@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield


app = FastAPI(lifespan=lifespan)

def load_services():
    with open("services.toml", "rb") as file:
        config = tomllib.load(file)

    return config["services"]


@app.get("/status")
def get_status():
    services = load_services()
    results = []

    for service in services:
        result = chk_services(service)

        insert_chk(result)

        results.append(result)

    return results
