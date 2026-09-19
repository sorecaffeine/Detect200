import tomllib

from checker import chk_services
from database import get_connect, insert_chk

connection=get_connect()
print("Connected to Sqlite")
connection.close()


with open("services.toml","rb") as file:
    config=tomllib.load(file)
services=config["services"]

for service in services:
    print("checking:",service["name"])
    result=chk_services(service)
    print(result)
    insert_chk(result)