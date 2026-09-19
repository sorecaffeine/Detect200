import sqlite3

def init_db():
    connection = get_connect()

    with open("db/schema.sql", "r") as file:
        schema = file.read()

    connection.executescript(schema)
    connection.close()
def get_connect():
    return sqlite3.connect("data/checks.db")

def insert_chk(data):
    connection=get_connect()
    cursor=connection.cursor()
    cursor.execute(

        """
        INSERT INTO checks(
            timestamp,
            service,
            http_status,
            success
        )
        VALUES(?,?,?,?)
        """,
        (data["timestamp"],data["service"],data["http_status"],data["success"]),
    )
    connection.commit()
    connection.close()
