---learning App database 


---CREATE DATABASE quizz

--- CREATE user table 

CREATE TABLE Users(
    user_id PRIMERY KEY SERIAL,
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

/*One topic can have many quizzes */
--CTEARE TABLE FOR TOPICS
CREATE TABLE Topics(
    topic_id SERIAL PRIMARY KEY,
    topic_name VARCHAR(20),
    topic_description TEXT,
    subject_id INT,  --FOREIGN KEY
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);



---CREATE ENIUM FOR QUIZ LEVEL
CREATE TYPE quiz_level AS ENUM('easy', 'medium', 'hard');

---CREATE ENUM FOR QUIZ TYPE
CREATE TYPE quiz_type AS ENUM('quizz', 'MOCK EXAM');

--CRETAE table for quizzes 
CREATE TABLE quizzes (
    quizz_id SERIAL PRIMARY KEY,
    quizz_name VARCHAR(20),
    quizz_description TEXT,
    quizz_date TIMESTAMP,
    quizz_type quiz_type,
    topic_id INT,  --FOREIGN KEY
    FOREIGN KEY (topic_id) REFERENCES Topics(topic_id) 
     quiz_level quiz_level
);


---CREATE table for questions
CREATE TABLE Questions(
    question_id SERIAL PRIMARY KEY,
    quizz_id INT,  --FOREIGN KEY
    question_text TEXT,
    FOREIGN KEY (quizz_id) REFERENCES quizzes(quizz_id)
    
);


---CREATE table for answers
CREATE TABLE Answers(
    answer_id SERIAL PRIMARY KEY,
    answer_text TEXT,
    is_correct BOOLEAN
    question_id INT,  --FOREIGN KEY
    FOREIGN KEY (question_id) REFERENCES Questions(question_id)
    
);


---CREATE table for quiz_questions_answers
CREATE TABLE quiz_questions_answers(
    quizz_id INT,  --FOREIGN KEY
    question_id INT,  --FOREIGN KEY
    answer_id INT,  --FOREIGN KEY
    FOREIGN KEY (quizz_id) REFERENCES quizzes(quizz_id),
    FOREIGN KEY (question_id) REFERENCES Questions(question_id),
    FOREIGN KEY (answer_id) REFERENCES Answers(answer_id)
);



CREATE TABLE Student_progress(
    student_progress_id INT PRIMARY KEY,
    user_id INT,
    quizz_id INT,
    progress_score INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (quizz_id) REFERENCES quizzes(quizz_id)
);