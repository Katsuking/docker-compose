import mysql.connector
from typing import List
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello world"}

@app.get("/users")
def get_users() -> List[dict]:
    conn = mysql.connector.connect(
        user="myuser",
        password="mypassword",
        host="db",
        database="mydatabase",
    )
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users")
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows
