import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

def get_conn():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
    )

@app.route("/api/health")
def health():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT 1;")
    cur.close()
    conn.close()
    return jsonify({"status": "OK"})

@app.route("/api/data")
def data():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("CREATE TABLE IF NOT EXISTS items(name text);")
    cur.execute("INSERT INTO items VALUES('hello');")
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"result": "saved"})

app.run(host="0.0.0.0", port=5000)