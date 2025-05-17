import unittest
from unittest.mock import patch, MagicMock, mock_open, ANY
import json
import backend

class TestFetchSubjects(unittest.TestCase):
    
    def setUp(self):
        self.mockSubjects = [
            {"subject_id": 1, "subject_name": "Mathematics"},
            {"subject_id": 2, "subject_name": "English"},
            {"subject_id": 3, "subject_name": "Physics"},
            {"subject_id": 4, "subject_name": "Operating systems"}, 
        ]
        
        
        self.mockSubjectsErrorCase = [
            {"subject_id": 1, "subject_name":"Mathematics"},
            {"subject_id":2,"subject_name":"English"}
            ]
        
        self.mockSubjectsErrorCase2 = []
        
        self.patcher = patch('backend.fetchSubjects', return_value = self.mockSubjects)
        self.patcher.start()
        
    def testFetchSubjects(self):
        expectedSubjects = [
            {"subject_id": 1, "subject_name": "Mathematics"},
            {"subject_id": 2, "subject_name": "English"},
            {"subject_id": 3, "subject_name": "Physics"},
            {"subject_id": 4, "subject_name": "Operating systems"},
        ]
        
        self.assertEqual(backend.fetchSubjects(),expectedSubjects)
        self.assertTrue(len(backend.fetchSubjects())>0, "The returned list is empty")
        self.assertGreater(len(backend.fetchSubjects()),0,"The returned list is empty")
        
        for subject in backend.fetchSubjects():
            self.assertIsInstance(subject["subject_id"],int)
            self.assertIsInstance(subject["subject_name"],str)
    
    def testFetchSubjectsErrorCase(self):
        nullCheck = []
        with patch('backend.fetchSubjects',return_value = self.mockSubjectsErrorCase):
            expectedSubjects2 = [
                {"subject_id": 1, "subject_name": "Mathematics"},
                {"subject_id": 2, "subject_name": "English"},
                {"subject_id": 3, "subject_name": "Physics"},
                {"subject_id": 4, "subject_name": "Operating systems"},
            ]
            
            self.assertNotEqual(backend.fetchSubjects(),expectedSubjects2)
            
            #self.assertEqual(backend.fetchSubjects(),[],"The returned list is not empty")
            #self.assertTrue(len(backend.fetchSubjects()) == 0, "The returned list is not empty")
    
    def testEmptyList(self):
        with patch('backend.fetchSubjects',return_value = self.mockSubjectsErrorCase2):
            nullCheck = []
            
            self.assertEqual(backend.fetchSubjects(),nullCheck,"The returned list is empty. Failed to fetch subjects data from database.")
        
        
    def tearDown(self):
        self.patcher.stop()
        
        
#############################
# TOPICS UNIT TEST BELOW:
##################################        

class TestFetchTopics(unittest.TestCase):
    def setUp(self):
        self.mockTopics = [
                {"topic_id": 1, "topic_name": "Algebra", "subject_id": 1},
                {"topic_id": 2, "topic_name": "Ratio and Proportions","subject_id": 1},
                {"topic_id": 3, "topic_name": "Percentage", "subject_id": 1},
                {"topic_id": 4, "topic_name": "Vocabulary","subject_id": 2},
                {"topic_id": 5, "topic_name": "Grammar","subject_id": 2},
                {"topic_id": 6, "topic_name": "Mechanics","subject_id": 3},
                {"topic_id": 7, "topic_name": "Thermodynamics","subject_id": 3},
                {"topic_id": 8, "topic_name": "Electromagnetism","subject_id": 3},
                {"topic_id": 9, "topic_name": "Memory management","subject_id": 4},
                {"topic_id": 10, "topic_name": "Process management","subject_id": 4},
                {"topic_id": 11, "topic_name": "File management","subject_id": 4},
            ]
        
        #self.patcher = patch('backend.fetchTopics',return_value = self.mock_topics)
        #self.mock_fetchTopics = self.patcher.start()
        
        
        def mockFetchTopics(subject_id):
            return [topic for topic in self.mockTopics if topic["subject_id"] == subject_id]
        
        self.patcher = patch('backend.fetchTopics',side_effect = mockFetchTopics)
        self.mockFetchTopics = self.patcher.start()
        
        
        
##################################################################################################################################################################################################################################################
        #self.mock_conn = MagicMock() #Replace the 2 objects conn and cur to mock the database connection
        #self.mock_cur = MagicMock()
        
        #self.mock_conn.cur.return_value = self.mock_cur
        #self.mock_cur.fetchall.return_value = self.mock_topics
        
        #self.getconn_patcher = patch('backend.connection_pool.getconn', return_value = self.mock_conn)
        #self.mock_getconn = self.getconn_patcher.start()
        
        #self.putconn_patcher = patch('backend.connection_pool.putconn')
        #self.mock_putconn = self.putconn_patcher.start()
    
    def testFetchTopics(self):        
        #topics = fetchTopics(subject_id=self.foreignKey())
        nullCheck = []
        
        for subject_id in range(0,5):        
            expectedTopics = [topic for topic in self.mockTopics if topic["subject_id"] == subject_id]
        
        topics = backend.fetchTopics(subject_id=subject_id)
        
        self.assertEqual(topics,expectedTopics)
        
        for topic in topics:
            self.assertIsInstance(topic["topic_id"], int)
            self.assertIsInstance(topic["topic_name"], str)
            self.assertEqual(topic["subject_id"], subject_id)
            
#####################################################################################################################################################################################################################################################################################
        #self.assertEqual(topics,expected_topics)
        #for topic in topics:
            #self.assertIsInstance(topic["topic_id"],int)
        
    
    def tearUp(self):
        self.patcher.stop()
        #self.getconn_patcher.stop() #Stop the patch
        #self.putconn_patcher.stop() #Stop the patch
        
    
class TestGenerateQuizzes(unittest.TestCase):
    def setUp(self):
        # IN FORMAT OF QUIZ_ID, QUIZ_NAME, TOPIC_ID AND TOPIC_NAME
        self.mock_quizzes = [
            {"quiz_id": 1, "quiz_name": "Algebra Quiz 1"},
            {"quiz_id": 2, "quiz_name": "Algebra Quiz 2"},
            {"quiz_id": 3, "quiz_name": 'Algebra Quiz 3'},
            {"quiz_id": 4, "quiz_name": "Ratio and Proportion Quiz 1"},
            {"quiz_id": 5, "quiz_name": "Ratio and Proportion Quiz 2"},
            {"quiz_id": 6, "quiz_name": "Ratio and Proportion Quiz 3"},
            {"quiz_id": 7, "quiz_name": "Percentage Quiz 1"},
            {"quiz_id": 8, "quiz_name": "Percentage Quiz 2"},
            {"quiz_id": 9, "quiz_name": "Percentage Quiz 3"},
            {"quiz_id": 10, "quiz_name": "Vocabulary Quiz 1"},
            {"quiz_id": 11, "quiz_name": "Vocabulary Quiz 2"},
            {"quiz_id": 12, "quiz_name": "Vocabulary Quiz 3"},
            {"quiz_id": 13, "quiz_name": "Grammar Quiz 1"},
            {"quiz_id": 14, "quiz_name": "Grammar Quiz 2"},
            {"quiz_id": 15, "quiz_name": "Grammar Quiz 3"},
            {"quiz_id": 16, "quiz_name": "Mechanics Quiz 1"},
            {"quiz_id": 17, "quiz_name": "Mechanics Quiz 2"},
            {"quiz_id": 18, "quiz_name": "Mechanics Quiz 3"},
            {"quiz_id": 19, "quiz_name": "Thermodynamics quiz 1"},
            {"quiz_id": 20, "quiz_name": "Thermodynamics quiz 2"},
            {"quiz_id": 21, "quiz_name": "Thermodynamics quiz 3"},
            {"quiz_id": 22, "quiz_name": "Electromagnetism quiz 1"},
            {"quiz_id": 23, "quiz_name": "Electromagnetism quiz 2"},
            {"quiz_id": 24, "quiz_name": "Electromagnetism quiz 3"},
            {"quiz_id": 25, "quiz_name": "Memory Management Quiz 1"},
            {"quiz_id": 26, "quiz_name": "Memory Management Quiz 2"},
            {"quiz_id": 27, "quiz_name": "Memory Management Quiz 3"},
            {"quiz_id": 28, "quiz_name": "Process Management Quiz 1"},
            {"quiz_id": 29, "quiz_name": "Process Management Quiz 2"},
            {"quiz_id": 30, "quiz_name": "Process Management Quiz 3"},
            {"quiz_id": 31, "quiz_name": "File Management quiz 1"},
            {"quiz_id": 32, "quiz_name": "File Management quiz 2"},
            {"quiz_id": 33, "quiz_name": "File Management Quiz 3"},
            
            ]
        self.patcher = patch('backend.generateQuiz', return_value = self.mock_quizzes)
        self.mock_generateQuizzes = self.patcher.start()
        
    def testGenerateQuizzes(self):
        
        nullCheck = []
        
        expectedQuizzes = [
            {"quiz_id": 1, "quiz_name": "Algebra Quiz 1"},
            {"quiz_id": 2, "quiz_name": "Algebra Quiz 2"},
            {"quiz_id": 3, "quiz_name": 'Algebra Quiz 3'},
            {"quiz_id": 4, "quiz_name": "Ratio and Proportion Quiz 1"},
            {"quiz_id": 5, "quiz_name": "Ratio and Proportion Quiz 2"},
            {"quiz_id": 6, "quiz_name": "Ratio and Proportion Quiz 3"},
            {"quiz_id": 7, "quiz_name": "Percentage Quiz 1"},
            {"quiz_id": 8, "quiz_name": "Percentage Quiz 2"},
            {"quiz_id": 9, "quiz_name": "Percentage Quiz 3"},
            {"quiz_id": 10, "quiz_name": "Vocabulary Quiz 1"},
            {"quiz_id": 11, "quiz_name": "Vocabulary Quiz 2"},
            {"quiz_id": 12, "quiz_name": "Vocabulary Quiz 3"},
            {"quiz_id": 13, "quiz_name": "Grammar Quiz 1"},
            {"quiz_id": 14, "quiz_name": "Grammar Quiz 2"},
            {"quiz_id": 15, "quiz_name": "Grammar Quiz 3"},
            {"quiz_id": 16, "quiz_name": "Mechanics Quiz 1"},
            {"quiz_id": 17, "quiz_name": "Mechanics Quiz 2"},
            {"quiz_id": 18, "quiz_name": "Mechanics Quiz 3"},
            {"quiz_id": 19, "quiz_name": "Thermodynamics quiz 1"},
            {"quiz_id": 20, "quiz_name": "Thermodynamics quiz 2"},
            {"quiz_id": 21, "quiz_name": "Thermodynamics quiz 3"},
            {"quiz_id": 22, "quiz_name": "Electromagnetism quiz 1"},
            {"quiz_id": 23, "quiz_name": "Electromagnetism quiz 2"},
            {"quiz_id": 24, "quiz_name": "Electromagnetism quiz 3"},
            {"quiz_id": 25, "quiz_name": "Memory Management Quiz 1"},
            {"quiz_id": 26, "quiz_name": "Memory Management Quiz 2"},
            {"quiz_id": 27, "quiz_name": "Memory Management Quiz 3"},
            {"quiz_id": 28, "quiz_name": "Process Management Quiz 1"},
            {"quiz_id": 29, "quiz_name": "Process Management Quiz 2"},
            {"quiz_id": 30, "quiz_name": "Process Management Quiz 3"},
            {"quiz_id": 31, "quiz_name": "File Management quiz 1"},
            {"quiz_id": 32, "quiz_name": "File Management quiz 2"},
            {"quiz_id": 33, "quiz_name": "File Management Quiz 3"},
            ]
        
        quizzes = backend.generateQuiz()
        
        self.assertEqual(quizzes,expectedQuizzes)
        
        for quiz in backend.generateQuiz:
            self.assertIn("quiz_id",quiz)
            self.assertIn("quiz_name",quiz)
            self.assertIsInstance(quizzes["quiz_id"], int)
            self.assertIsInstance(quizzes["quiz_name"], str)
            
        
    def tearUp(self):
        self.patcher.stop()
        
class TestLogin(unittest.TestCase):
    def setUp(self):
        self.mock_login = {"success":True,"user_id":1} # we are expecting the login of a user's account which has a unique user_id to either be successful or unsuccessful.
        
        #self.mock_login = [{"user_email":"T@gmail.com","password": "123" },]
        self.patcher = patch('backend.loginUser',return_value = self.mock_login)
        self.patcher.start()
    
    def testUserLogin(self):
        #dummyLogins = [{"user_email":"T@gmail.com", "password": "123"},]
        result = backend.loginUser('T@gmail.com','123')
        self.assertEqual(result,self.mock_login)
        
    def tearUp(self):
        self.patcher.stop()

class TestRegister(unittest.TestCase):
    def setUp(self):
        self.mock_register = [{"user_id":12, "message": "Account created successfully"}]
        
        self.patcher = patch('backend.createAccount',return_value = self.mock_register)
        self.patcher.start()
        
        
    def testCreateAccount(self):
        #successCase = [{"user_id":12,"message": "Account created successfully"}]
        self.userLevelPointsCheck = [{}] # TEST TO CHECK IF USER_LEVEL AND TOTAL_POINTS IN STUDENT_PROGRESS TABLE IS BOTH BY DEFAULT 0 UPON CREATION OF A NEW ACCOUNT
        
        createAccount = backend.createAccount(user_name="dummy", user_last_name="Test", email="dummyTest@outlook.com", password="123")
        
        self.assertEqual(createAccount,self.mock_register)
        x = self.assertEqual(createAccount,self.mock_register)
        if x == True:
            print("Account successfully created")
        
        
    def tearUp(self):
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