import psycopg2
from config import db_config
from http.server import BaseHTTPRequestHandler, HTTPServer
from psycopg2 import pool 
from urllib.parse import urlparse, parse_qs
import json

leaderboardFile = "leaderboard.json"

connection_pool = pool.SimpleConnectionPool(
    1,100,
    host=db_config['hostname'],
    dbname=db_config['database'],
    user=db_config['username'],
    password=db_config['password'],
    port=db_config['port']
)

def fetchSubjects():
    conn = None
    cur = None
    subjects = []
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        
        cur.execute('SELECT subject_id, subject_name FROM subjects')
        
        rows = cur.fetchall()
        conn.commit()
        conn.close()
        
        return [{"subject_id": row[0], "subject_name": row[1]} for row in rows] # array of the subjects fetched from the database
        #return json.dump([dict(ix)  for ix in rows])
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
        topics = [{"topic_id": row[0], "topic_name": row[1]} for row in rows]
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
        quiz = [{"quiz_id": row[0], "quiz_name": row[1]} for row in rows]
        print("Fetched quizzes:", quiz)
    except Exception as error:
        print('Error fetching quizzes:',error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
    return quiz

'''def fetchQuestionsAndAnswers(quiz_id):
    conn = None
    cur = None
    questionsNAnswers = []
    
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        #cur.execute('SELECT * FROM question_answer_view')
        cur.execute('SELECT question_text, points, question_level, answer_text, quiz_name, topic_id '
                    'FROM question_answers_view WHERE quiz_id = %s', (quiz_id,))
        rows = cur.fetchall()
        
        for row in rows:
            print(row)
    except Exception as error:
        print("Error querying the view", error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn) '''
            
            
def fetchQuestionsAndAnswers(quiz_id):
    conn = None
    cur = None
    question_and_answers = []
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        cur.execute('SELECT question_id, question_text, points, question_level, answer_text, answer_id, is_correct, quiz_name, topic_id '
                    'FROM question_answers_view WHERE quiz_id = %s', (quiz_id,))
        rows = cur.fetchall()
        
        print(f"Rows fetched for quiz_id {quiz_id}: {rows}")
        
        question_map = {}        
        
        for row in rows:
            question_id = row[0]
            question_text = row[1]
            points = row[2]
            question_level = row[3]
            answer_text = row[4]
            answer_id = row[5]
            is_correct = row[6]
            quiz_name = row[7]
                        
            if question_id not in question_map:
                question_map[question_id] = {
                    "question_id" : question_id,
                    "question_text" : question_text,
                    "points" : points,
                    "question_level" : question_level,
                    "answers" : []
                }
            question_map[question_id]["answers"].append({
                "answer_text" : answer_text,
                "is_correct" : is_correct,
                "answer_id": answer_id
            })
            
        question_and_answers = []
        for x in question_map.values():
            question_and_answers.append(x) # I am now appending each value of the question_map to the question_and_answers array which will later be returned in this function
    except Exception as error:
        print("Error querying question_and_answers view from database",error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
    return question_and_answers
        

def fetchQuestionsAndAnswers2(quiz_id):
    conn = None
    cur = None
    questions_and_answers = []
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        # Query the view for the given quiz_id
        cur.execute('SELECT question_text, points, question_level, answer_text, quiz_name, topic_id '
                    'FROM question_answers_view WHERE quiz_id = %s', (quiz_id,))
        rows = cur.fetchall()

        # Group answers by question
        question_map = {}
        for row in rows:
            question_text = row[0]
            if question_text not in question_map:
                question_map[question_text] = {
                    "question_text": question_text,
                    "points": row[1],
                    "question_level": row[2],
                    "answers": []
                }
            question_map[question_text]["answers"].append({
                "answer_text": row[3]
            })

        # Convert the map to a list
        questions_and_answers = list(question_map.values())
    except Exception as error:
        print("Error querying the view:", error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
    return questions_and_answers


def fetchLeaderboard():
    conn = None
    cur = None
    leaderboard = []
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()

        # Fetch leaderboard data from the database
        sqlcommand = '''SELECT u.user_name, sp.total_points
                        FROM users u
                        JOIN student_progress sp ON u.user_id = sp.user_id
                        ORDER BY sp.total_points DESC;'''
        cur.execute(sqlcommand)
        rows = cur.fetchall()

        # Convert rows to a list of dictionaries
        leaderboard = [{"name": row[0], "score": row[1]} for row in rows]
        
        json_file = open("leaderboard.json","x")
        
        # Write the leaderboard data to a JSON file
        with open("leaderboard.json", "w", encoding="utf-8") as json_file:
            json.dump(leaderboard, json_file, ensure_ascii=False, indent=4)
        print("Leaderboard data written to leaderboard.json")

    except Exception as error:
        print("Error fetching leaderboard:", error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)

    return leaderboard
fetchLeaderboard()


def createAccount(user_name, user_last_name, user_email, user_password):
    conn = None
    cur = None
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        cur.execute(
            'INSERT INTO users (user_name, user_last_name, user_email, user_password, join_date) '
            'VALUES (%s, %s, %s, %s, NOW()) RETURNING user_id;',
            (user_name, user_last_name, user_email, user_password)
        )
        user_id = cur.fetchone()[0]
        
        cur.execute(
            'INSERT INTO student_progress (user_id, total_points, user_level) '
            'VALUES (%s, %s, %s);',
            (user_id, 0, 0)  # Default total_points and user_level are 0
        )
        
        conn.commit()
        
        print(f"User created with ID {user_id} and progress initialized.")
        return {"user_id": user_id, "message": "Account created successfully."}
    except Exception as error:
        if conn:
            conn.rollback()
        print('There is an error with creating an account and initalising progress:',error)        
        return {"error": "Failed to create account."}
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)

def loginUser(email,password):
    conn = None
    cur = None
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        cur.execute('SELECT user_id FROM users WHERE user_email = %s AND user_password = %s',(email,password))
        user = cur.fetchone()
        if user:
            return {"success": True, "user_id":user[0]}
        else:
            return {"success": False, "message":"Invalid email or password"}
    except Exception as error:
        print("Error validating user:",error)
        return {"success": False, "message": "An error occured"}
    finally:
        if cur:
            cur.close()
        if conn:
            connection_pool.putconn(conn)


    
        
class S (BaseHTTPRequestHandler):
    
    def do_OPTIONS(self):
        #preflight requests
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')  # Allow all origins
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')  # Allowed methods
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Origin, Accept, X-Requested-With')  # Allowed headers
        self.end_headers()
    
    def do_GET(self):
        parsed_path = urlparse(self.path)
        if self.path == '/subjects':
            subjects = fetchSubjects()
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*')  # Allow all origins
            self.send_header('Content-type','application/json')
            self.end_headers()
            #self.wfile.write(b'<html><body>test</body></html>')
            self.wfile.write(json.dumps(subjects, indent = 2).encode('utf-8'))
        elif parsed_path.path == '/topics':
            query_params = parse_qs(parsed_path.query)
            subject_id = query_params.get('subject_id',[None])[0]
            if subject_id is not None:
                try:
                    subject_id = int(subject_id)  
                    topics = fetchTopics(subject_id)  
                    self.send_response(200)
                    self.send_header('Access-Control-Allow-Origin', '*')  # Allow all origins
                    self.send_header('Content-type', 'application/json')  # JSON response
                    self.end_headers()
                    self.wfile.write(json.dumps(topics, indent=2).encode('utf-8'))
                except ValueError:
                    self.send_response(400)  # Bad Request if subject_id is not a valid integer
                    self.end_headers()
                    self.wfile.write(b'{"error": "Invalid subject_id"}')
            else:
                self.send_response(400)  # Bad Request if subject_id is missing
                self.end_headers()
                self.wfile.write(b'{"error": "subject_id is required"}')
        elif parsed_path.path == '/quiz':
            # Parse query parameters
            query_params = parse_qs(parsed_path.query)
            subject_id = query_params.get('subject_id', [None])[0]
            topic_id = query_params.get('topic_id', [None])[0]

            if subject_id is not None and topic_id is not None:
                try:
                    # Convert subject_id and topic_id to integers
                    subject_id = int(subject_id)
                    topic_id = int(topic_id)

                    # Fetch quizzes for the given subject_id and topic_id
                    quiz = generateQuiz(subject_id, topic_id)

                    # Send response
                    self.send_response(200)
                    self.send_header('Access-Control-Allow-Origin', '*')  # Allow all origins
                    self.send_header('Content-Type', 'application/json')  # JSON response
                    self.end_headers()
                    self.wfile.write(json.dumps(quiz, indent=2).encode('utf-8'))
                except ValueError:
                    # Handle invalid subject_id or topic_id
                    self.send_response(400)  # Bad Request
                    self.end_headers()
                    self.wfile.write(b'{"error": "Invalid subject_id or topic_id"}')
            else:
                # Handle missing subject_id or topic_id
                self.send_response(400)  # Bad Request
                self.end_headers()
                self.wfile.write(b'{"error": "subject_id and topic_id are required"}')
        elif parsed_path.path == '/quiz_questions':
            # Parse query parameters
            query_params = parse_qs(parsed_path.query)
            quiz_id = query_params.get('quiz_id', [None])[0]
            if quiz_id is not None:
                try:
                    quiz_id = int(quiz_id)
                    question_and_answers = fetchQuestionsAndAnswers(quiz_id)

                    self.send_response(200)
                    self.send_header('Access-Control-Allow-Origin', '*')  # Allow all origins
                    self.send_header('Content-Type', 'application/json')  # JSON response
                    self.end_headers()
                    self.wfile.write(json.dumps(question_and_answers, indent=2).encode('utf-8'))
                except ValueError:
                    self.send_response(400)  # Bad Request
                    self.end_headers()
                    self.wfile.write(b'{"error": "Invalid quiz_id"}')
            else:
                # Handle missing quiz_id
                self.send_response(400)  # Bad Request
                self.end_headers()
                self.wfile.write(b'{"error": "quiz_id is required"}')
        elif parsed_path.path == '/leaderboard':
            leaderboard = fetchLeaderboard()
            self.send_response(200)
            self.send_header('Allow-Control-Allow-Origin','*')
            self.send_header('Content-Type','application/json')
            self.end_headers()
            self.wfile.write(json.dumps(leaderboard,indent = 2).encode('utf-8'))
            
        else:
            self.send_response(404)  # Not Found for other paths (can't find the endpoint; invalid endpoint)
            self.end_headers()
            self.wfile.write(b'{"error": "Endpoint not found"}')
        
        
    def do_POST(self):
        #parsed_path = urlparse(self.path)
        #if parsed_path.path == '/create_account':
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')  # Allow all origins
        self.send_header('Location','http://localhost:8000/subjects')
        self.end_headers()
        self.wfile.write(b'<html><body>test</body></html>')
       
            
    def do_POST(self):
        parsed_path = urlparse(self.path)
        if parsed_path.path == '/create_account':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data)
            print(data)
            
            #user_name = data.get('user_name')
            #user_last_name = data.get('user_last_name')
            #user_email = data.get('user_email')
            #user_password = data.get('user_password')
            user_name = data.get("firstName")
            user_last_name = data.get("lastName")
            user_email = data.get("email")
            user_password = data.get("password")
           
            
            result = createAccount(user_name,user_last_name,user_email,user_password)
            if result.get("error")=="Failed to create account":
                self.send_error(400)
                self.send_header('Access-Control-Allow-Origin','*')
                self.send_header('Content-Type','application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"error": "Failed to create account."}).encode('utf-8'))
            
            else:
                self.send_response(200) #Bad request
                self.send_header('Access-Control-Allow-Origin','*')
                #self.send_header('Location','http://localhost:8000/subjects')
                self.end_headers()
                #self.wfile.write(b'<html><body>test</body></html>')
                self.wfile.write(json.dumps({"Success":"Account created"}).encode('utf-8'))
        
        if self.path == '/login':
            print('IN LOGIN')
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data)
            email = data.get('email')
            password = data.get('password')
            #user = loginUser(email,password)
            result = loginUser(email,password)
            print(result)
            self.send_response(200)
            self.send_header('Content-Type','application/json')
            self.send_header('Access-Control-Allow-Origin','*')
            self.end_headers()
            self.wfile.write(json.dumps(result).encode('utf-8'))
        if parsed_path.path == '/submit_attempts':
            try:
                content_length = int(self.headers['Content-Length'])
                post_data = self.rfile.read(content_length)
                data = json.loads(post_data)
                
                user_id = data.get('user_id')
                attempts = data.get('attempts')
                
                if not user_id or not attempts:
                    self.send_response(400)
                    self.send_header('Access-Control-Allow-Origin','*')
                    self.end_headers()
                    self.wfile.write(b'{"error": "Missing required fields"}')
                    return
                conn = connection_pool.getconn()
                cur = conn.cursor()
                
                for a in attempts:
                    question_id = a['question_id']
                    answer_id = a['answer_id']
                    is_correct = a['is_correct']
                    cur.execute('INSERT INTO user_attempts (user_id, question_id, answer_id, is_correct) VALUES (%s, %s, %s, %s)',(user_id, question_id, answer_id, is_correct))
                
                conn.commit()
                    
                self.send_response(200)
                self.send_header('Access-Control-Allow-Origin','*')
                self.send_header('Content-Type','application/json')
                self.end_headers()
                self.wfile.write(b'{"success": true, "message": "Attempts submitted successfully"}')
            except Exception as error:
                print(f'Insertion error of attempts: {error}')
                if conn:
                    conn.rollback()
                self.send_response(200)
                self.send_header('Access-Control-Allow-Origin','*')
                self.end_headers()
                self.wfile.write(b'{"error": "Failed to submit attempts"}')
            finally:
                if cur is not None:
                    cur.close()
                if conn is not None:
                    connection_pool.putconn(conn)
        

def run(server_class=HTTPServer, handler_class=S, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    fetchSubjects()
    print(f'Starting server on port {port}...')
    httpd.serve_forever()
if __name__ == '__main__':
    run()
            