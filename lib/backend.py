import psycopg2

hostname = 'localhost'
database = '7B_SETAP'
username = 'postgres'
pwd = 'admin'
port_id = 5432

conn = psycopg2.connect(
    host = hostname,
    dbname = database,
    user = username
)