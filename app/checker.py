#Check services  just get 200 or not lol
import httpx
from datetime import datetime,timezone
def chk_services(service):
    timestamp=datetime.now(timezone.utc).isoformat()
    try:
        resp=httpx.get(
            service["url"],
            timeout=service["timeout"],
        )
        return{
        "timestamp":timestamp,
        "service":service["name"],
        "success":resp.status_code==200,
        "http_status":resp.status_code,
        "error":None,
        }
    except httpx.RequestError as error:
        return{
            "timestamp":timestamp,
            "service":service["name"],
            "success":False,
            "https_status":None,
            "error":str(error)
        }
