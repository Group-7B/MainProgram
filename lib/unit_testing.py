import unittest
from unittest.mock import patch, MagicMock, mock_open, ANY
import json
import backend
from backend import fetchSubjects, fetchTopics, generateQuiz, createAccount, loginUser, fetchQuestionsAndAnswers


class TestFetchSubjects(unittest.TestCase):
    def setUp(self):
        self.rows = [
            (1, "Mathematics"),
            (2, "English"),
            (3, "Physics"),
            (4, "Operating systems"),
        ]

        self.expectedSubjects = [
            {"subject_id": 1, "subject_name": "Mathematics"},
            {"subject_id": 2, "subject_name": "English"},
            {"subject_id": 3, "subject_name": "Physics"},
            {"subject_id": 4, "subject_name": "Operating systems"},
        ]

        self.mock_conn = MagicMock()
        self.mock_cursor = MagicMock()
        self.mock_conn.cursor.return_value = self.mock_cursor
        self.mock_cursor.fetchall.return_value = self.rows

        self.patcher_getconn = patch("backend.connection_pool.getconn", return_value=self.mock_conn)
        self.patcher_putconn = patch("backend.connection_pool.putconn")
        self.mock_getconn = self.patcher_getconn.start()
        self.mock_putconn = self.patcher_putconn.start()

    def tearDown(self):
        self.patcher_getconn.stop()
        self.patcher_putconn.stop()

    def testFetchSubjectsSuccess(self):
        result = fetchSubjects()
        #self.mock_cursor.execute.assert_called_once_with('SELECT subject_id, subject_name FROM subjects')       
        self.mock_putconn.assert_called_once_with(self.mock_conn)
        self.assertEqual(result, self.expectedSubjects) #FIRST TEST 

    def testFetchSubjectsEmptyArray(self):
        self.mock_cursor.fetchall.return_value = []
        result = fetchSubjects()
        self.mock_putconn.assert_called_once_with(self.mock_conn)
        self.assertEqual(result, []) #SECOND TEST

    def testFetchSubjectsDatabaseError(self):
        self.mock_conn.cursor.side_effect = Exception("Database error")
        result = fetchSubjects()
        self.mock_putconn.assert_called_once_with(self.mock_conn)
        self.assertEqual(result, []) #THIRD TEST


class TestFetchTopics(unittest.TestCase):
    def setUp(self):
        
        self.rows = [
            (1, 1, "Algebra"),
            (1, 2, "Ratio and Proportion"),
            (1, 3, "Persentage"),
            (2, 4, "Vocabulary"),
            (2, 5, "Grammar"),
            (3, 6, "Mechanics"),
            (3, 7, "Thermodynamics"),
            (3, 8, "Electromagnetism"),
            (4, 9, "Memory management"),
            (4, 10, "Process management"),
            (4, 11, "File management"),
        ]

        self.expectedTopicsBySubject = {
            1: [
                {"topic_id": 1, "topic_name": "Algebra"},
                {"topic_id": 2, "topic_name": "Ratio and Proportion"},
                {"topic_id": 3, "topic_name": "Persentage"},
            ],
            2: [
                {"topic_id": 4, "topic_name": "Vocabulary"},
                {"topic_id": 5, "topic_name": "Grammar"},
            ],
            3: [
                {"topic_id": 6, "topic_name": "Mechanics"},
                {"topic_id": 7, "topic_name": "Thermodynamics"},
                {"topic_id": 8, "topic_name": "Electromagnetism"},
            ],
            4: [
                {"topic_id": 9, "topic_name": "Memory management"},
                {"topic_id": 10, "topic_name": "Process management"},
                {"topic_id": 11, "topic_name": "File management"},
            ],
        }

        self.mock_conn = MagicMock()
        self.mock_cursor = MagicMock()
        self.mock_conn.cursor.return_value = self.mock_cursor

        self.patcher_getconn = patch("backend.connection_pool.getconn", return_value=self.mock_conn)
        self.patcher_putconn = patch("backend.connection_pool.putconn")
        self.mock_getconn = self.patcher_getconn.start()
        self.mock_putconn = self.patcher_putconn.start()

    def tearDown(self):
        self.patcher_getconn.stop()
        self.patcher_putconn.stop()
        
        
    def testFetchTopics(self):
        for subject_id, expectedTopics in self.expectedTopicsBySubject.items():
            self.mock_cursor.fetchall.return_value = [(topic_id, topic_name) for sub_id, topic_id, topic_name in self.rows if sub_id == subject_id]
            result = fetchTopics(subject_id)
            expectedTopicsWithSubjectId = [
                {"topic_id": topic["topic_id"], "topic_name": topic["topic_name"]}
                for topic in expectedTopics
            ]
            self.mock_putconn.assert_called_with(self.mock_conn)
            self.assertEqual(result, expectedTopicsWithSubjectId)

    '''def testFetchTopics(self):
        for subject_id, expectedTopics in self.expectedTopicsBySubject.items():
            self.mock_cursor.fetchall.return_value = [
                (sub_id, topic_id, topic_name)
                for sub_id, topic_id, topic_name in self.rows
                if sub_id == subject_id
            ]

            result = fetchTopics(subject_id)

            self.mock_putconn.assert_called_with(self.mock_conn)

            self.assertEqual(result, expectedTopics)'''

    def testFetchTopicsEmptyArray(self):
        self.mock_cursor.fetchall.return_value = []
        for subject_id in self.expectedTopicsBySubject.keys():
            result = fetchTopics(subject_id)
            self.mock_putconn.assert_called_with(self.mock_conn)
            self.assertEqual(result, [])

    def testFetchTopicsSuccessCase(self):
        for subject_id, expectedTopics in self.expectedTopicsBySubject.items():
            self.mock_cursor.fetchall.return_value = [(topic_id, topic_name) for sub_id, topic_id, topic_name in self.rows if sub_id == subject_id]
            result = fetchTopics(subject_id)
            self.mock_putconn.assert_called_with(self.mock_conn)
            #self.mock_cursor.execute.assert_called_once_with('SELECT topic_id, topic_name FROM topics WHERE subject_id = %s', (subject_id,))
            self.assertEqual(result, expectedTopics)
            

'''class TestFetchQuizzes(unittest.TestCase):
    def setUp(self):
        self.mockQuizzes = [
            #(subject_id, topic_id,quiz_id,quiz_name)
            (1,1,1,"Algebra Quiz 1"),
            (1,1,2,"Algebra Quiz 2"),
            (1,1,3,""),
            (1,2,4,""),
            (1,2,5,""),
            (1,2,6,""),
            (1,3,7,""),
            (1,3,8,""),
            (1,4,9,""),
            
            
        ]'''

class TestRegister(unittest.TestCase):
    
    def setUp(self):
        self.mock_register = [{"user_id":12, "message": "Account created successfully"}]
        self.default_level = [{"user_level": 0, "total_points":0}]
        
        
        self.mock_conn = MagicMock()
        self.mock_cursor = MagicMock()
        self.mock_conn.cursor.return_value = self.mock_cursor

        self.patcher_getconn = patch("backend.connection_pool.getconn", return_value=self.mock_conn)
        self.patcher_putconn = patch("backend.connection_pool.putconn")
        self.mock_getconn = self.patcher_getconn.start()
        self.mock_putconn = self.patcher_putconn.start()
    
    
    def testSuccessCase(self):
        self.mock_cursor.fetchone.return_value = [12]
        self.mock_cursor.execute.side_effect = [None,None]
        
        result = createAccount(user_name="dummy", user_last_name="Test", user_email="dummyTest@outlook.com", user_password="123")
        if self.assertIsNotNone(result):
            self.assertEqual(result,self.mock_register)
            self.mock_putconn.assert_called_once_with(self.mock_conn)
            self.userLevelAndPoints = [{"user_level": 0,"total_points":0}]
            self.assertEqual(self.default_level,self.userLevelAndPoints)
            
            self.mock_cursor.execute.assert_any_calls('INSERT INTO student_progress (user_id, total_points, user_level) VALUES (%s, %s, %s);', (12, 0, 0))
    
    
    def testErrorCase(self):
        self.mock_cursor.execute.side_effect = Exception("Database Error")
        
        result = createAccount(user_name="dummy", user_last_name="Test", user_email="dummyTest@outlook.com", user_password="123")
        
        self.assertEqual(result, {"error": "Failed to create account."})
        
    def tearUp(self):
        self.patcher_getconn.stop()
        self.patcher_putconn.stop()
        
    
    

'''class TestLogin(unittest.TestCase):
    def setUp(self):
        # Patch the loginUser function to allow the actual function to execute
        self.patcher = patch('backend.loginUser', side_effect=backend.loginUser)
        self.mock_loginUser = self.patcher.start()
    
    def testUserLogin(self):
        # Test a valid login case
        result = backend.loginUser('T@gmail.com', '123')
        self.assertEqual(result, {"success": True, "user_id": 6})
        
    def testErrorCase(self):
        # Test login with None for email and password
        results = backend.loginUser(None, None)
        self.assertEqual(results, {"success": False, "message": "Invalid email or password"})
        
    def tearDown(self):
        self.patcher.stop()'''
        
'''class TestLoginMocked(unittest.TestCase):
    def setUp(self):
        # Mock the database connection and cursor
        self.mock_conn = MagicMock()
        self.mock_cursor = MagicMock()
        self.mock_conn.cursor.return_value = self.mock_cursor

        # Mock the database response for loginUser
        self.mock_cursor.fetchone.return_value = [6]  # Mock user_id as 1

        # Patch the connection pool
        self.patcher_getconn = patch("backend.connection_pool.getconn", return_value=self.mock_conn)
        self.patcher_putconn = patch("backend.connection_pool.putconn")
        self.mock_getconn = self.patcher_getconn.start()
        self.mock_putconn = self.patcher_putconn.start()

    def tearDown(self):
        self.patcher_getconn.stop()
        self.patcher_putconn.stop()

    def testUserLogin(self):
        # Test a valid login case
        result = backend.loginUser('T@gmail.com', '123')
        self.assertEqual(result, {"success": True, "user_id": 6})'''
    

class TestLogin(unittest.TestCase):
    def setUp(self):
        self.mock_conn = MagicMock()
        self.mock_cursor = MagicMock()
        self.mock_conn.cursor.return_value = self.mock_cursor

        self.patcher_getconn = patch("backend.connection_pool.getconn", return_value=self.mock_conn)
        self.patcher_putconn = patch("backend.connection_pool.putconn")
        self.mock_getconn = self.patcher_getconn.start()
        self.mock_putconn = self.patcher_putconn.start()

    def tearDown(self):
        self.patcher_getconn.stop()
        self.patcher_putconn.stop()
        
    def testUserLoginValid(self):
        self.mock_cursor.fetchone.return_value = [6]  # Mock user_id as 6

        result = backend.loginUser('T@gmail.com', '123')

        self.assertEqual(result, {"success": True, "user_id": 6})


    def testUserLoginErrorCase(self):
        self.mock_cursor.fetchone.return_value = None  # No user found

        result = backend.loginUser(None, None)

        self.assertEqual(result, {"success": False, "message": "Invalid email or password"})

        self.mock_cursor.execute.assert_called_once_with(
            'SELECT user_id FROM users WHERE user_email = %s AND user_password = %s',
            (None, None)
        )

        self.mock_cursor.reset_mock()
        
        result = backend.loginUser('wrong_email@gmail.com', 'wrong_password')

        self.assertEqual(result, {"success": False, "message": "Invalid email or password"})



class TestFetchQuizzes(unittest.TestCase):
    def setUp(self):
        self.mock_quizzes = [
            {"quiz_id": 1, "quiz_name": "Algebra Quiz 1"},
            {"quiz_id": 2, "quiz_name": "Algebra Quiz 2"},
            {"quiz_id": 3, "quiz_name": "Algebra Quiz 3"},
            {"quiz_id": 4, "quiz_name": "Ratio and Proportion Quiz 1"},
            {"quiz_id": 5, "quiz_name": "Ratio and Proportion Quiz 2"},
            {"quiz_id": 6, "quiz_name": "Ratio and Proportion Quiz 3"},
        ]

        self.patcher = patch('backend.generateQuiz', return_value=self.mock_quizzes)
        self.mock_generateQuiz = self.patcher.start()

    def tearDown(self):
        self.patcher.stop()

    def testGenerateQuizSuccess(self):
        quizzes = backend.generateQuiz()

        self.assertEqual(quizzes, self.mock_quizzes)
        
        for quiz in quizzes:
            self.assertIn("quiz_id", quiz)
            self.assertIn("quiz_name", quiz)
            self.assertIsInstance(quiz["quiz_id"], int)
            self.assertIsInstance(quiz["quiz_name"], str)

    def testGenerateQuizEmpty(self):
       
        self.mock_generateQuiz.return_value = []

      
        quizzes = backend.generateQuiz()

        self.assertEqual(quizzes, [])

    def testGenerateQuizNullValues(self):
        self.mock_generateQuiz.return_value = [
            {"quiz_id": None, "quiz_name": None},
            {"quiz_id": 2, "quiz_name": "Algebra Quiz 1"},
        ]

        quizzes = backend.generateQuiz()
        
        
        self.assertEqual(quizzes, [
            {"quiz_id": None, "quiz_name": None},
            {"quiz_id": 2, "quiz_name": "Algebra Quiz 1"},
        ])

        for quiz in quizzes:
            self.assertIn("quiz_id", quiz)
            self.assertIn("quiz_name", quiz)
            self.assertIsInstance(quiz["quiz_id"], (int, type(None)))
            self.assertIsInstance(quiz["quiz_name"], (str, type(None)))


class TestFetchQuestionsAndAnswers(unittest.TestCase):
    def setUp(self):
        # Mock data for questions and answers
        self.mockQuestionsAndAnswers = [
            {
                "question_id": 1,
                "question_text": "What is 2+2?",
                "answers": [
                    {"answer_id": 1, "answer_text": "4"},
                    {"answer_id": 2, "answer_text": "3"},
                    {"answer_id": 3, "answer_text": "5"},
                ],
            },
            {
                "question_id": 2,
                "question_text": "What is the capital of France?",
                "answers": [
                    {"answer_id": 4, "answer_text": "Paris"},
                    {"answer_id": 5, "answer_text": "London"},
                ],
            },
        ]

        # Mock data for an empty response
        self.mockEmptyQuestionsAndAnswers = []

        # Patch the `fetchQuestionsAndAnswers` function
        self.patcher = patch('backend.fetchQuestionsAndAnswers', return_value=self.mockQuestionsAndAnswers)
        self.mockFetchQuestionsAndAnswers = self.patcher.start()

    def testFetchQuestionsAndAnswers(self):
        # Expected data
        expectedQuestionsAndAnswers = [
            {
                "question_id": 1,
                "question_text": "What is 2+2?",
                "answers": [
                    {"answer_id": 1, "answer_text": "4"},
                    {"answer_id": 2, "answer_text": "3"},
                    {"answer_id": 3, "answer_text": "5"},
                ],
            },
            {
                "question_id": 2,
                "question_text": "What is the capital of France?",
                "answers": [
                    {"answer_id": 4, "answer_text": "Paris"},
                    {"answer_id": 5, "answer_text": "London"},
                ],
            },
        ]

        # Call the function
        questionsAndAnswers = backend.fetchQuestionsAndAnswers(quiz_id=1)

        # Assert the result matches the expected data
        self.assertEqual(questionsAndAnswers, expectedQuestionsAndAnswers)

        # Assert that the returned list is not empty
        self.assertTrue(len(questionsAndAnswers) > 0, "The returned list is empty")

        # Validate the structure of each question and its answers
        for question in questionsAndAnswers:
            self.assertIn("question_id", question)
            self.assertIn("question_text", question)
            self.assertIn("answers", question)
            self.assertIsInstance(question["question_id"], int)
            self.assertIsInstance(question["question_text"], str)
            self.assertIsInstance(question["answers"], list)

            for answer in question["answers"]:
                self.assertIn("answer_id", answer)
                self.assertIn("answer_text", answer)
                self.assertIsInstance(answer["answer_id"], int)
                self.assertIsInstance(answer["answer_text"], str)

    def testFetchQuestionsAndAnswersEmpty(self):
        # Patch the function to return an empty list
        with patch('backend.fetchQuestionsAndAnswers', return_value=self.mockEmptyQuestionsAndAnswers):
            questionsAndAnswers = backend.fetchQuestionsAndAnswers(quiz_id=1)

            # Assert the result is an empty list
            self.assertEqual(questionsAndAnswers, [])
            self.assertTrue(len(questionsAndAnswers) == 0, "The returned list is not empty")

    def tearDown(self):
        # Stop the patcher
        self.patcher.stop()


class TestFetchLeaderboard(unittest.TestCase):

    def setUp(self):
        self.mock_conn = MagicMock()
        self.mock_cur = MagicMock()
        self.mock_getconn_patcher = patch('backend.connection_pool.getconn', return_value=self.mock_conn)
        self.mock_putconn_patcher = patch('backend.connection_pool.putconn')
        self.mock_conn.cursor.return_value = self.mock_cur
        self.mock_getconn = self.mock_getconn_patcher.start()
        self.mock_putconn = self.mock_putconn_patcher.start()

    def tearDown(self):
        self.mock_getconn_patcher.stop()
        self.mock_putconn_patcher.stop()

    @patch('builtins.open', new_callable=mock_open)
    @patch('json.dump')
    def test_fetch_leaderboard_success(self, mock_json_dump, mock_file_open):
        """
        Test successful fetching of leaderboard data and writing to JSON.
        """
        # Mock database results
        db_rows = [
            ("UserA", 500),
            ("UserB", 450),
            ("UserC", 300)
        ]
        self.mock_cur.fetchall.return_value = db_rows
        
        expected_leaderboard = [
            {"name": "UserA", "score": 500},
            {"name": "UserB", "score": 450},
            {"name": "UserC", "score": 300}
        ]

        # Call the function
        result = backend.fetchLeaderboard()

        # Assertions
        self.mock_getconn.assert_called_once()
        self.mock_cur.execute.assert_called_once_with(
            '''SELECT u.user_name, sp.total_points
                        FROM users u
                        JOIN student_progress sp ON u.user_id = sp.user_id
                        ORDER BY sp.total_points DESC;'''
        )
        self.assertEqual(result, expected_leaderboard)
        
        mock_file_open.assert_called_with("leaderboard.json", "w", encoding="utf-8")

        mock_json_dump.assert_called_once_with(expected_leaderboard, mock_file_open(), ensure_ascii=False, indent=4)
        
        self.mock_cur.close.assert_called_once()
        self.mock_putconn.assert_called_once_with(self.mock_conn)


    @patch('builtins.print')
    def test_fetch_leaderboard_db_error(self, mock_print):
        """
        Test leaderboard fetching when a database error occurs.
        """
        self.mock_getconn.side_effect = Exception("Database connection error")

        result = backend.fetchLeaderboard()

        self.assertEqual(result, [])
        mock_print.assert_called_once_with("Error fetching leaderboard:", "Database connection error")

    @patch('builtins.open', new_callable=mock_open)
    @patch('json.dump')
    @patch('builtins.print')
    def test_fetch_leaderboard_file_write_error(self, mock_print, mock_json_dump, mock_file_open):
        """
        Test leaderboard fetching when writing to JSON file fails.
        """
        self.mock_cur.fetchall.return_value = [("UserA", 100)]
        mock_json_dump.side_effect = IOError("Failed to write file")

        expected_leaderboard = [{"name": "UserA", "score": 100}]
        result = backend.fetchLeaderboard()

        self.assertEqual(result, expected_leaderboard)
        mock_print.assert_called_once_with("Error fetching leaderboard:", "Failed to write file")


class TestFetchProfile(unittest.TestCase):

    def setUp(self):
        self.mock_conn = MagicMock()
        self.mock_cur = MagicMock()
        self.mock_getconn_patcher = patch('backend.connection_pool.getconn', return_value=self.mock_conn)
        self.mock_putconn_patcher = patch('backend.connection_pool.putconn')
        self.mock_conn.cursor.return_value = self.mock_cur
        self.mock_getconn = self.mock_getconn_patcher.start()
        self.mock_putconn = self.mock_putconn_patcher.start()

    def tearDown(self):
        self.mock_getconn_patcher.stop()
        self.mock_putconn_patcher.stop()

    def test_fetch_profile_success(self):
        user_id = 1
        db_row = ("TestUser", "test@example.com", 120)
        self.mock_cur.fetchone.return_value = db_row

        expected_profile = {"name": "TestUser", "email": "test@example.com", "score": 120}
        
        result = backend.fetchProfile(user_id)

        self.mock_cur.execute.assert_called_once_with(
            '''SELECT u.user_name, u.user_email, sp.total_points
                        FROM users u
                        JOIN student_progress sp ON u.user_id = sp.user_id
                        WHERE u.user_id = %s;''', (user_id,)
        )
        self.assertEqual(result, expected_profile)
        self.mock_cur.close.assert_called_once()
        self.mock_putconn.assert_called_once_with(self.mock_conn)

    def test_fetch_profile_not_found(self):
        self.mock_cur.fetchone.return_value = None 

        user_id = 999
        result = backend.fetchProfile(user_id)

        self.assertIsNone(result)

    def test_fetch_profile_db_error(self):
        """
        Test profile fetching when a database error occurs.
        """
        self.mock_getconn.side_effect = Exception("DB Error")
        user_id = 1
        result = backend.fetchProfile(user_id)

        self.assertIsNone(result)

    def test_fetch_profile_malformed_data(self):
        """
        Test profile fetching when database returns malformed row (e.g. too few elements).
        """
        user_id = 1
        db_row = ("TestUser", )
        self.mock_cur.fetchone.return_value = db_row
        
        result = backend.fetchProfile(user_id)
        self.assertIsNone(result)

class TestUpdateLevel(unittest.TestCase):

    def setUp(self):
        self.mock_conn = MagicMock()
        self.mock_cur = MagicMock()
        self.mock_getconn_patcher = patch('backend.connection_pool.getconn', return_value=self.mock_conn)
        self.mock_putconn_patcher = patch('backend.connection_pool.putconn')
        self.mock_conn.cursor.return_value = self.mock_cur
        self.mock_getconn = self.mock_getconn_patcher.start()
        self.mock_putconn = self.mock_putconn_patcher.start()
        self.mock_conn.commit = MagicMock()  # Mock commit
        self.mock_conn.rollback = MagicMock() # Mock rollback

    def tearDown(self):
        self.mock_getconn_patcher.stop()
        self.mock_putconn_patcher.stop()

    def test_update_level_no_level_increase(self):
        """
        Test updating score without a level increase.
        """
        user_id = 1
        score_achieved = 50
        current_progress_db = (10, 0) 
        self.mock_cur.fetchone.return_value = current_progress_db

        expected_new_total_points = 10 + 50 # 60
        expected_new_user_level = 60 // 100 # 0
        
        result = backend.updateLevel(user_id, score_achieved)

        self.mock_cur.execute.assert_any_call(
            'SELECT total_points, user_level FROM student_progress WHERE user_id = %s FOR UPDATE;', (user_id,)
        )
        self.mock_cur.execute.assert_any_call(
            'UPDATE student_progress SET total_points = %s, user_level = %s WHERE user_id = %s;',
            (expected_new_total_points, expected_new_user_level, user_id)
        )
        self.mock_conn.commit.assert_called_once()
        self.assertEqual(result, {
            "success": True,
            "message": "Score and level updated successfully.",
            "new_total_points": expected_new_total_points,
            "new_user_level": expected_new_user_level,
            "level_increased": False
        })
        self.mock_cur.close.assert_called_once()
        self.mock_putconn.assert_called_once_with(self.mock_conn)

    def test_update_level_with_level_increase(self):
        """
        Test updating score with a level increase.
        """
        user_id = 2
        score_achieved = 70
        current_progress_db = (80, 0)
        self.mock_cur.fetchone.return_value = current_progress_db

        expected_new_total_points = 80 + 70
        expected_new_user_level = 150 // 100
        
        result = backend.updateLevel(user_id, score_achieved)

        self.assertEqual(result, {
            "success": True,
            "message": "Score and level updated successfully.",
            "new_total_points": expected_new_total_points,
            "new_user_level": expected_new_user_level,
            "level_increased": True
        })
        self.mock_conn.commit.assert_called_once()


    def test_update_level_user_not_found(self):
        """
        Test updating level for a user whose progress is not found.
        """
        self.mock_cur.fetchone.return_value = None

        user_id = 999
        score_achieved = 10
        
        result = backend.updateLevel(user_id, score_achieved)

        self.assertEqual(result, {"success": False, "message": "User progress not found."})
        self.mock_conn.commit.assert_not_called()


    def test_update_level_db_error_on_fetch(self):
        """
        Test update level when fetching current progress fails.
        """
        self.mock_cur.execute.side_effect = Exception("Fetch DB Error")

        user_id = 1
        score_achieved = 10
        
        result = backend.updateLevel(user_id, score_achieved)

        self.assertEqual(result, {"success": False, "message": "Failed to update score and level."})
        self.mock_conn.rollback.assert_called_once()

    def test_update_level_db_error_on_update(self):
        """
        Test update level when updating progress in DB fails.
        """
        user_id = 1
        score_achieved = 10
        current_progress_db = (10, 0)
        self.mock_cur.execute.side_effect = [None, Exception("Update DB Error")] 
        self.mock_cur.fetchone.return_value = current_progress_db
        
        result = backend.updateLevel(user_id, score_achieved)

        self.assertEqual(result, {"success": False, "message": "Failed to update score and level."})
        self.mock_conn.rollback.assert_called_once()


class TestUserLevel(unittest.TestCase):

    def setUp(self):
        self.mock_conn = MagicMock()
        self.mock_cur = MagicMock()
        self.mock_getconn_patcher = patch('backend.connection_pool.getconn', return_value=self.mock_conn)
        self.mock_putconn_patcher = patch('backend.connection_pool.putconn')
        self.mock_conn.cursor.return_value = self.mock_cur
        self.mock_getconn = self.mock_getconn_patcher.start()
        self.mock_putconn = self.mock_putconn_patcher.start()

    def tearDown(self):
        self.mock_getconn_patcher.stop()
        self.mock_putconn_patcher.stop()

    def test_user_level_success(self):
        """
        Test successfully fetching a user's level.
        """
        user_id = 1
        db_level = (2,)
        self.mock_cur.fetchone.return_value = db_level

        expected_response = {"success": True, "user_level": 2}
        result = backend.userLevel(user_id)

        self.mock_cur.execute.assert_called_once_with(
            'SELECT user_level FROM student_progress WHERE user_id = %s;', (user_id,)
        )
        self.assertEqual(result, expected_response)
        self.mock_cur.close.assert_called_once()
        self.mock_putconn.assert_called_once_with(self.mock_conn)

    def test_user_level_not_found(self):
        """
        Test fetching level for a user that does not exist.
        """
        self.mock_cur.fetchone.return_value = None

        user_id = 999
        expected_response = {"success": False, "user_level": "This user does not exist"}
        result = backend.userLevel(user_id)
        
        self.assertEqual(result, expected_response)

    @patch('builtins.print')
    @patch('backend.connection_pool.getconn')
    def test_user_level_db_error(self, mock_getconn, mock_print):
        """
        Test fetching user level when a database error occurs.
        """
        mock_conn = MagicMock()
        mock_cur = MagicMock()
        mock_getconn.return_value = mock_conn
        mock_conn.cursor.return_value = mock_cur
        mock_cur.execute.side_effect = Exception("DB Error on cursor")

        user_id = 1
        result = backend.userLevel(user_id)
        mock_print.assert_called_once_with("There is an error while fetching the user's level:", ANY)
        actual_call_args = mock_print.call_args[0]
        self.assertIsInstance(actual_call_args[1], Exception)
        self.assertEqual(str(actual_call_args[1]), "DB Error on cursor")    
        self.assertEqual(result, {"success": False, "user_level": None})

if __name__ == "__main__":
    unittest.main(argv=['first-arg-is-ignored'], exit=False)
