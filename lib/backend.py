from config import db_config
from http.server import BaseHTTPRequestHandler, HTTPServer
from psycopg2 import pool
from psycopg2 import errors as psycopg2_errors
from urllib.parse import urlparse, parse_qs
import json
import schedule
import time
import threading
import math

leaderboardFile = "leaderboard.json"


connection_pool = pool.SimpleConnectionPool(
    1,100,
    host=db_config['hostname'],
    dbname=db_config['database'],
    user=db_config['username'],
    password=db_config['password'],
    port=db_config['port']
)
# fetching subjects function, called in the S class to be used by frontend
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
    except Exception as error:
        print(error)
    finally: 
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
    
    return subjects
#fetch topucs function, called in the S class to be used by frontend
def fetchTopics(subject_id):
    conn = None
    cur = None
    topics = []
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor() #added topic_id below
        cur.execute('SELECT topic_id, topic_name FROM topics WHERE subject_id = %s', (subject_id,))
        rows = cur.fetchall()
        topics = [{"topic_id": row[0], "topic_name": row[1]} for row in rows]
    except Exception as error:
        print(error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
    return topics
#generate quiz function, called in the S class to be used by frontend
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

        
# function for fetching the quiz data, called in the S class to be used by frontend
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
#fetch leaderbaord function, called in the S class to be used by frontend
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
        
        #json_file = open("leaderboard.json")
        
        # Write the leaderboard data to a JSON file
        with open("leaderboard.json", "w", encoding="utf-8") as json_file:
            json.dump(leaderboard, json_file, ensure_ascii=False, indent=4)
        print("Leaderboard data written to leaderboard.json")

    except Exception as error:
        print("Error fetching leaderboard:", str(error))
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)

    return leaderboard
#fetch prifle function called in the S class to be used by frontend
def fetchProfile(user_id):
    conn = None
    cur = None
    profileInfo = None
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        sqlcommand = '''SELECT u.user_name, u.user_email, sp.total_points
                        FROM users u
                        JOIN student_progress sp ON u.user_id = sp.user_id
                        WHERE u.user_id = %s;'''
        cur.execute(sqlcommand, (user_id,))

        row = cur.fetchone()

        if row is None:
            profileInfo = None
        elif isinstance(row, (list, tuple)):
            if len(row) >= 3:
                try:
                    profileInfo = {"name": row[0], "email": row[1], "score": row[2]}
                except IndexError as idx_err:
                     print(f"!!! IndexError processing row elements for user_id {user_id}: {idx_err}. Row data was: {row}")
                     profileInfo = None
                except TypeError as te:
                     print(f"!!! TypeError processing elements within the row tuple/list for user_id {user_id}: {te}. Row data was: {row}")
                     profileInfo = None
            else:
                print(f"!!! Error [fetchProfile {user_id}]: Unexpected data format. Expected tuple/list of length 3+, got length {len(row)}: {row}")
                profileInfo = None
        else:
             print(f"!!! Critical Error [fetchProfile {user_id}]: Unexpected row data type received. Expected tuple/list or None, got {type(row)}: {row}")
             profileInfo = None

    except psycopg2_errors.Error as db_error:
        print(f"SQLSTATE: {db_error.pgcode}") 
        profileInfo = None
        if conn: conn.rollback()
    except IndexError as index_error:
        print(f"!!! Index Error processing row for user_id {user_id}: {index_error}. Row data was: {row}")
        profileInfo = None
    except Exception as error:
        print(f"!!! Unexpected Error fetching/processing profile for user_id {user_id}: {error} (Type: {type(error)})")
        profileInfo = None
        if conn and not isinstance(error, psycopg2_errors.Error):
             try:
                 conn.rollback()
             except Exception as rb_error:
                 print(f"--- WARN [fetchProfile {user_id}]: Error during rollback: {rb_error} ---")
    finally:
        if cur is not None:
            print(f"--- DEBUG [fetchProfile {user_id}]: Closing cursor ---")
            cur.close()
        if conn is not None:
            print(f"--- DEBUG [fetchProfile {user_id}]: Putting connection back to pool ---")
            connection_pool.putconn(conn)
        print(f"--- Finished fetching profile for user_id: {user_id}. Returning: {profileInfo} ---")

    return profileInfo



def run_scheduler():
    while True:
        schedule.run_pending()
        time.sleep(300)

#crete account function called in the S class to be used by frontend
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
            (user_id, 0, 0) 
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

def getProgress(user_id):
    conn = None
    cur = None
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        cur.execute('SELECT total_points, user_level FROM student_progress WHERE user_id = %s;', (user_id,))
        progress = cur.fetchone()
        if progress:
            return {"total_points": progress[0], "user_level": progress[1]}
        else:
            return None
    except Exception as error:
        print(f"Error fetching user progress for user_id {user_id}: {error}")
        return None
    finally:
        if cur:
            cur.close()
        if conn:
            connection_pool.putconn(conn)

def updateLevel (user_id, score):
    conn = None
    cur = None
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()

        cur.execute('SELECT total_points, user_level FROM student_progress WHERE user_id = %s FOR UPDATE;', (user_id,))
        current_progress = cur.fetchone()
        if not current_progress:
            return {"success": False, "message": "User progress not found."}

        current_total_points, current_user_level = current_progress
        
        new_total_points = current_total_points + score
        
        new_user_level = new_total_points // 100 
        
        level_increased = new_user_level > current_user_level

        cur.execute(
            'UPDATE student_progress SET total_points = %s, user_level = %s WHERE user_id = %s;',
            (new_total_points, new_user_level, user_id)
        )
        conn.commit()
        
        return {
            "success": True, 
            "message": "Score and level updated successfully.",
            "new_total_points": new_total_points,
            "new_user_level": new_user_level,
            "level_increased": level_increased
        }
    except Exception as error:
        if conn:
            conn.rollback()
        print(f"Error updating user score and level for user_id {user_id}: {error}")
        return {"success": False, "message": "Failed to update score and level."}
    finally:
        if cur:
            cur.close()
        if conn:
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

def userLevel(user_id):
    conn = None
    cur = None
    try:
        conn = connection_pool.getconn()
        cur = conn.cursor()
        cur.execute('SELECT user_level FROM student_progress WHERE user_id = %s;',(user_id,))
        level = cur.fetchone()
        
        if level:
            return {"success": True, "user_level": level[0]}
        else:
            return {"success": False, "user_level":"This user does not exist"}
    except Exception as error:
        print("There is an error while fetching the user's level:",error)
        return {"success": False, "user_level": None}
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            connection_pool.putconn(conn)
        
    
class S (BaseHTTPRequestHandler):
    
    def do_OPTIONS(self):
        #preflight requests
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')  # Allow all origins
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')  # Allowed methods
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Origin, Accept, X-Requested-With')  # Allowed headers
        self.end_headers()

    def send_json_response(self, status_code, content_dict):
        self.send_response(status_code)
        self.send_header('Access-Control-Allow-Origin', '*') # Or your specific origin
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(content_dict).encode('utf-8'))
    
    def do_GET(self):
        try:
            parsed_path = urlparse(self.path)
            query_params = parse_qs(parsed_path.query)
            path = parsed_path.path 
            print(f"GET request received for path: {path}, query: {query_params}")
        except Exception as parse_error:
             print(f"Error parsing request path/query: {parse_error}")
             self.send_json_response(400, {"error": "Bad request URL format"})
             return
        
        if self.path == '/subjects':
            subjects = fetchSubjects()
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*') 
            self.send_header('Content-type','application/json')
            self.end_headers()
            self.wfile.write(json.dumps(subjects, indent = 2).encode('utf-8'))
        elif parsed_path.path == '/topics':
            query_params = parse_qs(parsed_path.query)
            subject_id = query_params.get('subject_id',[None])[0]
            if subject_id is not None:
                try:
                    subject_id = int(subject_id)  
                    topics = fetchTopics(subject_id)  
                    self.send_response(200)
                    self.send_header('Access-Control-Allow-Origin', '*') 
                    self.send_header('Content-type', 'application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps(topics, indent=2).encode('utf-8'))
                except ValueError:
                    self.send_response(400)
                    self.end_headers()
                    self.wfile.write(b'{"error": "Invalid subject_id"}')
            else:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(b'{"error": "subject_id is required"}')
        elif parsed_path.path == '/quiz':
            query_params = parse_qs(parsed_path.query)
            subject_id = query_params.get('subject_id', [None])[0]
            topic_id = query_params.get('topic_id', [None])[0]

            if subject_id is not None and topic_id is not None:
                try:
                    subject_id = int(subject_id)
                    topic_id = int(topic_id)
                    quiz = generateQuiz(subject_id, topic_id)
                    self.send_response(200)
                    self.send_header('Access-Control-Allow-Origin', '*')
                    self.send_header('Content-Type', 'application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps(quiz, indent=2).encode('utf-8'))
                except ValueError:
                    self.send_response(400)
                    self.end_headers()
                    self.wfile.write(b'{"error": "Invalid subject_id or topic_id"}')
            else:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(b'{"error": "subject_id and topic_id are required"}')
        elif parsed_path.path == '/quiz_questions':
            query_params = parse_qs(parsed_path.query)
            quiz_id = query_params.get('quiz_id', [None])[0]
            if quiz_id is not None:
                try:
                    quiz_id = int(quiz_id)
                    question_and_answers = fetchQuestionsAndAnswers(quiz_id)

                    self.send_response(200)
                    self.send_header('Access-Control-Allow-Origin', '*') 
                    self.send_header('Content-Type', 'application/json')  
                    self.end_headers()
                    self.wfile.write(json.dumps(question_and_answers, indent=2).encode('utf-8'))
                except ValueError:
                    self.send_response(400)
                    self.end_headers()
                    self.wfile.write(b'{"error": "Invalid quiz_id"}')
            else:
                self.send_response(400)  
                self.end_headers()
                self.wfile.write(b'{"error": "quiz_id is required"}')
        elif parsed_path.path == '/leaderboard':
            try:
                with open(leaderboardFile, 'r', encoding='utf-8') as f:
                    leaderboard_data = json.load(f)
                self.send_json_response(200, leaderboard_data)
            except FileNotFoundError:
                print(f"'{leaderboardFile}' not found. Generating a new one.")
                fetchLeaderboard() 
                try:
                    with open(leaderboardFile, 'r', encoding='utf-8') as f:
                        leaderboard_data = json.load(f)
                    self.send_json_response(200, leaderboard_data)
                except Exception as e:
                    print(f"Error serving leaderboard after attempting to regenerate: {e}")
                    self.send_json_response(500, {"error": "Could not retrieve leaderboard data"})
            except Exception as e:
                print(f"Error serving leaderboard data: {e}")
                self.send_json_response(500, {"error": "Could not retrieve leaderboard data"})
            return
        elif parsed_path.path == '/profile':
            user_id_str = query_params.get('user_id', [None])[0]
            print(f"--- DEBUG [do_GET]: Matched /profile path. User ID string: '{user_id_str}' ---")
            if user_id_str:
                try:
                    user_id = int(user_id_str)
                    profile_data = fetchProfile(user_id)
                    if profile_data:
                        self.send_json_response(200, profile_data)
                    else:
                        self.send_json_response(404, {"error": "User profile not found"})

                except ValueError:
                    self.send_json_response(400, {"error": "Invalid user_id format"})
                except Exception as e:
                    print(f"Error serving profile data for user_id {user_id_str}: {e}")
                    self.send_json_response(500, {"error": "Could not retrieve profile data"})
            else:
                self.send_json_response(400, {"error": "user_id query parameter is required"})

        elif parsed_path.path == '/userLevel':
            query_params = parse_qs(parsed_path.query)
            user_id = query_params.get('user_id',[None])[0]
            if user_id is not None:
                try:
                    user_id = int(user_id)
                    result = userLevel(user_id)
                    
                    self.send_response(200)
                    self.send_header('Access-Control-Allow-Origin','*')
                    self.send_header('Content-Type','application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps(result, indent = 2).encode('utf-8'))
                except ValueError:
                    self.send_response(400)
                    self.end_headers()
                    self.wfile.write(b'{"error":"Unknown user_id}')
            else:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(b'{"error":"user_id is required"}')
        else:
            self.send_response(404) 
            self.end_headers()
            self.wfile.write(b'{"error": "Endpoint not found"}')
        
        
        
    def do_POST(self):
        parsed_path = urlparse(self.path)
        if parsed_path.path == '/update_score':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data)

            user_id = data.get('user_id')
            score_achieved = data.get('score_achieved')

            if user_id is None or score_achieved is None:
                self.send_json_response(400, {"success": False, "message": "Missing user_id or score_achieved"})
                return

            result = updateLevel(user_id, score_achieved) 

            if result.get("success"):
                print("Score updated in DB. Now refreshing leaderboard.json...")
                fetchLeaderboard()
                # ---
                self.send_json_response(200, result)
            else:
                self.send_json_response(500, result)
            return
        if parsed_path.path == '/create_account':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data)
            print(data)
            
            user_name = data.get('user_name')
            user_last_name = data.get('user_last_name')
            user_email = data.get('user_email')
            user_password = data.get('user_password')       
            
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
                self.end_headers()
                self.wfile.write(json.dumps({"Success":"Account created"}).encode('utf-8'))
        
        if self.path == '/login':
            print('IN LOGIN')
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data)
            email = data.get('email')
            password = data.get('password')
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
    #Startup leaderbaord fetch
    fetchLeaderboard()
    #weekly leaderboard fetch
    schedule.every().monday.at("00:05").do(fetchLeaderboard)
    #create a thread to keep updating the leaderboard as the http server blocks anything from executing
    scheduler_thread = threading.Thread(target=run_scheduler)
    scheduler_thread.daemon = True # Allows the program to exit even if this thread is running
    scheduler_thread.start()
    print(f'Starting server on port {port}...')
    httpd.serve_forever() # blocks the main thread
if __name__ == '__main__':
    run()
            
