import unittest
from unittest.mock import patch, MagicMock
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
        

        
if __name__ == "__main__":
    unittest.main()
        