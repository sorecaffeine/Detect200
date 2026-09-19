import httpx

url ="https://github.com"  # prpbaly use a json too parse list of website too checl

try:
    reply=httpx.get(url,timeout=5.0)

    print("URL:",url)
    print("HTTP status:",reply.status_code)

    if reply.status_code < 400:
        print("Status:up")
    else:
        print("status:DOWN")

except httpx.RequestError as error:
    print("Status:DOWn")
    print("ERROR",error)
