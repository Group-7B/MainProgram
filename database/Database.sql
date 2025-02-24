---learning App database 


---CREATE DATABASE quizz

--- CREATE user table 

CREATE TABLE Users(
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(20),
    user_last_name VARCHAR(20),
    user_email VARCHAR(20) UNIQUE NOT NULL ,
    user_password VARCHAR(12),
    join_date TIMESTAMP 
);

---rewards

--CREATE TABLE Subjects
CREATE TABLE  Subjects(
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(20),
    subject_description TEXT
);

INSERT INTO
  Subjects(subject_name, subject_description)
VALUES

---ID_1
  (
    'Mathematics',
    'Mathematics is the study of numbers, 
 shapes and patterns. The word comes from the Greek word "μάθημα" (máthema), 
 meaning "science, knowledge, or learning", and is sometimes shortened to maths 
 in England, Australia, Ireland, and New Zealand) or math (in the United States and Canada)'
  ),

  --ID_2(
    (
    'English',
    'English is a West Germanic language first spoken in early medieval England,    
which has become the leading language of international discourse in the 21st century.
It is named after the Angles, one of the ancient Germanic peoples that migrated to the area 
of Great Britain that later took their name, England.'
  ),

  --ID_3
  (
    'Physics',
    'Physics is the natural science that studies matter, its motion and behavior through 
.space and time, and the related entities of energy and force. Physics is one of the most fundamental 
scientific disciplines, and its main goal is to understand how the universe behaves.'
  ),

  --ID_4
  (
    'Operating systems',
    'An operating system (OS) is system software that manages computer hardware,
 software resources, and provides common services for computer programs. Time-sharing operating 
 systems schedule tasks for efficient use of the system and may also include accounting software 
 for cost allocation of processor time, mass storage, printing, and other resources.'
  );


/*One topic can have many quizzes */
--CTEARE TABLE FOR TOPICS
CREATE TABLE Topics(
    topic_id SERIAL PRIMARY KEY,
    topic_name VARCHAR(20),
    topic_description TEXT,
    subject_id INT,  --FOREIGN KEY
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);


--insert into topics
INSERT INTO
  Topics(topic_name, topic_description, subject_id)
VALUES

--ID_1-3 MATH
--ID_1
  (
    'Algebra',
    'Algebra is a branch of mathematics dealing with symbols and the rules for
manipulating those symbols. In elementary algebra, those symbols
 (today written as Latin and Greek letters) represent quantities without fixed values, known as 
 variables. This is useful for several reasons.',
    1
  ),
  --ID_2
  (
    'Ratio and Proportion',
    'Ratio and proportion are two concepts that are closely related to each other.
 A ratio is a comparison of two numbers or measurements, while a proportion is an equation that states 
 that two ratios are equal. Ratios and proportions are used in many real-life situations to compare 
 quantities and to predict outcomes.',
    1
  ),
  --ID_3
  (
    'Persentage',
    'Percentage is a number or ratio expressed as a fraction of 100. It is often 
denoted using the percent sign, "%", 
 or the abbreviation "pct." For example, 45% (read as "forty-five percent") is
  equal to 45/100, or 0.45.',
    1
  ),

  --ID_4 to 5 ENGLISH

  --ID_4
  (
    'Vocabulary',
    'Vocabulary refers to the words we must understand to communicate effectively.
 Educated people have a wide vocabulary.',
    2
  ),

  --ID_5
  (
    'Grammar',
    'Grammar is the system of a language. People sometimes describe grammar as the "rules" 
of a language; but in fact no language has rules.        
If we use the word "rules", we suggest that somebody created the rules first and then spoke the 
language, like a new game. But languages did not start like that. Languages started by people 
making sounds which evolved into words, phrases and sentences. No commonly-spoken language is fixed.
 All languages change over time. What we call "grammar" is simply a reflection of a 
 language at a particular time.',
    2
  ),


  --ID_6 TO 8 PHYSICS


    --ID_6
  (
    'Mechanics',
    'Mechanics is the branch of Physics dealing with the study of motion when subjected to
 forces or displacements, and the subsequent effects of the bodies on their environment.',
    3
  ),

    --ID_7
  (
    'Thermodynamics',
    'Thermodynamics is the branch of physics that deals with the relationships 
between heat and other forms of energy. In particular, it describes how thermal energy is 
converted to and from other forms of energy and how it affects matter.',
    3
  ),

    --ID_8
  (
    'Electromagnetism',
    'Electromagnetism is a branch of physics involving the study of the 
electromagnetic force, a type of physical interaction that occurs between electrically charged 
particles. The electromagnetic force usually exhibits electromagnetic fields such as electric 
fields, magnetic fields, and light, and is one of the four fundamental interactions in nature.',
    3
  ),

    --ID_9 TO 11 OPERATING SYSTEMS

    --ID_9
  (
    'Memory management',
    'Memory management is the process of controlling and coordinating computer memory,
 assigning portions called blocks to various running programs to optimize overall system performance. 
 Memory management operates in the following ways: It keeps track of each and every byte of memory, 
 either used or free. It indicates the status of each memory area, whether it is allocated, 
 deallocated, or available.',
    4
  ),

    --ID_10
  (
    'Process management',
    'Process management is an integral part of any modern-day operating system (OS). 
The OS must allocate resources to processes, enable processes to share and exchange information,
 protect the resources of each process from other processes and enable synchronization among processes.
 Process management is an essential part of a multiprogramming operating system.',
    4
  ),
  
    --ID_11
  (
    'File management',
    'File management is the process of administering a system that correctly handles    
digital data. Therefore, an effective file management system improves the overall function of a business
    workflow. It also organizes important data and provides a searchable database for quick retrieval.',
    4
  );



---CREATE ENIUM FOR QUIZ LEVEL
CREATE TYPE quiz_level AS ENUM('Easy', 'Medium', 'Hard');

---CREATE ENUM FOR QUIZ TYPE
CREATE TYPE quiz_type AS ENUM('Quiz', 'MOCK EXAM');

--CRETAE table for quizzes 
CREATE TABLE
  quizzes (
    quiz_id SERIAL PRIMARY KEY,
    quiz_name VARCHAR(60),
    quiz_type quiz_type,
    quiz_level quiz_level,
    subject_id INT, --FOREIGN KEY
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
  );

---insert into quizzes
INSERT INTO
  quizzes(quiz_name, quiz_type, quiz_level, subject_id)
VALUES
  --Subject math ID_1 /topic Algebra id_1
   ('Algebra', 'quizz', 'easy',1), 
  ('Algebra', 'quizz', 'medium',1),
  ('Algebra', 'quizz', 'hard',1),

  --Subject math ID_1 /topic Ratio and Proportion id_2
  ('Ratio and Proportion', 'quizz', 'easy',1),
  ('Ratio and Proportion', 'quizz', 'medium',1),
  ('Ratio and Proportion', 'quizz', 'hard',1),

    --Subject math ID_1 /topic Percentage id_3
  ('Percentage', 'quizz', 'easy',1),
  ('Percentage', 'quizz', 'medium',1),
  ('Percentage', 'quizz', 'hard',1),

  ('Math mock exam', 'MOCK EXAM', 'medium',1),

  --Subject english ID_2 /topic Vocabularye id_4

  ('Vocabulary', 'quizz', 'easy',2),
  ('Vocabulary', 'quizz', 'medium',2),
  ('Vocabulary', 'quizz', 'hard',2),

    --Subject english ID_2 /topic Grammar id_5
  ('Grammar', 'quizz', 'easy',2),
  ('Grammar', 'quizz', 'medium',2),
  ('Grammar', 'quizz', 'hard',2),

  ('English mock exam', 'MOCK EXAM', 'medium',2),

  --subject physics ID_3 /topic Mechanics id_6  
  ('Mechanics', 'quizz', 'easy',3),
  ('Mechanics', 'quizz', 'medium',3),
  ('Mechanics', 'quizz', 'hard',3),

  --subject physics ID_3 /topic Thermodynamics id_7
 
  ('Thermodynamics', 'quizz', 'easy',3),
  ('Thermodynamics', 'quizz', 'medium',3),
  ('Thermodynamics', 'quizz', 'hard',3),

    --subject physics ID_3 /topic Electromagnetism id_8
  ('Electromagnetism', 'quizz', 'easy',3),
  ('Electromagnetism', 'quizz', 'medium',3),
  ('Electromagnetism', 'quizz', 'hard',3),

  ('Physics mock exam', 'MOCK EXAM', 'medium',3),

 
  --subject operating systems  ID_4/Topic Memory management id_9
  ('Memory management', 'quizz', 'easy',4),
  ('Memory management', 'quizz', 'medium',4),
  ('Memory management', 'quizz', 'hard',4),
  ---subject operating systems  ID_4/Topic Process management id_10
  ('Process management', 'quizz', 'easy',4),
  ('Process management', 'quizz', 'medium',4),
  ('Process management', 'quizz', 'hard',4),
  ---subject operating systems  ID_4/Topic File management id_11
  ('File management', 'quizz', 'easy',4),
  ('File management', 'quizz', 'medium',4),
  ('File management', 'quizz', 'hard',4),
  
  ('Operating systems mock exam','MOCK EXAM','medium',4)
;




---CREATE table for questions
CREATE TABLE
  Questions(question_id SERIAL PRIMARY KEY,
   question_text TEXT,
   topic_id INT,  --FOREIGN KEY
   FOREIGN KEY (topic_id) REFERENCES Topics(topic_id));

---insert into questions
  --10 questions Math /Algebra /level easy 
INSERT INTO
  Questions (question_text)
VALUES
  ('What is the value of x in the equation: x + 5 = 10?',1),
  ('Solve for x: 2x = 8',1),
  ('What is 5x - 3 = 7 when solved for x?',1),
  ('What is the next term in the pattern: 2, 4, 6, 8, __?',1),
  ('What is the simplified form of 3x + 4x?',1),
  ('If x = 3, what is the value of 2x + 5?',1),
  ('Which expression is equivalent to x * x?',1),
  ('If y = 10, what is y - 6?',1),
  ('Solve for x: x/2 = 6',1),
  ('What is the value of 3(x + 2) = 12?',1);
  ----10 questions Math /Algebra /level easy (id 1-10)




---CREATE table for answers
CREATE TABLE Answers(
    answer_id SERIAL PRIMARY KEY,
    answer_text TEXT,
    is_correct BOOLEAN,
    question_id INT,  --FOREIGN KEY
    FOREIGN KEY (question_id) REFERENCES Questions(question_id)    
);

INSERT INTO
  Answers (answer_text, is_correct,question_id)
VALUES
  --10 questions Math /Algebra /level easy- 30 answers (id 1-30) 
  ('3', FALSE,1),  ('5', FALSE,1),  ('10', TRUE,1),         --question_id-1
  ('2', FALSE,2),  ('4', TRUE,2),  ('6', FALSE,2),      -- question_id 2
  ('3', FALSE,3),  ('2', TRUE,3),  ('6', FALSE,3),      --question_id 3
  ('9', FALSE,4),  ('10', TRUE,4),  ('12', FALSE,4),        --question_id 4
  ('7x', TRUE,5),  ('12x', FALSE,5),  ('3x4', FALSE,5),       --question_id 5
  ('6', FALSE,6),  ('11', TRUE,6),  ('8', FALSE,6), -       --question_id 6
  ('x²', TRUE,7),  ('2x', FALSE,7),  ('x+1', FALSE,7),      --question_id 7
  ('4', TRUE,8),  ('6', FALSE,8),  ('8', FALSE,8),      --- question_id 8
  ('12', TRUE,9),  ('3', FALSE,9),  ('8', FALSE,9),         -- question_id 9
  ('3', FALSE,10),  ('2', TRUE,10),  ('4', FALSE,10),       -- question_id 10




---CREATE table for quiz_questions_answers
CREATE TABLE quiz_questions_answers(
    quizz_id INT,  --FOREIGN KEY
    question_id INT,  --FOREIGN KEY
    answer_id INT,  --FOREIGN KEY
    FOREIGN KEY (quizz_id) REFERENCES quizzes(quizz_id),
    FOREIGN KEY (question_id) REFERENCES Questions(question_id),
    FOREIGN KEY (answer_id) REFERENCES Answers(answer_id)
);


INSERT INTO
  quiz_questions_answers (quiz_id, question_id, answer_id)
VALUES
  --algebra level easy  (q1,qu 1-10,ans- 1 to 30)
(1, 1, 1), (1, 1, 2), (1, 1, 3), 
(1, 2, 4), (1, 2, 5), (1, 2, 6), 
(1, 3, 7), (1, 3, 8), (1, 3, 9), 
(1, 4, 10), (1, 4, 11), (1, 4, 12), 
(1, 5, 13), (1, 5, 14), (1, 5, 15), 
(1, 6, 16), (1, 6, 17), (1, 6, 18), 
(1, 7, 19), (1, 7, 20), (1, 7, 21), 
(1, 8, 22), (1, 8, 23), (1, 8, 24), 
(1, 9, 25), (1, 9, 26), (1, 9, 27), 
(1, 10, 28), (1, 10, 29), (1, 10, 30);




CREATE TABLE Student_progress(
    student_progress_id INT PRIMARY KEY,
    user_id INT,
    quizz_id INT,
    progress_score INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (quizz_id) REFERENCES quizzes(quizz_id)
);