import psycopg2

def get_connection():
    return psycopg2.connect(
        dbname="hotel_db",
        user="moabdelmajid",
        password="",   # leave empty
        host="localhost",
        port="5432"
    )