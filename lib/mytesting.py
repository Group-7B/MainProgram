import unittest
from unittest.mock import MagicMock, patch
from backend import fetchSubjects, fetchTopics,createAccount

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
        #self.mock_cursor.fetchone.return_value = [12]
        #self.mock_cursor.execute_side_effect = [None,None]
        self.mock_cursor.execute.side_effect = Exception("Database Error")
        
        with self.assertRaises(Exception) as ctx:
            createAccount(user_name=None, user_last_name=None, user_email=None, user_password=None)
            createAccount(user_name="dummy", user_last_name="Test", user_email="dummyTest@outlook.com", user_password="123")
        
    def tearUp(self):
        self.patcher_getconn.stop()
        self.patcher_putconn.stop()
        
    
    

#class TestLogin(unittest.TestCase):
    
    #def setUp(self):
        
        
        
            


if __name__ == "__main__":
    unittest.main()









'''import unittest
from unittest.mock import MagicMock, patch
from backend import fetchSubjects, fetchTopics

class TestFetchSubjects(unittest.TestCase):
    

    def testFetchSubjectsSuccess(self):
        # Mock rows returned by the database
        rows = [
            (1, "Mathematics"),
            (2, "English"),
            (3, "Physics"),
            (4, "Operating systems"),
        ]

        # Expected result after processing
        expected = [
            {"subject_id": 1, "subject_name": "Mathematics"},
            {"subject_id": 2, "subject_name": "English"},
            {"subject_id": 3, "subject_name": "Physics"},
            {"subject_id": 4, "subject_name": "Operating systems"},
        ]

        # Mock the database connection and cursor
        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_cursor.fetchall.return_value = rows

        # Patch the connection pool to return the mocked connection
        with patch("backend.connection_pool.getconn", return_value=mock_conn), \
             patch("backend.connection_pool.putconn") as mock_putconn:
            result = fetchSubjects()

            # Assert that the mocked connection was returned to the pool
            mock_putconn.assert_called_once_with(mock_conn)

        # Assert that the result matches the expected output
        self.assertEqual(result, expected)

    def testFetchSubjectsEmptyTable(self):
        # Mock rows returned by the database (empty table)
        rows = []

        # Expected result after processing
        expected = []

        # Mock the database connection and cursor
        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_cursor.fetchall.return_value = rows

        # Patch the connection pool to return the mocked connection
        with patch("backend.connection_pool.getconn", return_value=mock_conn), \
             patch("backend.connection_pool.putconn") as mock_putconn:
            result = fetchSubjects()

            # Assert that the mocked connection was returned to the pool
            mock_putconn.assert_called_once_with(mock_conn)

        # Assert that the result matches the expected output
        self.assertEqual(result, expected)

    def testFetchSubjectsDatabaseError(self):
        # Mock the database connection to raise an exception
        mock_conn = MagicMock()
        mock_conn.cursor.side_effect = Exception("Database error")

        # Patch the connection pool to return the mocked connection
        with patch("backend.connection_pool.getconn", return_value=mock_conn), \
             patch("backend.connection_pool.putconn") as mock_putconn:
            result = fetchSubjects()

            # Assert that the mocked connection was returned to the pool
            mock_putconn.assert_called_once_with(mock_conn)

        # Assert that the result is an empty list when an exception occurs
        self.assertEqual(result, [])
        
class TestFetchTopics(unittest.TestCase):
    def testFetchTopics(self):
        rows = [
            (1,1,"Algebra"),
            (1,2,"Ratio and Proportion"),
            (1,3,"Persentage"),
            (2,4,"Vocabulary"),
            (2,5,"Grammar"),
            (3,6,"Mechanics"),
            (3,7,"Thermodynamics"),
            (3,8,"Electromagnetism"),
            (4,9,"Memory management"),
            (4,10,"Process management"),
            (4,11,"File management"),
            ]
        
        expectedTopics = [
            {"topic_id": 1, "topic_name": "Algebra"},
            {"topic_id": 2, "topic_name": "Ratio and Proportion"},
            {"topic_id": 3, "topic_name": "Persentage"},
            {"topic_id": 4, "topic_name": "Vocabulary"},
            {"topic_id": 5, "topic_name": "Grammar"},
            {"topic_id": 6, "topic_name": "Mechanics"},
            {"topic_id": 7, "topic_name": "Thermodynamics"},
            {"topic_id": 8, "topic_name": "Electromagnetism"},
            {"topic_id": 9, "topic_name": "Memory management"},
            {"topic_id": 10, "topic_name": "Process management"},
            {"topic_id": 11, "topic_name": "File management"},   
        ]
        
        
        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_cursor.fetchall.return_value = rows
        
        with patch("backend.connection_pool.getconn", return_value=mock_conn), \
             patch("backend.connection_pool.putconn") as mock_putconn:
                 for i in range(1,12):
                     result = fetchTopics(i)
                     self.assertEqual(result,expectedTopics)
        
        
        
if __name__ == "__main__":
    unittest.main()'''