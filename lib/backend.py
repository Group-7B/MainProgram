import psycopg2
from config import db_config
from http.server import BaseHTTPRequestHandler, HTTPServer
from psycopg2 import pool 
from urllib.parse import urlparse, parse_qs
import json

connection_pool = pool.SimpleConnectionPool(
    1,100,
    host=db_config['hostname'],
    dbname=db_config['database'],
    user=db_config['username'],
    password=db_config['password'],
    port=db_config['port']
)

#class subjectManager:
    # fetch subjects -- fetchSubjects method
    # load mock exams  -- 
    
# class topicManager:
    # fetch topics -- fetchTopics method
    # load quizzes   -- 

def fetchSubjects():
    conn = None
    cur = None
    subjects = []
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        
        cur.execute('SELECT subject_id, subject_name, subject_description FROM subjects')
        
        rows = cur.fetchall()
        
        return [{'subject_id': row[0], 'subject_name': row[1], 'subject_description': row[2]} for row in rows] # array of the subjects fetched from the database
     
    except Exception as error:
        print(error)
    finally: 
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
    
    return subjects

def fetchTopics(subject_id):
    conn = None
    cur = None
    topics = []
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor() #added topic_id below
        cur.execute('SELECT topic_id, topic_name FROM topics WHERE subject_id = %s', (subject_id,))
        rows = cur.fetchall()
        #topics = [row[0] for row in rows]
        topics = [{'topic_id': row[0], 'topic_name': row[1]} for row in rows]
    except Exception as error:
        print(error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
    return topics

def generateQuiz(subject_id,topic_id):
    conn = None
    cur = None
    quiz = []
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        print(f"Fetching quizzes for subject_id: {subject_id}, topic_id: {topic_id}")
        cur.execute('SELECT quiz_id, quiz_name FROM quizzes WHERE subject_id = %s AND topic_id = %s',(subject_id,topic_id))
        rows = cur.fetchall()
        quiz = [{'quiz_id': row[0], 'quiz_name': row[1]} for row in rows]
        print("Fetched quizzes:", quiz)
    except Exception as error:
        print('Error fetching quizzes:',error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
    return quiz
    

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urlparse(self.path)
        print('processing GET')
        if self.path == '/subjects':
            subjects = fetchSubjects()
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin','*') # Enabled CORS
            self.end_headers()
            print(subjects)
            self.wfile.write(json.dumps(subjects).encode())
        elif parsed_path.path == '/topics':
            query_components = parse_qs(parsed_path.query)
            subject_id = query_components.get('subject_id', [None])[0]
            print(subject_id)
            if subject_id is not None:
                topics = fetchTopics(subject_id)
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin','*') # Enabled CORS
                self.end_headers()
                print("*******")
                print(topics)
                print("Ok")
                self.wfile.write(json.dumps(topics).encode())
        elif parsed_path.path == '/quiz':
            query_components = parse_qs(parsed_path.query)
            subject_id = query_components.get('subject_id',[None])[0]
            topic_id = query_components.get('topic_id', [None])[0]
            print("checking subject_id and topic_id:")
            print(subject_id,topic_id)
            if topic_id is not None and topic_id is not None:
                quiz = generateQuiz(subject_id,topic_id)
                self.send_response(200)
                self.send_header('Content-type','application/json')
                self.send_header('Access-Control-Allow-Origin','*')
                self.end_headers()
                print("****************")
                print(quiz)
                self.wfile.write(json.dumps(quiz).encode())
            else:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(b'Missing topic_id parameter')
                

                
def run(server_class=HTTPServer, handler_class=RequestHandler, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    fetchSubjects()
    print(f'Starting server on port {port}...')
    httpd.serve_forever()
run()