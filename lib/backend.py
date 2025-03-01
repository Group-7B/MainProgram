# filepath: /Users/abdullahattiq/Documents/my_SETAP/lib/backend.py
import psycopg2
from config import db_config
from http.server import BaseHTTPRequestHandler, HTTPServer
import json

def fetchSubjects():
    conn = None
    cur = None
    subjects = []
    try:
        conn = psycopg2.connect(
            host=db_config['hostname'],
            dbname=db_config['database'],
            user=db_config['username'],
            password=db_config['password'],
            port=db_config['port']
        )
        
        cur = conn.cursor()
        
        cur.execute('SELECT subject_name FROM subjects')
        rows = cur.fetchall()
        subjects = [row[0] for row in rows]  # array of the subjects fetched from the database
        
    except Exception as error:
        print(error)
    finally: 
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()
    
    return subjects

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/subjects':
            subjects = fetchSubjects()
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin','*') # Enabled CORS
            self.end_headers()
            self.wfile.write(json.dumps(subjects).encode())

def run(server_class=HTTPServer, handler_class=RequestHandler, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting server on port {port}...')
    httpd.serve_forever()


if __name__ == '__main__':
    run()