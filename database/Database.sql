---learning App database 


---CREATE DATABASE quizz

--- CREATE user table 

CREATE TABLE users(
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(50) NOT NULL,
    user_last_name VARCHAR(50) NOT NULL,
    user_email VARCHAR(100) UNIQUE NOT NULL ,
    user_password TEXT NOT NULL,
    join_date TIMESTAMP 
);


--CREATE TABLE Subjects
CREATE TABLE  subjects(
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(20),
    subject_description TEXT
);

INSERT INTO
  subjects(subject_name, subject_description)
VALUES

---id_1
  ('Mathematics',
    'Mathematics is the study of numbers, 
 shapes and patterns. The word comes from the Greek word "μάθημα" (máthema), 
 meaning "science, knowledge, or learning", and is sometimes shortened to maths 
 in England, Australia, Ireland, and New Zealand) or math (in the United States and Canada)'
  ),
  --id_2
    ('English',
    'English is a West Germanic language first spoken in early medieval England,    
which has become the leading language of international discourse in the 21st century.
It is named after the Angles, one of the ancient Germanic peoples that migrated to the area 
of Great Britain that later took their name, England.'
  ),
  --id_3
  ('Physics',
    'Physics is the natural science that studies matter, its motion and behavior through 
.space and time, and the related entities of energy and force. Physics is one of the most fundamental 
scientific disciplines, and its main goal is to understand how the universe behaves.'
  ),

  --id_4
  ('Operating systems',
    'An operating system (OS) is system software that manages computer hardware,
 software resources, and provides common services for computer programs. Time-sharing operating 
 systems schedule tasks for efficient use of the system and may also include accounting software 
 for cost allocation of processor time, mass storage, printing, and other resources.'
  );


/*One topic can have many quizzes */
--CTEARE TABLE FOR TOPICS
CREATE TABLE topics(
    topic_id SERIAL PRIMARY KEY,
    subject_id INT,  --FOREIGN KEY
    topic_name VARCHAR(20),
    topic_description TEXT,    
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);


--insert into topics
INSERT INTO
  topics(subject_id,topic_name, topic_description)
VALUES

---id_1 Math
    (1, 'Algebra',
        'Algebra is a branch of mathematics dealing with symbols and the rules for manipulating those symbols.
            In elementary algebra, those symbols (today written as Latin and Greek letters) represent quantities without fixed values, known as variables. 
            This is useful because it lets us write general statements (such as x + y = y + x) without having to plug in specific values for x and y. 
            In advanced algebra, those symbols represent numbers, and the rules are about which operations can be performed on those numbers.' ),
  --id_2
  (1,'Ratio and Proportion',
    'Ratio and proportion are two concepts that are closely related to each other.
 A ratio is a comparison of two numbers or measurements, while a proportion is an equation that states 
 that two ratios are equal. Ratios and proportions are used in many real-life situations to compare 
 quantities and to predict outcomes.'),
  --ID_3
  (1,'Persentage',
    'Percentage is a number or ratio expressed as a fraction of 100. It is often 
denoted using the percent sign, "%", 
 or the abbreviation "pct." For example, 45% (read as "forty-five percent") is
  equal to 45/100, or 0.45.'),



  --id_4 english
  (2,'Vocabulary',
    'Vocabulary refers to the words we must understand to communicate effectively.
 Educated people have a wide vocabulary.'),

  --id_5
    ( 2,'Grammar',
    'Grammar is the system of a language. People sometimes describe grammar as the "rules" 
of a language; but in fact no language has rules.        
If we use the word "rules", we suggest that somebody created the rules first and then spoke the 
language, like a new game. But languages did not start like that. Languages started by people 
making sounds which evolved into words, phrases and sentences. No commonly-spoken language is fixed.
 All languages change over time. What we call "grammar" is simply a reflection of a 
 language at a particular time.' ),


 -- id_6 physics
 
  (3,'Mechanics',
    'Mechanics is the branch of Physics dealing with the study of motion when subjected to
 forces or displacements, and the subsequent effects of the bodies on their environment.'),

  --id_7
    (3,'Thermodynamics',
    'Thermodynamics is the branch of physics that deals with the relationships 
between heat and other forms of energy. In particular, it describes how thermal energy is 
converted to and from other forms of energy and how it affects matter.'),

    --id_8
  (3,'Electromagnetism',
    'Electromagnetism is a branch of physics involving the study of the 
electromagnetic force, a type of physical interaction that occurs between electrically charged 
particles. The electromagnetic force usually exhibits electromagnetic fields such as electric 
fields, magnetic fields, and light, and is one of the four fundamental interactions in nature.'),

-- id_9 operating systems
  (4,'Memory management',
    'Memory management is the process of controlling and coordinating computer memory,
 assigning portions called blocks to various running programs to optimize overall system performance. 
 Memory management operates in the following ways: It keeps track of each and every byte of memory, 
 either used or free. It indicates the status of each memory area, whether it is allocated, 
 deallocated, or available.'),

    --id_10
  (4,'Process management',
    'Process management is an integral part of any modern-day operating system (OS). 
The OS must allocate resources to processes, enable processes to share and exchange information,
 protect the resources of each process from other processes and enable synchronization among processes.
 Process management is an essential part of a multiprogramming operating system.' ),
  
    --id_11
  (4,'File management',
    'File management is the process of administering a system that correctly handles    
digital data. Therefore, an effective file management system improves the overall function of a business
    workflow. It also organizes important data and provides a searchable database for quick retrieval.' );



---CREATE ENIUM FOR QUIZ LEVEL
CREATE TYPE quiz_level AS ENUM('Easy', 'Medium', 'Hard');

---CREATE ENUM FOR QUIZ TYPE
CREATE TYPE quiz_type AS ENUM('quiz', 'MOCK Exam');

--CRETAE table for quizzes 
CREATE TABLE
  quizzes (
    quiz_id SERIAL PRIMARY KEY,
    subject_id INT, --FOREIGN KEY
    topic_id INT, --FOREIGN KEY
    quiz_name VARCHAR(60),
    quiz_type quiz_type NOT NULL,
    quiz_level quiz_level NOT NULL,
    FOREIGN KEY (topic_id) REFERENCES topics(topic_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
  );

--INSERT INTO QUIZZES
INSERT INTO
  quizzes(subject_id, topic_id, quiz_name, quiz_type, quiz_level)
VALUES
  (1, 1, 'Algebra Quiz 1', 'quiz', 'Easy'),  
  (1, 1, 'Algebra Quiz 2', 'quiz', 'Medium'),
  (1, 1, 'Algebra Quiz 3', 'quiz', 'Hard'),
  (1, 2, 'Ratio and Proportion Quiz 1', 'quiz', 'Easy'),
  (1, 2, 'Ratio and Proportion Quiz 2', 'quiz', 'Medium'),
  (1, 2, 'Ratio and Proportion Quiz 3', 'quiz', 'Hard'),
  (1, 3, 'Percentage Quiz 1', 'quiz', 'Easy'),
  (1, 3, 'Percentage Quiz 2', 'quiz', 'Medium'),
  (1, 3, 'Percentage Quiz 3', 'quiz', 'Hard'),

  --Math mock exam contain mixed questions from all topics
(1,NULL,'Math exam', 'MOCK Exam', 'Medium'),

  (2, 4, 'Vocabulary Quiz 1', 'quiz', 'Easy'),
  (2, 4, 'Vocabulary Quiz 2', 'quiz', 'Medium'),
  (2, 4, 'Vocabulary Quiz 3', 'quiz', 'Hard'),
  (2, 5, 'Grammar Quiz 1', 'quiz', 'Easy'),
  (2, 5, 'Grammar Quiz 2', 'quiz', 'Medium'),
  (2, 5, 'Grammar Quiz 3', 'quiz', 'Hard'),
  
  --English mock exam contain mixed questions from all topics
  (2,NULL,'English exam','MOCK Exam', 'Medium'),
  
  (3, 6, 'Mechanics Quiz 1', 'quiz', 'Easy'),
  (3, 6, 'Mechanics Quiz 2', 'quiz', 'Medium'),
  (3, 6, 'Mechanics Quiz 3', 'quiz', 'Hard'),
  (3, 7, 'Thermodynamics Quiz 1', 'quiz', 'Easy'),
  (3, 7, 'Thermodynamics Quiz 2', 'quiz', 'Medium'),
  (3, 7, 'Thermodynamics Quiz 3', 'quiz', 'Hard'),
  (3, 8, 'Electromagnetism Quiz 1', 'quiz', 'Easy'),
  (3, 8, 'Electromagnetism Quiz 2', 'quiz', 'Medium'),
  (3, 8, 'Electromagnetism Quiz 3', 'quiz', 'Hard'),

    --Physics mock exam contain mixed questions from all topics
    (3,NULL,'Physics exam','MOCK Exam', 'Medium'),

  (4, 9, 'Memory management Quiz 1', 'quiz', 'Easy'),
  (4, 9, 'Memory management Quiz 2', 'quiz', 'Medium'),
  (4, 9, 'Memory management Quiz 3', 'quiz', 'Hard'),
  (4, 10, 'Process management Quiz 1', 'quiz', 'Easy'),
  (4, 10, 'Process management Quiz 2', 'quiz', 'Medium'),
  (4, 10, 'Process management Quiz 3', 'quiz', 'Hard'),
  (4, 11, 'File management Quiz 1', 'quiz', 'Easy'),
  (4, 11, 'File management Quiz 2', 'quiz', 'Medium'),
  (4, 11, 'File management Quiz 3', 'quiz', 'Hard'),

  --Operating systems mock exam contain mixed questions from all topics
  (4,NULL,'Operating systems exam','MOCK Exam', 'Medium');  -- tested and work




---CREATE table for questions tested
CREATE TABLE  questions(
question_id SERIAL PRIMARY KEY,
topic_id INT, 
question_text TEXT,  
 points INT NOT NULL,
 question_level quiz_level NOT NULL,
 FOREIGN KEY (topic_id) REFERENCES topics(topic_id)
   );



--INSERT INTO QUESTIONS
-- topic_id 1 Algebra level easy questions easy
--question_id 1 -10
INSERT INTO questions(topic_id, question_text, points, question_level)
VALUES
  (1,'What is the value of x in the equation: x + 5 = 10?',1,'Easy'),
  (1,'Solve for x: 2x = 8',1,'Easy'),
  (1,'What is 5x - 3 = 7 when solved for x?',1,'Easy'),
  (1,'What is the next term in the pattern: 2, 4, 6, 8, __?',1,'Easy'),
  (1,'What is the simplified form of 3x + 4x?',1,'Easy'),
  (1,'If x = 3, what is the value of 2x + 5?',1,'Easy'),
  (1,'Which expression is equivalent to x * x?',1,'Easy'),
  (1,'If y = 10, what is y - 6?',1,'Easy'),
  (1,'Solve for x: x/2 = 6',1,'Easy'),
  (1,'What is the value of 3(x + 2) = 12?',1,'Easy'),-- tested and working

-- topic_id 1 Algebra level medium questions medium 
--question_id 11 - 20
  (1,'What is the value of x in the equation: 2x + 3 = 11?',2,'Medium'),
  (1,'Solve for x: 3x - 5 = 10',2,'Medium'),
  (1,'What is 4x - 3 = 13 when solved for x?',2,'Medium'),
  (1,'What is the next term in the pattern: 3, 6, 9, 12, __?',2,'Medium'),
  (1,'What is the simplified form of 4x + 5x?',2,'Medium'),
  (1,'If x = 4, what is the value of 3x + 6?',2,'Medium'),
  (1,'Which expression is equivalent to x * x * x?',2,'Medium'),
  (1,'If y = 15, what is y - 8?',2,'Medium'),
  (1,'Solve for x: x/3 = 7',2,'Medium'),
  (1,'What is the value of 4(x + 3) = 28?',2,'Medium'),-- tested and working

--topic_id =1,10 questions Math /Algebra /level Hard (id 21-30)
(1, 'Solve for x: 3x - 7 = 2x + 5', 3, 'Hard'),
(1, 'Factor completely: x^3 - 6x^2 + 11x - 6', 3, 'Hard'),
(1, 'Find the roots of the equation: 2x^2 - 5x - 3 = 0', 3, 'Hard'),
(1, 'Simplify: (2x - 3)(x + 4) - (x - 2)(x + 1)', 3, 'Hard'),
(1, 'Solve for x: (x + 2)/(x - 1) = (x - 3)/(x + 4)', 3, 'Hard'),
(1, 'Find the inverse function of f(x) = (3x - 4)/5', 3, 'Hard'),
(1, 'Determine the value of x in the system: 2x + 3y = 7 and 4x - y = 5', 3, 'Hard'),
(1, 'Solve the inequality: (x - 2)(x + 5) < 0', 3, 'Hard'),
(1, 'Evaluate the determinant of the matrix: | 2  -1 | | 3  4 |', 3, 'Hard'),
(1, 'Find the sum of the first 10 terms of the arithmetic sequence with first term 7 and common difference 3', 3, 'Hard'); -- tested and working


--10 questions Math /Ratio and Proportion /level Easy (id 31-40)
--10 questions Math /Ratio and Proportion /level Medium (id 41-50)
--10 questions Math /Ratio and Proportion /level Hard (id 51-60)
--10 questions Math /Percentage /level Easy (id 61-70)
--10 questions Math /Percentage /level Medium (id 71-80)
--10 questions Math /Percentage /level Hard (id 81-90)

-- mock exam will be dynamic generated
--20 questions MOCK Exam /Medium 

--10 questions English /Vocabulary /level Easy (id 91-100)
--10 questions English /Vocabulary /level Medium  (id 101-110)
--10 questions English /Vocabulary /level Hard  (id 111-120)
--10 questions English /Grammar /level Easy   (id 121-130)
--10 questions English /Grammar /level Medium (id 131-140)
--10 questions English /Grammar /level Hard   (id 141-150)

--mock exam will be dynamic generated
---20 questions  english /MOCK Exam /Medium 

--10 questions Physics /Mechanics /level Easy (id 151-160)
--10 questions Physics /Mechanics /level Medium (id 161-170)
--10 questions Physics /Mechanics /level Hard   (id 171-180)
--10 questions Physics /Thermodynamics /level Easy  (id 181-190)
--10 questions Physics /Thermodynamics /level Medium  (id 191-200)
--10 questions Physics /Thermodynamics /level Hard  (id 201-210)
--10 questions Physics /Electromagnetism /level Easy  (id 211-220)
--10 questions Physics /Electromagnetism /level Medium  (id 221-230)
--10 questions Physics /Electromagnetism /level Hard  (id 231-240)


---20 questions Physics /MOCK Exam /Medium 


--10 questions  Operating systems /Memory management /level Easy  (id 241-250)
--10 questions Operating systems /Memory management /level Medium   (id 251-260)
--10 questions Operating systems /Memory management /level Hard   (id 261-270)
--10 questions Operating systems /Process management /level Easy    (id 271-280)
--10 questions Operating systems /Process management /level Medium  (id 281-290)
--10 questions Operating systems /Process management /level Hard  (id 291-300)
--10 questions Operating systems /File management /level Easy     (id 301-310)
--10 questions Operating systems /File management /level Medium (id 311-320)
--10 questions Operating systems /File management /level Hard (id 321-330)


---20 questions Operating systems /MOCK Exam /Medium 



 ---CREATE table for quiz_questions
CREATE TABLE
  quiz_questions
  (quiz_id INT,  
   question_id INT, 
PRIMARY KEY (quiz_id, question_id),
FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id),
FOREIGN KEY (question_id) REFERENCES questions(question_id)   
  );

--INSERT INTO QUIZ_QUESTIONS
--Algebra Quiz 1 level easy questions easy
--question_id 1 -10
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (1, 1),  (1, 2), 
  (1, 3),  (1, 4),
  (1, 5),  (1, 6),
  (1, 7),  (1, 8),  
  (1, 9),  (1, 10)

  --Algebra Quiz 2 level medium questions medium
  --question_id 11 - 20
  , (2, 11),  (2, 12), 
  (2, 13),  (2, 14),
  (2, 15),  (2, 16),
  (2, 17),  (2, 18),  
  (2, 19),  (2, 20);-- tested and working

--Algebra Quiz 3 level hard questions hard
--question_id 21 - 30
  INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
    (3, 21),  (3, 22), 
    (3, 23),  (3, 24),
    (3, 25),  (3, 26),
    (3, 27),  (3, 28),  
    (3, 29),  (3, 30); --tested


--Ratio and Proportion Quiz 1
--- Ratio and Proportion Quiz 2
---Ratio and Proportion Quiz 3
 ---Percentage Quiz 1
--- Percentage Quiz 2
---Percentage Quiz 3
--- Math exam
 ---Vocabulary Quiz 1
--- Vocabulary Quiz 2
--- Vocabulary Quiz 3
 ---Grammar Quiz 1
---Grammar Quiz 2
--- ---Grammar Quiz 3
---English exam
 --Mechanics Quiz 1
 --Mechanics Quiz 2
-- Mechanics Quiz 3
--Thermodynamics Quiz 1
 --Thermodynamics Quiz 2
 --Thermodynamics Quiz 3
 --Electromagnetism Quiz 1
 --Electromagnetism Quiz 2
 --Electromagnetism Quiz 3
 --Physics exam
-- Memory management Quiz 1
-- Memory management Quiz 2
 --Memory management Quiz 3
 --Process management Quiz 1
 --Process management Quiz 2
 --Process management Quiz 3
-- File management Quiz 1
-- File management Quiz 2
--File management Quiz 3
 --Operating systems exam





---CREATE table for answers tested
CREATE TABLE
  answers(
    answer_id SERIAL PRIMARY KEY,
    question_id INT,  --FOREIGN KEY
    answer_text TEXT,
    is_correct BOOLEAN,    
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
  );

  INSERT INTO
  answers (question_id,answer_text, is_correct)
VALUES
  --10 questions Math /Algebra 1 /level Easy answers (id 1-30) 
  (1,'3', FALSE),  (1,'5', FALSE),  (1,'10', TRUE),         --question_id-1
  (2,'2', FALSE),  (2,'4', TRUE),  (2,'6', FALSE),      -- question_id 2
  (3,'3', FALSE),  (3,'2', TRUE),  (3,'6', FALSE),      --question_id 3
  (4,'9', FALSE),  (4,'10', TRUE),  (4,'12', FALSE),        --question_id 4
  (5,'7x', TRUE),  (5,'12x', FALSE),  (5,'3x4', FALSE),       --question_id 5
  (6,'6', FALSE),  (6,'11', TRUE),  (6,'8', FALSE),        --question_id 6
  (7,'x²', TRUE),  (7,'2x', FALSE),  (7,'x+1', FALSE),      --question_id 7
  (8,'4', TRUE),  (8,'6', FALSE),  (8,'8', FALSE),      --- question_id 8
  (9,'12', TRUE),  (9,'3', FALSE),  (9,'8', FALSE),         -- question_id 9
  (10,'3', FALSE),  (10,'2', TRUE),  (10,'4', FALSE),       -- question_id 10

---10 questions (id 11-20) Math /Algebra 2 /level Medium answers (id 31-60) tested and working
(11,'x = 4', TRUE),
 (11,'x = 7', FALSE),
  (11,'x = 12', TRUE),  -- for Q11
(12,'(x - 6)(x - 3)', TRUE),
 (12,'(x + 6)(x - 3)', FALSE), 
 (12,'(x - 9)(x + 2)', FALSE),  -- for Q12
(13,'x = -3, x = 2', TRUE),
 (13,'x = 3, x = -2', FALSE), 
 (13,'x = 3, x = 2', FALSE),  --  for Q13
(14,'x + 2', TRUE),
 (14,'x^2 + 4', FALSE),
  (14,'2x + 2', FALSE),  --  for Q14
(15,'f(2) = 6', FALSE),
 (15,'f(2) = 4', FALSE), 
 (15,'f(2) = 6', TRUE),  --  for Q15
(16,'x = 7', FALSE),
 (16,'x = 6', FALSE),
  (16,'x = 5', TRUE),  --  for Q16
(17,'x = 3, x = 2', TRUE), 
(17,'x = -3, x = 2', FALSE),
 (17,'x = -3, x = -2', FALSE),  --for Q17
(18,'x = 9', TRUE), 
(18,'x = 8', FALSE), 
(18,'x = 7', FALSE),  -- for Q18
(19,'a + b = 7', TRUE),
 (19,'a + b = 10', FALSE), 
 (19,'a + b = 5', FALSE),  --  for Q19
(20,'x^2 + 3x - 10', TRUE), 
(20,'x^2 + x - 10', FALSE), 
(20,'x^2 + 7x - 10', FALSE);  -- for Q20
-- tested 

---10 questions (id 21-30) Math /Algebra 3 /level Hard answers (id 61-90) tested and working
INSERT INTO
  answers (question_id,answer_text, is_correct)
VALUES
(21, 'x = 12', TRUE),
(21, 'x = -12', FALSE),
(21, 'x = 8', FALSE),  -- for Q21

(22,'(x - 1)(x - 2)(x - 3)', TRUE), 
(22,'(x + 1)(x - 2)(x - 3)', FALSE), 
(22,'(x - 1)(x + 2)(x - 3)', FALSE),  -- for Q22

(23, 'x = 3, x = -0.5', TRUE),
(23, 'x = -3, x = 0.5', FALSE),
(23, 'x = 1, x = -3', FALSE),

(24, 'x^2 + 3x - 10', TRUE),
(24, '2x^2 - x + 5', FALSE),
(24, 'x^2 - 3x + 10', FALSE), --- for q24

(25, 'x = -1', TRUE),
(25, 'x = 5', FALSE),
(25, 'x = 2', FALSE), --for quest 25

(26, 'f^(-1)(x) = (5x + 4)/3', TRUE),
(26, 'f^(-1)(x) = (3x - 4)/5', FALSE),
(26, 'f^(-1)(x) = (5x - 4)/3', FALSE),

(27, 'x = 2', TRUE),
(27, 'x = -2', FALSE),
(27, 'x = 3', FALSE),-- q 27

(28, '-5 < x < 2', TRUE),
(28, 'x > 5 or x < -2', FALSE),
(28, 'x > 2 and x < -5', FALSE),

(29, '11', TRUE),
(29, '10', FALSE),
(29, '12', FALSE),

(30, '157', TRUE),
(30, '147', FALSE),
(30, '167', FALSE); -- for q30


---10 questions (id 31-40) Math /Ratio and Proportion /level Easy answers (id 91-120) 
---10 questions (id 41-50) Math /Ratio and Proportion /level Medium answers (id 121-150) 
---10 questions (id 51-60) Math /Ratio and Proportion /level Hard answers (id 151-180) 
---10 questions (id 61-70) Math /Percentage /level Easy answers (id 181-210) 
---10 questions (id 71-80) Math /Percentage /level Medium answers (id 211-240) 
---10 questions (id 81-90) Math /Percentage /level Hard answers (id 241-270) 

        
---20 questions MOCK Exam /Medium answers  

---10 questions (id 91-100) English /Vocabulary /level Easy answers (id 271-300)
---10 questions ( id 101-110) English /Vocabulary /level Medium answers     (id 301-330)
---10 questions (id 111-120) English /Vocabulary /level Hard answers   (id 331-360)
---10 questions (id 121-130) English /Grammar /level Easy answers  (id 361-390)
---10 questions (id 131-140)English /Grammar /level Medium answers  (id 391-420)
---10 questions (id 141-150) English /Grammar /level Hard answers  (id 421-450)
    
---20 questions  english /MOCK Exam /Medium answers 

---10 questions (id 151-160)  Physics /Mechanics /level Easy answers    
---10 questions (id 161-170) Physics /Mechanics /level Medium answers    
---10 questions (id 171-180) Physics /Mechanics /level Hard answers  
---10 questions (id 181-190) Physics  /Thermodynamics /level Easy answers   
---10 questions(id 191-200) Physics /Thermodynamics /level Medium answers   
---10 questions (id 201-210) Physics /Thermodynamics /level Hard answers   
---10 questions (id 211-220) Physics /Electromagnetism /level Easy answers   
---10 questions (id 221-230) Physics /Electromagnetism /level Medium answers  
---10 questions (id 231-240) Physics /Electromagnetism /level Hard answers 

    
---20 questions Physics /MOCK Exam /Medium answers 


---10 questions (id 241-250) Operating systems /Memory management /level Easy answers  
---10 questions (id 251-260) Operating systems /Memory management /level Medium answers 
---10 questions (id 261-270) Operating systems /Memory management /level Hard answers 
---10 questions (271-280) Operating systems /Process management /level Easy answers 
---10 questions (281-290) Operating systems /Process management /level Medium answers 
---10 questions (291-300) Operating systems /Process management /level Hard answers 
---10 questions(301-310) Operating systems /File management /level Easy answers 
---10 questions (311-320) Operating systems /File management /level Medium answers 
---10 questions (321-330) Operating systems /File management /level Hard answers 
    

---20 questions Operating systems /MOCK Exam /Medium answers 











/*
CREATE TABLE Student_progress(
    student_progress_id INT PRIMARY KEY,
    user_id INT,
    quizz_id INT,
    progress_score INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (quizz_id) REFERENCES quizzes(quizz_id)
);

*/



