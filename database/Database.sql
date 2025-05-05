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
); --checked
 

--CREATE TABLE Subjects
CREATE TABLE  subjects(
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(20),
    subject_description TEXT
);--checked

INSERT INTO
  Subjects(subject_name, subject_description)
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
); --- checked 

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
    workflow. It also organizes important data and provides a searchable database for quick retrieval.' ); --- checked 



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
  ); -- checked

--INSERT INTO QUIZZES
INSERT INTO
  quizzes(subject_id, topic_id, quiz_name, quiz_type, quiz_level)
VALUES
--- 9 quizzes for math with id start from 1- to 9 
  (1, 1, 'Algebra Quiz 1', 'quiz', 'Easy'),
  (1, 1, 'Algebra Quiz 2', 'quiz', 'Medium'),
  (1, 1, 'Algebra Quiz 3', 'quiz', 'Hard'),
  (1, 2, 'Ratio and Proportion Quiz 1', 'quiz', 'Easy'),
  (1, 2, 'Ratio and Proportion Quiz 2', 'quiz', 'Medium'),
  (1, 2, 'Ratio and Proportion Quiz 3', 'quiz', 'Hard'),
  (1, 3, 'Percentage Quiz 1', 'quiz', 'Easy'),
  (1, 3, 'Percentage Quiz 2', 'quiz', 'Medium'),
  (1, 3, 'Percentage Quiz 3', 'quiz', 'Hard'),

--- 6 quizzes for english  10 - to 15
  (2, 4, 'Vocabulary Quiz 1', 'quiz', 'Easy'),
  (2, 4, 'Vocabulary Quiz 2', 'quiz', 'Medium'),
  (2, 4, 'Vocabulary Quiz 3', 'quiz', 'Hard'),
  (2, 5, 'Grammar Quiz 1', 'quiz', 'Easy'),
  (2, 5, 'Grammar Quiz 2', 'quiz', 'Medium'),
  (2, 5, 'Grammar Quiz 3', 'quiz', 'Hard'),
  
  --- 9 quizzes for physics 16-to 24
   
  (3, 6, 'Mechanics Quiz 1', 'quiz', 'Easy'),
  (3, 6, 'Mechanics Quiz 2', 'quiz', 'Medium'),
  (3, 6, 'Mechanics Quiz 3', 'quiz', 'Hard'),
  (3, 7, 'Thermodynamics Quiz 1', 'quiz', 'Easy'),
  (3, 7, 'Thermodynamics Quiz 2', 'quiz', 'Medium'),
  (3, 7, 'Thermodynamics Quiz 3', 'quiz', 'Hard'),
  (3, 8, 'Electromagnetism Quiz 1', 'quiz', 'Easy'),
  (3, 8, 'Electromagnetism Quiz 2', 'quiz', 'Medium'),
  (3, 8, 'Electromagnetism Quiz 3', 'quiz', 'Hard'),

   --- 9 quizzes for operating systems 25-to 33

  (4, 9, 'Memory management Quiz 1', 'quiz', 'Easy'),
  (4, 9, 'Memory management Quiz 2', 'quiz', 'Medium'),
  (4, 9, 'Memory management Quiz 3', 'quiz', 'Hard'),
  (4, 10, 'Process management Quiz 1', 'quiz', 'Easy'),
  (4, 10, 'Process management Quiz 2', 'quiz', 'Medium'),
  (4, 10, 'Process management Quiz 3', 'quiz', 'Hard'),
  (4, 11, 'File management Quiz 1', 'quiz', 'Easy'),
  (4, 11, 'File management Quiz 2', 'quiz', 'Medium'),
  (4, 11, 'File management Quiz 3', 'quiz', 'Hard')




--Math mock exam contain mixed questions from all topics quiz_id 34
(1,NULL,'Math exam', 'MOCK Exam', 'Medium'),
 --English mock exam contain mixed questions from all topics quiz_id_35
(2,NULL,'English exam','Mock Exam', 'Medium'),

 --Physics mock exam contain mixed questions from all topics quiz_id 36
(3,NULL,'Physics exam','Mock Exam', 'Medium'),

  --Operating systems mock exam contain mixed questions from all topics quiz_id 37
(4,NULL,'Operating systems exam','Mock Exam', 'Medium');




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
  (1,'What is the value of 3(x + 2) = 12?',1,'Easy');

  -- topic_id 1 Algebra level medium questions medium 
--question_id 11 - 20
insert into questions(topic_id, question_text, points, question_level)
VALUES
  (1,'What is the value of x in the equation: 2x + 3 = 11?',2,'Medium'),
  (1,'Solve for x: 3x - 5 = 10',2,'Medium'),
  (1,'What is 4x - 3 = 13 when solved for x?',2,'Medium'),
  (1,'What is the next term in the pattern: 3, 6, 9, 12, __?',2,'Medium'),
  (1,'What is the simplified form of 4x + 5x?',2,'Medium'),
  (1,'If x = 4, what is the value of 3x + 6?',2,'Medium'),
  (1,'Which expression is equivalent to x * x * x?',2,'Medium'),
  (1,'If y = 15, what is y - 8?',2,'Medium'),
  (1,'Solve for x: x/3 = 7',2,'Medium'),
  (1,'What is the value of 4(x + 3) = 28?',2,'Medium');-- tested and working added in mainprogram
  

  
--topic_id =1,10 questions Math /Algebra /level Hard (id 21-30)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
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


/*---corection of the question_id 31-40 
UPDATE questions
SET topic_id = 2
WHERE question_id BETWEEN 31 AND 40;*/

-- topic_id=2 10 questions Math /Ratio and Proportion /level Easy (id 31-40)

INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(2, 'What is the ratio of 8 to 4?', 1, 'Easy'),
(2, 'Simplify the ratio 15:5.', 1, 'Easy'),
(2, 'If 3 pens cost £6, how much do 6 pens cost?', 1, 'Easy'),
(2, 'Find the missing number: 2:5 = 4:x.', 1, 'Easy'),
(2, 'If 5 kg of apples cost £10, what is the cost of 2 kg?', 1, 'Easy'),
(2, 'What is the ratio of 20 minutes to 1 hour?', 1, 'Easy'),
(2, 'A recipe uses 2 cups of sugar for every 5 cups of flour. How much sugar is needed for 10 cups of flour?', 1, 'Easy'),
(2, 'If 4:7 = x:21, what is x?', 1, 'Easy'),
(2, 'Divide £60 in the ratio 2:3.', 1, 'Easy'),
(2, 'If 12 oranges cost £9, what is the cost of 4 oranges?', 1, 'Easy'); -- tested and working 17/08


--topic_id 2 / 10 questions Math /Ratio and Proportion /level Medium (id 41-50)

INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(2, 'If 12 workers complete a task in 8 days, how many days would 16 workers take?', 2, 'Medium'),
(2, 'Divide £1200 between Alice and Bob in the ratio 3:5.', 2, 'Medium'),
(2, 'If the ratio of boys to girls is 7:9 and there are 63 boys, how many girls are there?', 2, 'Medium'),
(2, 'Find the value of x if 4:x = 6:9.', 2, 'Medium'),
(2, 'If 15 kg of rice costs £45, how much would 9 kg cost?', 2, 'Medium'),
(2, 'A car travels 240 km on 30 liters of fuel. How much fuel is needed for 400 km?', 2, 'Medium'),
(2, 'In a class, the ratio of passed to failed students is 5:2. If 14 failed, how many passed?', 2, 'Medium'),
(2, 'Simplify the ratio 48:64.', 2, 'Medium'),
(2, 'If £500 is shared among 4 people in the ratio 1:2:3:4, how much does the second person get?', 2, 'Medium'),
(2, 'A map scale is 1:50000. What is the real distance if the map shows 4 cm?', 2, 'Medium');  -- tested and working 17/03


--topic_id 2 / 10 questions Math /Ratio and Proportion /level Hard (id 51-60)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(2, 'The ratio of incomes of A and B is 5:7 and the ratio of their expenses is 3:4. If A saves £800 and B saves £600, what is A\`s income?', 3, 'Hard'),
(2, 'A mixture contains alcohol and water in the ratio 3:2. If 20 liters of water are added, the ratio becomes 3:4. Find the quantity of alcohol in the mixture.', 3, 'Hard'),
(2, 'Three numbers are in the ratio 2:3:4. If their sum is 81, what is the largest number?', 3, 'Hard'),
(2, 'A sum of money is divided among A, B, and C in the ratio 5:6:7. If C gets £84 more than A, find the total amount.', 3, 'Hard'),
(2, 'The ratio of ages of two people is 4:5. After 6 years, the ratio becomes 5:6. Find their present ages.', 3, 'Hard'),
(2, 'Two alloys are mixed in the ratio 7:5. The first alloy contains copper and zinc in the ratio 2:1, and the second in the ratio 3:2. Find the ratio of copper to zinc in the new mixture.', 3, 'Hard'),
(2, 'The sides of a triangle are in the ratio 3:4:5, and its perimeter is 144 cm. Find the area of the triangle.', 3, 'Hard'),
(2, 'The monthly incomes of two persons are in the ratio 9:7, and their expenditures are in the ratio 4:3. If each saves £200, find their incomes.', 3, 'Hard'),
(2, 'If x:y = 7:9 and y:z = 4:5, find x:z.', 3, 'Hard'),
(2, 'A man spends 60% of his income. His income increases in the ratio 5:6, and his expenditure increases in the ratio 4:5. Find the ratio of his savings before and after the increase.', 3, 'Hard'); --tested and working



--topic_id=3 / 10 questions Math /Percentage /level Easy (id 61-70)

INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(3, 'What is 25% of 200?', 1, 'Easy'),
(3, 'A product costs £80. If it is discounted by 10%, what is the sale price?', 1, 'Easy'),
(3, 'What percentage of 50 is 10?', 1, 'Easy'),
(3, 'Increase £120 by 15%. What is the new amount?', 1, 'Easy'),
(3, 'If 30 is 60% of a number, what is the number?', 1, 'Easy'),
(3, 'What is 10% of 500?', 1, 'Easy'),
(3, 'A £200 item is reduced by 25%. What is the new price?', 1, 'Easy'),
(3, 'What percentage is 45 out of 90?', 1, 'Easy'),
(3, 'A shirt originally costs £50. It is on sale for £40. What is the percentage discount?', 1, 'Easy'),
(3, 'Reduce £150 by 20%. What is the final amount?', 1, 'Easy'); --tested work fine


--topic_id=3 / 10 questions Math /Percentage /level Medium (id 71-80)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(3, 'A price increases from £250 to £300. What is the percentage increase?', 2, 'Medium'),
(3, '£90 is 60% of what amount?', 2, 'Medium'),
(3, 'If a number is increased by 25% and becomes 100, what was the original number?', 2, 'Medium'),
(3, 'A population of 2,000 decreases by 15%. What is the new population?', 2, 'Medium'),
(3, 'Find the percentage decrease when a value drops from 500 to 350.', 2, 'Medium'),
(3, 'If 30% of a number is 45, what is the number?', 2, 'Medium'),
(3, 'A bill of £240 includes a 20% service charge. What was the original amount before the charge?', 2, 'Medium'),
(3, 'A £400 TV is on sale with 15% off. What is the sale price?', 2, 'Medium'),
(3, 'A student scored 72 out of 80 in a test. What is the percentage score?', 2, 'Medium'),
(3, 'Increase £360 by 12.5%. What is the new total?', 2, 'Medium');     --tested and working





--topic_id=3 / 10 questions Math /Percentage /level Hard (id 81-90)

INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(3, 'A population increases from 12,000 to 15,600 in two years. What is the percentage increase?', 3, 'Hard'),
(3, 'A company\`s profit decreased from £250,000 to £200,000. What is the percentage decrease?', 3, 'Hard'),
(3, 'If £360 is 120% of a number, what is the number?', 3, 'Hard'),
(3, 'After a 30% discount, a laptop costs £700. What was the original price?', 3, 'Hard'),
(3, 'A value increases by 40% and becomes £980. What was the original value?', 3, 'Hard'),
(3, 'If a number is decreased by 20% and becomes 144, what was the original number?', 3, 'Hard'),
(3, 'A store raises its prices by 25%, then offers a 20% discount. What is the overall percentage change?', 3, 'Hard'),
(3, 'A salary of £45,000 is increased by 10% one year and then by 15% the next year. What is the final salary?', 3, 'Hard'),
(3, 'A product is marked up by 35% and then discounted by 15%. What is the net percentage change from the original price?', 3, 'Hard'),
(3, 'A car worth £24,000 depreciates by 18% in the first year and 12% in the second year. What is its value after two years?', 3, 'Hard'); --tested and working

/*--corection of the question_id 81-90
UPDATE questions
SET points = 3
WHERE question_id BETWEEN 81 AND 90;*/



-- topick_id = 4 / 10 questions English /Vocabulary /level Easy (id 91-100)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(4, 'What is the synonym of "Happy"?', 1, 'Easy'),
(4, 'What is the opposite of "Big"?', 1, 'Easy'),
(4, 'Choose the correct meaning of "Fast".', 1, 'Easy'),
(4, 'What is the synonym of "Cold"?', 1, 'Easy'),
(4, 'What is the opposite of "Early"?', 1, 'Easy'),
(4, 'Choose the correct meaning of "Beautiful".', 1, 'Easy'),
(4, 'What is the synonym of "Quick"?', 1, 'Easy'),
(4, 'What is the opposite of "Easy"?', 1, 'Easy'),
(4, 'Choose the correct meaning of "Strong".', 1, 'Easy'),
(4, 'What is the synonym of "Smart"?', 1, 'Easy'); --tested and working



--topick_id=4 / 10 questions English /Vocabulary /level Medium  (id 101-110)
-- Insert questions
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
(4, 'What does "gregarious" mean?', 2, 'Medium'),
(4, 'Which of the following is the closest synonym to "meticulous"?', 2, 'Medium'),
(4, 'What does "elusive" mean?', 2, 'Medium'),
(4, 'Which of the following means "to make something clear"?', 2, 'Medium'),
(4, 'What is the meaning of "cogent"?', 2, 'Medium'),
(4, 'Which word is closest in meaning to "ameliorate"?', 2, 'Medium'),
(4, 'What does "prolific" mean?', 2, 'Medium'),
(4, 'Which word means "having a sharp or biting taste"?', 2, 'Medium'),
(4, 'What does "ephemeral" refer to?', 2, 'Medium'),
(4, 'Which word means "feeling of doubt"?', 2, 'Medium'); --tested and working



--topick_id=4 / 10 questions English /Vocabulary /level Hard  (id 111-120)

-- Insert questions
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
(4, 'What does "pulchritude" mean?', 3, 'Hard'),
(4, 'Which of the following is a synonym of "recalcitrant"?', 3, 'Hard'),
(4, 'What does "sesquipedalian" refer to?', 3, 'Hard'),
(4, 'Which of the following is the meaning of "antediluvian"?', 3, 'Hard'),
(4, 'What does "sonder" mean?', 3, 'Hard'),
(4, 'Which word means "the act of walking slowly and aimlessly"?', 3, 'Hard'),
(4, 'What is the meaning of "vorfreude"?', 3, 'Hard'),
(4, 'Which word refers to an irrational fear of long words?', 3, 'Hard'),
(4, 'What does "cryptozoology" study?', 3, 'Hard'),
(4, 'What is the meaning of "zugzwang"?', 3, 'Hard');---tested and working







--topick_id=5 / 10 questions English /Grammar /level Easy   (id 121-130)

-- Insert Questions
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(5, 'Which is the correct form of the verb in the sentence: "She ____ to the store."', 1, 'Easy'),
(5, 'Which of the following is the correct sentence?', 1, 'Easy'),
(5, 'Choose the correct option: "He has ____ books."', 1, 'Easy'),
(5, 'What is the correct use of an apostrophe?', 1, 'Easy'),
(5, 'Which of the following sentences is in the past tense?', 1, 'Easy'),
(5, 'Which of the following is a possessive pronoun?', 1, 'Easy'),
(5, 'Which sentence uses an article correctly?', 1, 'Easy'),
(5, 'Which of the following is the correct use of “there”?', 1, 'Easy'),
(5, 'Choose the correct preposition: “She is sitting ____ the table."', 1, 'Easy'),
(5, 'Which sentence is a compound sentence?', 3, 'Easy'); ---tested and working






--topick_id=5 / 10 questions English /Grammar /level Medium (id 131-140)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(5, 'What is the synonym of "Enormous"?', 2, 'Medium'),
(5, 'What is the opposite of "Benevolent"?', 2, 'Medium'),
(5, 'Choose the correct meaning of "Meticulous".', 2, 'Medium'),
(5, 'What is the synonym of "Fleeting"?', 2, 'Medium'),
(5, 'What is the opposite of "Tranquil"?', 2, 'Medium'),
(5, 'Choose the correct meaning of "Scrutinize".', 2, 'Medium'),
(5, 'What is the synonym of "Obstinate"?', 2, 'Medium'),
(5, 'What is the opposite of "Diligent"?', 2, 'Medium'),
(5, 'Choose the correct meaning of "Ambiguous".', 2, 'Medium'),
(5, 'What is the synonym of "Vigorous"?', 2, 'Medium'); --tested and working

--topic_id=5 / 10 questions English /Grammar /level Hard   (id 141-150)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(5, 'What is the synonym of "Obfuscate"?', 3, 'Hard'),
(5, 'What is the opposite of "Acerbic"?', 3, 'Hard'),
(5, 'Choose the correct meaning of "Proclivity".', 3, 'Hard'),
(5, 'What is the synonym of "Recalcitrant"?', 3, 'Hard'),
(5, 'What is the opposite of "Soporific"?', 3, 'Hard'),
(5, 'Choose the correct meaning of "Ubiquitous".', 3, 'Hard'),
(5, 'What is the synonym of "Intransigent"?', 3, 'Hard'),
(5, 'What is the opposite of "Ephemeral"?', 3, 'Hard'),
(5, 'Choose the correct meaning of "Pernicious".', 3, 'Hard'),
(5, 'What is the synonym of "Surreptitious"?', 3, 'Hard');  --tested and working




-- topic_id-6/10 questions Physics /Mechanics /level Easy (id 151-160)

INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(6, 'Which of these is an example of a force?', 2, 'Easy'),
(6, 'What is the unit of force in the SI system?', 2, 'Easy'),
(6, 'If a car accelerates from 0 m/s to 10 m/s in 5 seconds, what is its acceleration?', 2, 'Easy'),
(6, 'Which of the following best describes Newton\`s First Law of Motion?', 2, 'Easy'),
(6, 'What does the term "velocity" refer to?', 2, 'Easy'),
(6, 'If an object is moving with constant velocity, the net force acting on it is:', 2, 'Easy'),
(6, 'Which of the following is an example of potential energy?', 2, 'Easy'),  
(6, 'What is the formula to calculate work done by a force?', 2, 'Easy'),
(6, 'What does the term "momentum" refer to in physics?', 2, 'Easy'),
(6, 'Which of the following is an example of an object in free fall?', 2, 'Easy'); -- tested and working

--topic_id-6/10 questions Physics /Mechanics /level Medium (id 161-170)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(6, 'A car accelerates from 10 m/s to 30 m/s in 5 seconds. What is the car\s average acceleration?', 2, 'Medium'),
(6, 'A 2 kg object is acted upon by a 10 N force. What is the acceleration of the object?', 2, 'Medium'),
(6, 'A 500 N force is applied to an object with a mass of 50 kg. What is the object\s acceleration?', 2, 'Medium'),
(6, 'What is the work done when a force of 20 N moves an object 5 meters in the direction of the force?', 2, 'Medium'),
(6, 'A ball is thrown vertically upwards with a speed of 20 m/s. What is the maximum height it will reach? (Assume g = 10 m/s²)', 2, 'Medium'),
(6, 'A 10 kg object is moving at 3 m/s. What is its kinetic energy?', 2, 'Medium'),
(6, 'A person applies a force of 50 N to push a box 4 meters across the floor. If the force is applied in the direction of motion, what is the work done?', 2, 'Medium'),
(6, 'If an object of mass 10 kg is moving at a velocity of 5 m/s, what is its momentum?', 2, 'Medium'),
(6, 'A 3 kg object is placed 2 meters above the ground. What is its potential energy relative to the ground? (Assume g = 10 m/s²)', 2, 'Medium'),
(6, 'A spring has a spring constant of 100 N/m. How much force is required to stretch it by 0.5 meters?', 2, 'Medium'); -- tested  and working


--topic_id - 6/ 10 questions Physics /Mechanics /level Hard   (id 171-180)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(6, 'A 10 kg block is placed on a frictionless surface and is acted upon by a horizontal force of 50 N. What is the speed of the block after 4 seconds?', 3, 'Hard'),
(6, 'A 2 kg object moves with a speed of 10 m/s. It collides with a wall and comes to a stop. What is the change in momentum?', 3, 'Hard'),
(6, 'A 4 kg mass is attached to a spring with a spring constant of 200 N/m. If the mass is displaced by 0.1 m, what is the potential energy stored in the spring?', 3, 'Hard'),
(6, 'A 5 kg object is moving with a velocity of 4 m/s. The object collides with a 2 kg object moving at 3 m/s. If the collision is perfectly elastic, what is the velocity of the 5 kg object after the collision?', 3, 'Hard'),
(6, 'A car of mass 1000 kg is moving at 25 m/s. The car’s engine exerts a constant force of 2000 N. How long does it take for the car to accelerate to 35 m/s?', 3, 'Hard'),
(6, 'A 2 kg object is attached to a string and swings in a circular path with a radius of 4 m. If the object has a speed of 6 m/s, what is the centripetal force acting on the object?', 3, 'Hard'),
(6, 'A 10 kg object is dropped from a height of 50 m. What will its speed be just before it hits the ground? (Assume no air resistance and g = 10 m/s²)', 3, 'Hard'),
(6, 'A 2 kg object is attached to a vertical spring with a spring constant of 150 N/m. What is the period of oscillation of the object?', 3, 'Hard'),
(6, 'A 0.5 kg object is moving in a circular path with a radius of 2 m and a speed of 8 m/s. What is the object\s angular velocity?', 3, 'Hard'),
(6, 'A 50 kg person is standing in an elevator. If the elevator accelerates upward at 2 m/s², what is the normal force exerted on the person? (Assume g = 10 m/s²)', 3, 'Hard'); -- tested and working

--topic_id - 7 /10 questions Physics /Thermodynamics /level Easy  (id 181-190)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(7, 'What is the primary source of energy for the Earth?', 1, 'Easy'),
(7, 'What is the SI unit of temperature?', 1, 'Easy'),
(7, 'Which law of thermodynamics states that energy cannot be created or destroyed?', 1, 'Easy'),
(7, 'In which process does a gas expand and do work on its surroundings?', 1, 'Easy'),
(7, 'What is the measure of the disorder or randomness of a system?', 1, 'Easy'),
(7, 'Which of the following processes occurs at constant pressure?', 1, 'Easy'),
(7, 'In a heat engine, what is the term for the heat energy that is absorbed by the engine?', 1, 'Easy'),
(7, 'Which of the following statements is true about the second law of thermodynamics?', 1, 'Easy'),
(7, 'What happens to the temperature of an ideal gas when it undergoes an isothermal expansion?', 1, 'Easy'),
(7, 'Which of the following is the correct definition of specific heat capacity?', 1, 'Easy'); -- tested and working

--topic_id-7/10 questions Physics /Thermodynamics /level Medium  (id 191-200)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES 
(7, 'In an isothermal process, what remains constant?', 2, 'Medium'),
(7, 'Which of the following is true for an adiabatic process?', 2, 'Medium'),
(7, 'A heat engine absorbs 400 J of heat from a hot reservoir and expels 200 J of heat to a cold reservoir. What is the efficiency of the engine?', 2, 'Medium'),
(7, 'What is the change in internal energy for an ideal gas undergoing an isochoric process (constant volume)?', 2, 'Medium'),
(7, 'A substance undergoes a phase change from liquid to gas. Which of the following is true during the phase transition?', 2, 'Medium'),
(7, 'Which of the following represents the second law of thermodynamics?', 2, 'Medium'),
(7, 'In a Carnot engine, if the temperature of the hot reservoir is 600 K and the cold reservoir is 300 K, what is the maximum possible efficiency?', 2, 'Medium'),
(7, 'When a gas undergoes an isothermal expansion, which of the following is true?', 2, 'Medium'),
(7, 'Which of the following factors does NOT affect the efficiency of a heat engine?', 2, 'Medium'),
(7, 'If the temperature of an ideal gas is doubled while its pressure is kept constant, what happens to the volume of the gas?', 2, 'Medium'); -- tested and working


--topic_id 7/10 questions Physics /Thermodynamics /level Hard  (id 201-210)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES 
(7, 'A Carnot engine operates between a hot reservoir at 500 K and a cold reservoir at 300 K. What is the maximum possible efficiency of the engine?', 3, 'Hard'),
(7, 'The specific heat capacity of a substance is given as c = 500J/kg°C. How much heat is required to raise the temperature of 2 kg of the substance by 10°C?', 3, 'Hard'),
(7, 'A 1.5 kg block of ice at -5°C is placed in a room at 25°C. If the specific heat capacity of ice is 2.1 J/g°C and the latent heat of fusion is 334 J/g, how much energy is required to melt the ice and bring it to 0°C?', 3, 'Hard'),
(7, 'A thermodynamic system undergoes an isothermal expansion. If the system performs 150 J of work, how much heat does it absorb?', 3, 'Hard'),
(7, 'In an adiabatic process, the temperature of an ideal gas decreases. Which of the following is true about the process?', 3, 'Hard'),
(7, 'A piston containing 2 moles of an ideal gas is compressed adiabatically from a volume of 10 L to 5 L. If the initial temperature of the gas is 300 K, what is the final temperature? (Assume γ = 1.4)', 3, 'Hard'),
(7, 'The entropy change ΔS of a reversible process is defined by:', 3, 'Hard'),
(7, 'A heat engine operates between two reservoirs at 1000 K and 300 K. The engine absorbs 600 J of heat from the hot reservoir. What is the maximum possible work output of the engine?', 3, 'Hard'),
(7, 'An ideal gas undergoes an isothermal compression from a volume of 10 L to 5 L. If the initial temperature is 300 K and the final temperature is 300 K, what happens to the internal energy of the gas?', 3, 'Hard'),
(7, 'The latent heat of vaporization of water is 2260 J/g. How much heat is required to convert 100 g of water at 100°C into steam at 100°C?', 3, 'Hard');
-- tested and working

--topic_id=8
--10 questions Physics /Electromagnetism /level Easy  (id 211-220)
Insert into questions (topic_id, question_text, points, question_level)
VALUES
(8, 'What is the SI unit of electric current?', 1, 'Easy'),  
(8, 'In an electric field equation, what does the symbol "E" typically represent?', 1, 'Easy'),  
(8, 'Which of the following is the SI unit of electrical resistance?', 1, 'Easy'),  
(8, 'A resistor in a circuit has a voltage of 10 V across it and a current of 2 A. What is its resistance?', 1, 'Easy'),  
(8, 'Two charges of +3 μC each are placed 0.5 m apart in a vacuum. What is the electrostatic force between them?', 1, 'Easy'),  
(8, 'What is the direction of the magnetic field around a straight current-carrying wire?', 1, 'Easy'),  
(8, 'Which of the following materials is a good conductor of electricity?', 1, 'Easy'),  
(8, 'What is the SI unit of electric charge?', 1, 'Easy'),  
(8, 'What type of wave is an electromagnetic wave?', 1, 'Easy'),  
(8, 'What happens to the resistance of a conductor when its temperature increases?', 1, 'Easy'); -- tested and working 

--topic_id=8
--10 questions Physics /Electromagnetism /level Medium  (id 221-230)
Insert into questions (topic_id, question_text, points, question_level)
VALUES
(8, 'A current of 3 A flows through a conductor with a resistance of 4 Ω. What is the power dissipated in the conductor?', 2, 'Medium'),  
(8, 'What is the force per unit length between two parallel wires carrying currents of 5 A and 10 A, separated by a distance of 0.2 m?', 2, 'Medium'),  
(8, 'What is the potential difference between two points in an electric field if the electric field intensity is 500 N/C and the distance between the points is 2 m?', 2, 'Medium'),  
(8, 'A 12 V battery is connected to a 4 Ω resistor. What is the current flowing through the circuit?', 2, 'Medium'),  
(8, 'A capacitor has a capacitance of 5 μF and is charged to 100 V. How much energy is stored in the capacitor?', 2, 'Medium'),  
(8, 'A magnetic field of strength 0.2 T is applied perpendicular to a current-carrying wire. If the current in the wire is 3 A and the length of the wire in the field is 0.5 m, what is the force on the wire?', 2, 'Medium'),  
(8, 'What is the magnetic flux through a coil with 50 turns, each having an area of 0.02 m², when placed in a magnetic field of 0.5 T perpendicular to the area of the coil?', 2, 'Medium'),  
(8, 'What is the frequency of an electromagnetic wave with a wavelength of 3 × 10⁶ m in a vacuum?', 2, 'Medium'),  
(8, 'What is the induced emf in a coil of 100 turns when the magnetic flux changes by 0.5 Wb in 0.2 s?', 2, 'Medium'),  
(8, 'The energy stored in an inductor is 0.02 J when the current is 2 A. What is the inductance of the inductor?', 2, 'Medium');  --tested and working

--topic_id=8
--10 questions Physics /Electromagnetism /level Hard  (id 231-240)

insert into questions (topic_id, question_text, points, question_level)
values
(8, 'A coil has 500 turns and a cross-sectional area of 0.01 m². If the magnetic flux through the coil changes by 0.2 Wb in 0.5 s, what is the induced emf?', 3, 'Hard'),
(8, 'A magnetic field of 2 T is applied perpendicular to a coil of radius 0.1 m. If the number of turns in the coil is 100, what is the magnetic flux through the coil?', 3, 'Hard'),
(8, 'In a transformer, the primary coil has 200 turns and the secondary coil has 50 turns. If the primary voltage is 240 V, what is the secondary voltage?', 3, 'Hard'),
(8, 'A current of 3 A flows through a wire of length 0.5 m, placed perpendicular to a magnetic field of strength 0.4 T. What is the force on the wire?', 3, 'Hard'),
(8, 'A charged particle of mass 3 × 10⁻¹⁹ kg and charge 1 × 10⁻¹⁹ C moves with a velocity of 5 × 10⁵ m/s in a magnetic field of strength 0.3 T. What is the radius of the circular path it follows?', 3, 'Hard'),
(8, 'A capacitor of capacitance 4 μF is connected to a 12 V battery. After the capacitor is fully charged, what is the charge on the capacitor?', 3, 'Hard'),
(8, 'A coil of 100 turns is placed in a magnetic field that varies with time. The magnetic field changes from 0.2 T to 0.6 T in 0.1 s. What is the induced emf?', 3, 'Hard'),
(8, 'An electromagnetic wave has a frequency of 5 GHz. What is its wavelength in vacuum?', 3, 'Hard'),
(8, 'A magnetic field is applied to a straight wire carrying a current of 2 A. If the magnetic field is 1 T and the length of the wire in the field is 0.2 m, at what angle should the wire be positioned for the maximum force to act on it?', 3, 'Hard'),
(8, 'A moving charged particle enters a magnetic field at an angle of 30° to the magnetic field. If the velocity of the particle is 3 × 10⁶ m/s and the magnetic field strength is 0.4 T, what is the magnetic force on the particle if its charge is 1.5 × 10⁻¹⁹ C?', 3, 'Hard');
--tested and working



--topic_id=9
--10 questions  Operating systems /Memory management /level Easy  (id 241-250)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (9, 'What is the primary function of memory management in an operating system?', 1, 'Easy'),
  (9, 'Which of the following is a common memory management technique?', 1, 'Easy'),
  (9, 'What is virtual memory in operating systems?', 1, 'Easy'),
  (9, 'Which of these is an example of memory fragmentation?', 1, 'Easy'),
  (9, 'What does the operating system use to track memory usage?', 1, 'Easy'),
  (9, 'What is the difference between physical memory and virtual memory?', 1, 'Easy'),
  (9, 'Which of the following best describes paging in memory management?', 1, 'Easy'),
  (9, 'What does a memory leak refer to in an operating system?', 1, 'Easy'),
  (9, 'What is a page table in the context of virtual memory?', 1, 'Easy'),
  (9, 'How does the operating system manage memory allocation for processes?', 1, 'Easy');

--topic_id=9
--10 questions Operating systems /Memory management /level Medium   (id 251-260)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (9, 'What is the role of the memory management unit (MMU) in an operating system?', 2, 'Medium'),
  (9, 'What is the difference between contiguous and non-contiguous memory allocation?', 2, 'Medium'),
  (9, 'How does the operating system handle memory protection?', 2, 'Medium'),
  (9, 'Explain how a paging system works in virtual memory.', 2, 'Medium'),
  (9, 'What is a segmentation fault in operating systems?', 2, 'Medium'),
  (9, 'What is the difference between hard and soft page faults?', 2, 'Medium'),
  (9, 'What is thrashing in memory management?', 2, 'Medium'),
  (9, 'What are the advantages of using a demand paging system?', 2, 'Medium'),
  (9, 'What is memory swapping in operating systems?', 2, 'Medium'),
  (9, 'How does the operating system detect and handle memory leaks?', 2, 'Medium');

--topic_id=9
--10 questions Operating systems /Memory management /level Hard   (id 261-270)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (9, 'Explain the concept of memory-mapped I/O in operating systems.', 3, 'Hard'),
  (9, 'What are the challenges of managing memory in a multi-core system?', 3, 'Hard'),
  (9, 'How does the operating system handle large memory addresses in modern systems?', 3, 'Hard'),
  (9, 'What are the key advantages of using a 64-bit memory addressing scheme?', 3, 'Hard'),
  (9, 'Explain how a virtual memory system optimizes memory access performance.', 3, 'Hard'),
  (9, 'How does the operating system prevent illegal memory access between processes?', 3, 'Hard'),
  (9, 'What is the impact of having insufficient memory in a system?', 3, 'Hard'),
  (9, 'How does memory management differ in real-time operating systems?', 3, 'Hard'),
  (9, 'What are the different types of memory allocation strategies used in operating systems?', 3, 'Hard'),
  (9, 'Explain how memory compaction works in operating systems.', 3, 'Hard');
--tested and working

--topic_id=10
--10 questions Operating systems /Process management /level Easy    (id 271-280)
--10 questions Operating systems /Process management /level Medium  (id 281-290)
--10 questions Operating systems /Process management /level Hard  (id 291-300)

--topic_id=11
--10 questions Operating systems /File management /level Easy     (id 301-310)
--10 questions Operating systems /File management /level Medium (id 311-320)
--10 questions Operating systems /File management /level Hard (id 321-330)


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
  (1, 9),  (1, 10);

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
  --10 questions Math /Algebra /level Easy answers (id 1-30) 
  (1,'3', FALSE),  (1,'5', FALSE),  (1,'10', TRUE),         --question_id-1
  (2,'2', FALSE),  (2,'4', TRUE),  (2,'6', FALSE),      -- question_id 2
  (3,'3', FALSE),  (3,'2', TRUE),  (3,'6', FALSE),      --question_id 3
  (4,'9', FALSE),  (4,'10', TRUE),  (4,'12', FALSE),        --question_id 4
  (5,'7x', TRUE),  (5,'12x', FALSE),  (5,'3x4', FALSE),       --question_id 5
  (6,'6', FALSE),  (6,'11', TRUE),  (6,'8', FALSE),        --question_id 6
  (7,'x²', TRUE),  (7,'2x', FALSE),  (7,'x+1', FALSE),      --question_id 7
  (8,'4', TRUE),  (8,'6', FALSE),  (8,'8', FALSE),      --- question_id 8
  (9,'12', TRUE),  (9,'3', FALSE),  (9,'8', FALSE),         -- question_id 9
  (10,'3', FALSE),  (10,'2', TRUE),  (10,'4', FALSE);       -- question_id 10











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



