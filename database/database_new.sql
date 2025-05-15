




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
  (1,'What is the value of x in the equation: 2x + 3 = 11?', 1, 'Medium'),
  (1,'Solve for x: 3x - 5 = 10',1,'Medium'),
  (1,'What is 4x - 3 = 13 when solved for x?', 1, 'Medium'),
  (1,'What is the next term in the pattern: 3, 6, 9, 12, __?' , 1, 'Medium'),
  (1,'What is the simplified form of 4x + 5x?', 1, 'Medium'),
  (1,'If x = 4, what is the value of 3x + 6?', 1, 'Medium'),
  (1,'Which expression is equivalent to x * x * x?', 1, 'Medium'),
  (1,'If y = 15, what is y - 8?', 1, 'Medium'),
  (1,'Solve for x: x/3 = 7', 1, 'Medium'),
  (1,'What is the value of 4(x + 3) = 28?', 1, 'Medium');-- tested and working added in mainprogram
  

  
--topic_id =1,10 questions Math /Algebra /level Hard (id 21-30)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(1, 'Solve for x: 3x - 7 = 2x + 5', 1, 'Hard'),
(1, 'Factor completely: x^3 - 6x^2 + 11x - 6', 1, 'Hard'),
(1, 'Find the roots of the equation: 2x^2 - 5x - 3 = 0', 1, 'Hard'),
(1, 'Simplify: (2x - 3)(x + 4) - (x - 2)(x + 1)', 1, 'Hard'),
(1, 'Solve for x: (x + 2)/(x - 1) = (x - 3)/(x + 4)', 1, 'Hard'),
(1, 'Find the inverse function of f(x) = (3x - 4)/5', 1, 'Hard'),
(1, 'Determine the value of x in the system: 2x + 3y = 7 and 4x - y = 5', 1, 'Hard'),
(1, 'Solve the inequality: (x - 2)(x + 5) < 0', 1, 'Hard'),
(1, 'Evaluate the determinant of the matrix: | 2  -1 | | 3  4 |', 1, 'Hard'),
(1, 'Find the sum of the first 10 terms of the arithmetic sequence with first term 7 and common difference 3', 1, 'Hard'); -- tested and working


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
(2, 'If 12 workers complete a task in 8 days, how many days would 16 workers take?', 1, 'Medium'),
(2, 'Divide £1200 between Alice and Bob in the ratio 3:5.', 1, 'Medium'),
(2, 'If the ratio of boys to girls is 7:9 and there are 63 boys, how many girls are there?', 1, 'Medium'),
(2, 'Find the value of x if 4:x = 6:9.', 1, 'Medium'),
(2, 'If 15 kg of rice costs £45, how much would 9 kg cost?', 1, 'Medium'),
(2, 'A car travels 240 km on 30 liters of fuel. How much fuel is needed for 400 km?', 1, 'Medium'),
(2, 'In a class, the ratio of passed to failed students is 5:2. If 14 failed, how many passed?', 1, 'Medium'),
(2, 'Simplify the ratio 48:64.', 1, 'Medium'),
(2, 'If £500 is shared among 4 people in the ratio 1:2:3:4, how much does the second person get?', 1, 'Medium'),
(2, 'A map scale is 1:50000. What is the real distance if the map shows 4 cm?', 1, 'Medium');  -- tested and working 17/03


--topic_id 2 / 10 questions Math /Ratio and Proportion /level Hard (id 51-60)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(2, 'The ratio of incomes of A and B is 5:7 and the ratio of their expenses is 3:4. If A saves £800 and B saves £600, what is A\`s income?', 1, 'Hard'),
(2, 'A mixture contains alcohol and water in the ratio 3:2. If 20 liters of water are added, the ratio becomes 3:4. Find the quantity of alcohol in the mixture.', 1, 'Hard'),
(2, 'Three numbers are in the ratio 2:3:4. If their sum is 81, what is the largest number?', 1, 'Hard'),
(2, 'A sum of money is divided among A, B, and C in the ratio 5:6:7. If C gets £84 more than A, find the total amount.', 1, 'Hard'),
(2, 'The ratio of ages of two people is 4:5. After 6 years, the ratio becomes 5:6. Find their present ages.', 1, 'Hard'),
(2, 'Two alloys are mixed in the ratio 7:5. The first alloy contains copper and zinc in the ratio 2:1, and the second in the ratio 3:2. Find the ratio of copper to zinc in the new mixture.', 1, 'Hard'),
(2, 'The sides of a triangle are in the ratio 3:4:5, and its perimeter is 144 cm. Find the area of the triangle.', 1, 'Hard'),
(2, 'The monthly incomes of two persons are in the ratio 9:7, and their expenditures are in the ratio 4:3. If each saves £200, find their incomes.', 1, 'Hard'),
(2, 'If x:y = 7:9 and y:z = 4:5, find x:z.', 1, 'Hard'),
(2, 'A man spends 60% of his income. His income increases in the ratio 5:6, and his expenditure increases in the ratio 4:5. Find the ratio of his savings before and after the increase.', 1, 'Hard'); --tested and working



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
(3, 'A price increases from £250 to £300. What is the percentage increase?', 1, 'Medium'),
(3, '£90 is 60% of what amount?', 1, 'Medium'),
(3, 'If a number is increased by 25% and becomes 100, what was the original number?', 1, 'Medium'),
(3, 'A population of 2,000 decreases by 15%. What is the new population?', 1, 'Medium'),
(3, 'Find the percentage decrease when a value drops from 500 to 350.', 1, 'Medium'),
(3, 'If 30% of a number is 45, what is the number?', 1, 'Medium'),
(3, 'A bill of £240 includes a 20% service charge. What was the original amount before the charge?', 1, 'Medium'),
(3, 'A £400 TV is on sale with 15% off. What is the sale price?', 1, 'Medium'),
(3, 'A student scored 72 out of 80 in a test. What is the percentage score?', 1, 'Medium'),
(3, 'Increase £360 by 12.5%. What is the new total?', 1, 'Medium');     --tested and working





--topic_id=3 / 10 questions Math /Percentage /level Hard (id 81-90)

INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(3, 'A population increases from 12,000 to 15,600 in two years. What is the percentage increase?', 1, 'Hard'),
(3, 'A company\`s profit decreased from £250,000 to £200,000. What is the percentage decrease?', 1, 'Hard'),
(3, 'If £360 is 120% of a number, what is the number?', 1, 'Hard'),
(3, 'After a 30% discount, a laptop costs £700. What was the original price?', 1, 'Hard'),
(3, 'A value increases by 40% and becomes £980. What was the original value?', 1, 'Hard'),
(3, 'If a number is decreased by 20% and becomes 144, what was the original number?', 1, 'Hard'),
(3, 'A store raises its prices by 25%, then offers a 20% discount. What is the overall percentage change?', 1, 'Hard'),
(3, 'A salary of £45,000 is increased by 10% one year and then by 15% the next year. What is the final salary?', 1, 'Hard'),
(3, 'A product is marked up by 35% and then discounted by 15%. What is the net percentage change from the original price?', 1, 'Hard'),
(3, 'A car worth £24,000 depreciates by 18% in the first year and 12% in the second year. What is its value after two years?', 1, 'Hard'); --tested and working

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
(4, 'What does "gregarious" mean?', 1, 'Medium'),
(4, 'Which of the following is the closest synonym to "meticulous"?', 1, 'Medium'),
(4, 'What does "elusive" mean?', 1, 'Medium'),
(4, 'Which of the following means "to make something clear"?', 1, 'Medium'),
(4, 'What is the meaning of "cogent"?', 1, 'Medium'),
(4, 'Which word is closest in meaning to "ameliorate"?', 1, 'Medium'),
(4, 'What does "prolific" mean?', 1, 'Medium'),
(4, 'Which word means "having a sharp or biting taste"?', 1, 'Medium'),
(4, 'What does "ephemeral" refer to?', 1, 'Medium'),
(4, 'Which word means "feeling of doubt"?', 1, 'Medium'); --tested and working



--topick_id=4 / 10 questions English /Vocabulary /level Hard  (id 111-120)

-- Insert questions
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
(4, 'What does "pulchritude" mean?', 1, 'Hard'),
(4, 'Which of the following is a synonym of "recalcitrant"?', 1, 'Hard'),
(4, 'What does "sesquipedalian" refer to?', 1, 'Hard'),
(4, 'Which of the following is the meaning of "antediluvian"?', 1, 'Hard'),
(4, 'What does "sonder" mean?', 1, 'Hard'),
(4, 'Which word means "the act of walking slowly and aimlessly"?', 1, 'Hard'),
(4, 'What is the meaning of "vorfreude"?', 1, 'Hard'),
(4, 'Which word refers to an irrational fear of long words?', 1, 'Hard'),
(4, 'What does "cryptozoology" study?', 1, 'Hard'),
(4, 'What is the meaning of "zugzwang"?', 1, 'Hard');---tested and working







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
(5, 'What is the synonym of "Enormous"?', 1, 'Medium'),
(5, 'What is the opposite of "Benevolent"?', 1, 'Medium'),
(5, 'Choose the correct meaning of "Meticulous".', 1, 'Medium'),
(5, 'What is the synonym of "Fleeting"?', 1, 'Medium'),
(5, 'What is the opposite of "Tranquil"?', 1, 'Medium'),
(5, 'Choose the correct meaning of "Scrutinize".', 1, 'Medium'),
(5, 'What is the synonym of "Obstinate"?', 1, 'Medium'),
(5, 'What is the opposite of "Diligent"?', 1, 'Medium'),
(5, 'Choose the correct meaning of "Ambiguous".', 1, 'Medium'),
(5, 'What is the synonym of "Vigorous"?', 1, 'Medium'); --tested and working

--topic_id=5 / 10 questions English /Grammar /level Hard   (id 141-150)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(5, 'What is the synonym of "Obfuscate"?', 1, 'Hard'),
(5, 'What is the opposite of "Acerbic"?', 1, 'Hard'),
(5, 'Choose the correct meaning of "Proclivity".', 1, 'Hard'),
(5, 'What is the synonym of "Recalcitrant"?', 1, 'Hard'),
(5, 'What is the opposite of "Soporific"?', 1, 'Hard'),
(5, 'Choose the correct meaning of "Ubiquitous".', 1, 'Hard'),
(5, 'What is the synonym of "Intransigent"?', 1, 'Hard'),
(5, 'What is the opposite of "Ephemeral"?', 1, 'Hard'),
(5, 'Choose the correct meaning of "Pernicious".', 1, 'Hard'),
(5, 'What is the synonym of "Surreptitious"?', 1, 'Hard');  --tested and working




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
(6, 'A car accelerates from 10 m/s to 30 m/s in 5 seconds. What is the car\s average acceleration?', 1, 'Medium'),
(6, 'A 2 kg object is acted upon by a 10 N force. What is the acceleration of the object?', 1, 'Medium'),
(6, 'A 500 N force is applied to an object with a mass of 50 kg. What is the object\s acceleration?', 1, 'Medium'),
(6, 'What is the work done when a force of 20 N moves an object 5 meters in the direction of the force?', 1, 'Medium'),
(6, 'A ball is thrown vertically upwards with a speed of 20 m/s. What is the maximum height it will reach? (Assume g = 10 m/s²)', 1, 'Medium'),
(6, 'A 10 kg object is moving at 3 m/s. What is its kinetic energy?', 1, 'Medium'),
(6, 'A person applies a force of 50 N to push a box 4 meters across the floor. If the force is applied in the direction of motion, what is the work done?', 1, 'Medium'),
(6, 'If an object of mass 10 kg is moving at a velocity of 5 m/s, what is its momentum?', 1, 'Medium'),
(6, 'A 3 kg object is placed 2 meters above the ground. What is its potential energy relative to the ground? (Assume g = 10 m/s²)', 1, 'Medium'),
(6, 'A spring has a spring constant of 100 N/m. How much force is required to stretch it by 0.5 meters?', 1, 'Medium'); -- tested  and working


--topic_id - 6/ 10 questions Physics /Mechanics /level Hard   (id 171-180)
INSERT INTO questions (topic_id, question_text, points, question_level) VALUES
(6, 'A 10 kg block is placed on a frictionless surface and is acted upon by a horizontal force of 50 N. What is the speed of the block after 4 seconds?', 1, 'Hard'),
(6, 'A 2 kg object moves with a speed of 10 m/s. It collides with a wall and comes to a stop. What is the change in momentum?', 1, 'Hard'),
(6, 'A 4 kg mass is attached to a spring with a spring constant of 200 N/m. If the mass is displaced by 0.1 m, what is the potential energy stored in the spring?', 1, 'Hard'),
(6, 'A 5 kg object is moving with a velocity of 4 m/s. The object collides with a 2 kg object moving at 3 m/s. If the collision is perfectly elastic, what is the velocity of the 5 kg object after the collision?', 1, 'Hard'),
(6, 'A car of mass 1000 kg is moving at 25 m/s. The car’s engine exerts a constant force of 2000 N. How long does it take for the car to accelerate to 35 m/s?', 1, 'Hard'),
(6, 'A 2 kg object is attached to a string and swings in a circular path with a radius of 4 m. If the object has a speed of 6 m/s, what is the centripetal force acting on the object?', 1, 'Hard'),
(6, 'A 10 kg object is dropped from a height of 50 m. What will its speed be just before it hits the ground? (Assume no air resistance and g = 10 m/s²)', 1, 'Hard'),
(6, 'A 2 kg object is attached to a vertical spring with a spring constant of 150 N/m. What is the period of oscillation of the object?', 1, 'Hard'),
(6, 'A 0.5 kg object is moving in a circular path with a radius of 2 m and a speed of 8 m/s. What is the object\s angular velocity?', 1, 'Hard'),
(6, 'A 50 kg person is standing in an elevator. If the elevator accelerates upward at 2 m/s², what is the normal force exerted on the person? (Assume g = 10 m/s²)', 1, 'Hard'); -- tested and working

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
(7, 'In an isothermal process, what remains constant?', 1, 'Medium'),
(7, 'Which of the following is true for an adiabatic process?', 1, 'Medium'),
(7, 'A heat engine absorbs 400 J of heat from a hot reservoir and expels 200 J of heat to a cold reservoir. What is the efficiency of the engine?', 1, 'Medium'),
(7, 'What is the change in internal energy for an ideal gas undergoing an isochoric process (constant volume)?', 1, 'Medium'),
(7, 'A substance undergoes a phase change from liquid to gas. Which of the following is true during the phase transition?', 1, 'Medium'),
(7, 'Which of the following represents the second law of thermodynamics?', 1, 'Medium'),
(7, 'In a Carnot engine, if the temperature of the hot reservoir is 600 K and the cold reservoir is 300 K, what is the maximum possible efficiency?', 1, 'Medium'),
(7, 'When a gas undergoes an isothermal expansion, which of the following is true?', 1, 'Medium'),
(7, 'Which of the following factors does NOT affect the efficiency of a heat engine?', 1, 'Medium'),
(7, 'If the temperature of an ideal gas is doubled while its pressure is kept constant, what happens to the volume of the gas?', 1, 'Medium'); -- tested and working


--topic_id 7/10 questions Physics /Thermodynamics /level Hard  (id 201-210)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES 
(7, 'A Carnot engine operates between a hot reservoir at 500 K and a cold reservoir at 300 K. What is the maximum possible efficiency of the engine?', 1, 'Hard'),
(7, 'The specific heat capacity of a substance is given as c = 500J/kg°C. How much heat is required to raise the temperature of 2 kg of the substance by 10°C?', 1, 'Hard'),
(7, 'A 1.5 kg block of ice at -5°C is placed in a room at 25°C. If the specific heat capacity of ice is 2.1 J/g°C and the latent heat of fusion is 334 J/g, how much energy is required to melt the ice and bring it to 0°C?', 1, 'Hard'),
(7, 'A thermodynamic system undergoes an isothermal expansion. If the system performs 150 J of work, how much heat does it absorb?', 1, 'Hard'),
(7, 'In an adiabatic process, the temperature of an ideal gas decreases. Which of the following is true about the process?', 1, 'Hard'),
(7, 'A piston containing 2 moles of an ideal gas is compressed adiabatically from a volume of 10 L to 5 L. If the initial temperature of the gas is 300 K, what is the final temperature? (Assume γ = 1.4)', 1, 'Hard'),
(7, 'The entropy change ΔS of a reversible process is defined by:', 1, 'Hard'),
(7, 'A heat engine operates between two reservoirs at 1000 K and 300 K. The engine absorbs 600 J of heat from the hot reservoir. What is the maximum possible work output of the engine?', 1, 'Hard'),
(7, 'An ideal gas undergoes an isothermal compression from a volume of 10 L to 5 L. If the initial temperature is 300 K and the final temperature is 300 K, what happens to the internal energy of the gas?', 1, 'Hard'),
(7, 'The latent heat of vaporization of water is 2260 J/g. How much heat is required to convert 100 g of water at 100°C into steam at 100°C?', 1, 'Hard');
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
(8, 'A current of 3 A flows through a conductor with a resistance of 4 Ω. What is the power dissipated in the conductor?', 1, 'Medium'),  
(8, 'What is the force per unit length between two parallel wires carrying currents of 5 A and 10 A, separated by a distance of 0.2 m?', 1, 'Medium'),  
(8, 'What is the potential difference between two points in an electric field if the electric field intensity is 500 N/C and the distance between the points is 2 m?', 1, 'Medium'),  
(8, 'A 12 V battery is connected to a 4 Ω resistor. What is the current flowing through the circuit?', 1, 'Medium'),  
(8, 'A capacitor has a capacitance of 5 μF and is charged to 100 V. How much energy is stored in the capacitor?', 1, 'Medium'),  
(8, 'A magnetic field of strength 0.2 T is applied perpendicular to a current-carrying wire. If the current in the wire is 3 A and the length of the wire in the field is 0.5 m, what is the force on the wire?', 1, 'Medium'),  
(8, 'What is the magnetic flux through a coil with 50 turns, each having an area of 0.02 m², when placed in a magnetic field of 0.5 T perpendicular to the area of the coil?', 1, 'Medium'),  
(8, 'What is the frequency of an electromagnetic wave with a wavelength of 3 × 10⁶ m in a vacuum?', 1, 'Medium'),  
(8, 'What is the induced emf in a coil of 100 turns when the magnetic flux changes by 0.5 Wb in 0.2 s?', 1, 'Medium'),  
(8, 'The energy stored in an inductor is 0.02 J when the current is 2 A. What is the inductance of the inductor?', 1, 'Medium');  --tested and working

--topic_id=8
--10 questions Physics /Electromagnetism /level Hard  (id 231-240)

insert into questions (topic_id, question_text, points, question_level)
values
(8, 'A coil has 500 turns and a cross-sectional area of 0.01 m². If the magnetic flux through the coil changes by 0.2 Wb in 0.5 s, what is the induced emf?', 1, 'Hard'),
(8, 'A magnetic field of 2 T is applied perpendicular to a coil of radius 0.1 m. If the number of turns in the coil is 100, what is the magnetic flux through the coil?', 1, 'Hard'),
(8, 'In a transformer, the primary coil has 200 turns and the secondary coil has 50 turns. If the primary voltage is 240 V, what is the secondary voltage?', 1, 'Hard'),
(8, 'A current of 3 A flows through a wire of length 0.5 m, placed perpendicular to a magnetic field of strength 0.4 T. What is the force on the wire?', 1, 'Hard'),
(8, 'A charged particle of mass 3 × 10⁻¹⁹ kg and charge 1 × 10⁻¹⁹ C moves with a velocity of 5 × 10⁵ m/s in a magnetic field of strength 0.3 T. What is the radius of the circular path it follows?', 1, 'Hard'),
(8, 'A capacitor of capacitance 4 μF is connected to a 12 V battery. After the capacitor is fully charged, what is the charge on the capacitor?', 1, 'Hard'),
(8, 'A coil of 100 turns is placed in a magnetic field that varies with time. The magnetic field changes from 0.2 T to 0.6 T in 0.1 s. What is the induced emf?', 1, 'Hard'),
(8, 'An electromagnetic wave has a frequency of 5 GHz. What is its wavelength in vacuum?', 1, 'Hard'),
(8, 'A magnetic field is applied to a straight wire carrying a current of 2 A. If the magnetic field is 1 T and the length of the wire in the field is 0.2 m, at what angle should the wire be positioned for the maximum force to act on it?', 1, 'Hard'),
(8, 'A moving charged particle enters a magnetic field at an angle of 30° to the magnetic field. If the velocity of the particle is 3 × 10⁶ m/s and the magnetic field strength is 0.4 T, what is the magnetic force on the particle if its charge is 1.5 × 10⁻¹⁹ C?', 1, 'Hard');
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
  (9, 'What is the role of the memory management unit (MMU) in an operating system?', 1, 'Medium'),
  (9, 'What is the difference between contiguous and non-contiguous memory allocation?', 1, 'Medium'),
  (9, 'How does the operating system handle memory protection?', 1, 'Medium'),
  (9, 'Explain how a paging system works in virtual memory.', 1, 'Medium'),
  (9, 'What is a segmentation fault in operating systems?', 1, 'Medium'),
  (9, 'What is the difference between hard and soft page faults?', 1, 'Medium'),
  (9, 'What is thrashing in memory management?', 1, 'Medium'),
  (9, 'What are the advantages of using a demand paging system?', 1, 'Medium'),
  (9, 'What is memory swapping in operating systems?', 1, 'Medium'),
  (9, 'How does the operating system detect and handle memory leaks?', 1, 'Medium');

--topic_id=9
--10 questions Operating systems /Memory management /level Hard   (id 261-270)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (9, 'Explain the concept of memory-mapped I/O in operating systems.', 1, 'Hard'),
  (9, 'What are the challenges of managing memory in a multi-core system?', 1, 'Hard'),
  (9, 'How does the operating system handle large memory addresses in modern systems?', 1, 'Hard'),
  (9, 'What are the key advantages of using a 64-bit memory addressing scheme?', 1, 'Hard'),
  (9, 'Explain how a virtual memory system optimizes memory access performance.', 1, 'Hard'),
  (9, 'How does the operating system prevent illegal memory access between processes?', 1, 'Hard'),
  (9, 'What is the impact of having insufficient memory in a system?', 1, 'Hard'),
  (9, 'How does memory management differ in real-time operating systems?', 1, 'Hard'),
  (9, 'What are the different types of memory allocation strategies used in operating systems?', 1, 'Hard'),
  (9, 'Explain how memory compaction works in operating systems.', 1, 'Hard');
--tested and working

--topic_id=10
--10 questions Operating systems /Process management /level Easy   (id 271-280)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (10, 'What is a process in an operating system?', 1, 'Easy'),
  (10, 'Which system call is used to create a new process in Unix?', 1, 'Easy'),
  (10, 'What is the Process Control Block (PCB)?', 1, 'Easy'),
  (10, 'Which state indicates a process is waiting for an event?', 1, 'Easy'),
  (10, 'What is the parent process?', 1, 'Easy'),
  (10, 'Which of the following is not a process state?', 1, 'Easy'),
  (10, 'What does the "init" process do in Unix systems?', 1, 'Easy'),
  (10, 'What is the purpose of the "exec" system call?', 1, 'Easy'),
  (10, 'Which of the following is a valid process state?', 1, 'Easy'),
  (10, 'What is the purpose of process scheduling?', 1, 'Easy'); ---tested and working



--10 questions Operating systems /Process management /level Medium  (id 281-290)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (10, 'What is context switching in process management?', 1, 'Medium'),
  (10, 'Which scheduling algorithm is preemptive?', 1, 'Medium'),
  (10, 'What is the purpose of a semaphore?', 1, 'Medium'),
  (10, 'What is a zombie process?', 1, 'Medium'),
  (10, 'Which of the following is a non-preemptive scheduling algorithm?', 1, 'Medium'),
  (10, 'What is inter-process communication (IPC)?', 1, 'Medium'),
  (10, 'What is the main disadvantage of the First-Come, First-Served scheduling algorithm?', 1, 'Medium'),
  (10, 'What is the purpose of the "wait()" system call?', 1, 'Medium'),
  (10, 'Which of the following is true about multithreading?', 1, 'Medium'),
  (10, 'What is the difference between user-level and kernel-level threads?', 1, 'Medium');---tested and working


--10 questions Operating systems /Process management /level Hard  (id 291-300)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (10, 'What is the purpose of the "nice" command in Unix?', 1, 'Hard'),
  (10, 'What is a race condition in process management?', 1, 'Hard'),
  (10, 'What is the main goal of the Banker`s Algorithm?', 1, 'Hard'),
  (10, 'What is the difference between a mutex and a semaphore?', 1, 'Hard'),
  (10, 'What is the purpose of the "kill" command in Unix?', 1, 'Hard'),
  (10, 'What is the difference between a thread and a process?', 1, 'Hard'),
  (10, 'What is the purpose of the "ps" command in Unix?', 1, 'Hard'),
  (10, 'What is the difference between cooperative and preemptive multitasking?', 1, 'Hard'),
  (10, 'What is the purpose of the "top" command in Unix?', 1, 'Hard'),
  (10, 'What is the difference between a hard and soft real-time system?', 1, 'Hard'); ---tested and working 



--topic_id=11
--10 questions Operating systems /File management /level Easy     (id 301-310)

INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (11, 'What is a file in an operating system?', 1, 'Easy'),
  (11, 'Which of the following is a file attribute?', 1, 'Easy'),
  (11, 'What is the purpose of a directory?', 1, 'Easy'),
  (11, 'Which of the following is a common file system?', 1, 'Easy'),
  (11, 'What does the file extension ".txt" usually represent?', 1, 'Easy'),
  (11, 'What is the function of the open() system call?', 1, 'Easy'),
  (11, 'Which operation is used to permanently remove a file?', 1, 'Easy'),
  (11, 'What is the difference between absolute and relative file paths?', 1, 'Easy'),
  (11, 'What is a file descriptor?', 1, 'Easy'),
  (11, 'Which component manages access permissions for files?', 1, 'Easy'); --tested and working


--10 questions Operating systems /File management /level Medium (id 311-320)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (11, 'What is the function of an inode in a file system?', 1, 'Medium'),
  (11, 'Which file allocation method links blocks together using pointers?', 1, 'Medium'),
  (11, 'What is the purpose of a file access control list (ACL)?', 1, 'Medium'),
  (11, 'How does the FAT file system maintain file locations?', 1, 'Medium'),
  (11, 'Which file operation allows reading a specific position in a file?', 1, 'Medium'),
  (11, 'What is the difference between hard links and symbolic links?', 1, 'Medium'),
  (11, 'Which command in UNIX is used to change file permissions?', 1, 'Medium'),
  (11, 'How does journaling help in file systems?', 1, 'Medium'),
  (11, 'What is file fragmentation?', 1, 'Medium'),
  (11, 'Which system call is used to create a new file in UNIX?', 1, 'Medium'); --tested and working


--10 questions Operating systems /File management /level Hard (id 321-330)
INSERT INTO questions (topic_id, question_text, points, question_level) 
VALUES
  (11, 'What is the primary advantage of indexed file allocation?', 1, 'Hard'),
  (11, 'How does an operating system handle file system mounting?', 1, 'Hard'),
  (11, 'What is the role of the VFS (Virtual File System)?', 1, 'Hard'),
  (11, 'Describe the process of lazy writing in file systems.', 1, 'Hard'),
  (11, 'What causes file system corruption?', 1, 'Hard'),
  (11, 'What is copy-on-write in file systems?', 1, 'Hard'),
  (11, 'Explain the concept of multi-level indexing in file allocation.', 1, 'Hard'),
  (11, 'How does the OS detect and recover from file system inconsistencies?', 1, 'Hard'),
  (11, 'What is the difference between synchronous and asynchronous file writes?', 1, 'Hard'),
  (11, 'Why are log-structured file systems used in SSDs?', 1, 'Hard'); --tested and working



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

  -- quiz 2 algebra medium
--question_id 11 -20
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
    (2, 11),  (2, 12), 
    (2, 13),  (2, 14),
    (2, 15),  (2, 16),
    (2, 17),  (2, 18),  
    (2, 19),  (2, 20); --tested 

-- quiz 3 algebra hard
--question_id 21 -30    
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
    (3, 21),  (3, 22), 
    (3, 23),  (3, 24),
    (3, 25),  (3, 26),
    (3, 27),  (3, 28),  
    (3, 29),  (3, 30); --tested

    --Ratio and Proportion Quiz 1 easy 31-40
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (4, 31),  (4, 32), 
  (4, 33),  (4, 34),
  (4, 35),  (4, 36),
  (4, 37),  (4, 38),  
  (4, 39),  (4, 40);-- tested and working


  --Ratio and Proportion Quiz 2 medium 41-50
INSERT INTO
  quiz_questions(
    quiz_id, question_id)   
VALUES
  (5, 41),  (5, 42), 
  (5, 43),  (5, 44),
  (5, 45),  (5, 46),
  (5, 47),  (5, 48),  
  (5, 49),  (5, 50);-- tested and working 17/08 

 ---Ratio and Proportion Quiz 3 51-60
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (6, 51),  (6, 52), 
  (6, 53),  (6, 54),
  (6, 55),  (6, 56),
  (6, 57),  (6, 58),  
  (6, 59),  (6, 60);-- tested and working 17/08

  --Percentage Quiz 1 61-70
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (7, 61),  (7, 62), 
  (7, 63),  (7, 64),
  (7, 65),  (7, 66),
  (7, 67),  (7, 68),  
  (7, 69),  (7, 70);-- tested and working 17/08

  --Percentage Quiz 2 /71-80
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (8, 71),  (8, 72), 
  (8, 73),  (8, 74),
  (8, 75),  (8, 76),
  (8, 77),  (8, 78),  
  (8, 79),  (8, 80);-- tested and working 17/08

  --Percentage Quiz 3 /81-90
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (9, 81),  (9, 82), 
  (9, 83),  (9, 84),
  (9, 85),  (9, 86),
  (9, 87),  (9, 88),  
  (9, 89),  (9, 90);-- tested and working 17/03

  
  --Vocabulary Quiz 1 /91-100
  INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (10, 91),  (10, 92), 
  (10, 93),  (10, 94),
  (10, 95),  (10, 96),
  (10, 97),  (10, 98),  
  (10, 99),  (10, 100);-- tested and working 17/03

--- Vocabulary Quiz 2 /101-110
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (11, 101),  (11, 102), 
  (11, 103),  (11, 104),
  (11, 105),  (11, 106),
  (11, 107),  (11, 108),  
  (11, 109),  (11, 110);-- tested and working 17/03


--- Vocabulary Quiz 3 /111-120
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (12, 111),  (12, 112), 
  (12, 113),  (12, 114),
  (12, 115),  (12, 116),
  (12, 117),  (12, 118),  
  (12, 119),  (12, 120);-- tested and working 17/03

  
  --Grammar Quiz 1  121-130
  INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (13, 121),  (13, 122), 
  (13, 123),  (13, 124),
  (13, 125),  (13, 126),
  (13, 127),  (13, 128),  
  (13, 129),  (13, 130);-- tested and working 17/03

---Grammar Quiz 2 131-140
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (14, 131),  (14, 132), 
  (14, 133),  (14, 134),
  (14, 135),  (14, 136),
  (14, 137),  (14, 138),  
  (14, 139),  (14, 140);-- tested and working 17/03


--- ---Grammar Quiz 3 141-150
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (15, 141),  (15, 142), 
  (15, 143),  (15, 144),
  (15, 145),  (15, 146),
  (15, 147),  (15, 148),  
  (15, 149),  (15, 150);-- tested and working 17/03

 
 --Mechanics Quiz 1 /151-160
  INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (16, 151),  (16, 152), 
  (16, 153),  (16, 154),
  (16, 155),  (16, 156),
  (16, 157),  (16, 158),  
  (16, 159),  (16, 160);-- tested and working 17/03

  --Mechanics Quiz 2 /161-170
  INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (17, 161),  (17, 162), 
  (17, 163),  (17, 164),
  (17, 165),  (17, 166),
  (17, 167),  (17, 168),  
  (17, 169),  (17, 170);-- tested and working 17/03


-- Mechanics Quiz 3 /171-180
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (18, 171),  (18, 172), 
  (18, 173),  (18, 174),
  (18, 175),  (18, 176),
  (18, 177),  (18, 178),  
  (18, 179),  (18, 180);-- tested and working 17/03

  --Thermodynamics Quiz 1/ 181-190
  INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (19, 181),  (19, 182), 
  (19, 183),  (19, 184),
  (19, 185),  (19, 186),
  (19, 187),  (19, 188),  
  (19, 189),  (19, 190);-- tested and working 17/03

 
 --Thermodynamics Quiz 2/ 191-200
  INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (20, 191),  (20, 192), 
  (20, 193),  (20, 194),
  (20, 195),  (20, 196),
  (20, 197),  (20, 198),  
  (20, 199),  (20, 200);-- tested and working 17/03

 
 --Thermodynamics Quiz 3 / 201-210
  INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (21, 201),  (21, 202), 
  (21, 203),  (21, 204),
  (21, 205),  (21, 206),
  (21, 207),  (21, 208),  
  (21, 209),  (21, 210);-- tested and working 17/03

  

 --Electromagnetism Quiz 1 / 211-220
 INSERT INTO quiz_questions(
    quiz_id, question_id)
VALUES
  (22, 211),  (22, 212), 
  (22, 213),  (22, 214),
  (22, 215),  (22, 216),
  (22, 217),  (22, 218),  
  (22, 219),  (22, 220);-- tested and working 17/03

  --Electromagnetism Quiz 2 / 221-230
  INSERT INTO quiz_questions(
      quiz_id, question_id)
  VALUES
    (23, 221),  (23, 222), 
    (23, 223),  (23, 224),
    (23, 225),  (23, 226),
    (23, 227),  (23, 228),  
    (23, 229),  (23, 230);-- tested and working 17/03

 --Electromagnetism Quiz 3 / 231-240
  INSERT INTO quiz_questions(
      quiz_id, question_id)
  VALUES
    (24, 231),  (24, 232), 
    (24, 233),  (24, 234),
    (24, 235),  (24, 236),
    (24, 237),  (24, 238),  
    (24, 239),  (24, 240);-- tested and working 17/03



    --Memory management Quiz 1/ 241-250
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (25, 241),  (25, 242), 
      (25, 243),  (25, 244),
      (25, 245),  (25, 246),
      (25, 247),  (25, 248),  
      (25, 249),  (25, 250);-- tested and working 17/03

      --Memory management Quiz 2/ 251-260
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (26, 251),  (26, 252), 
      (26, 253),  (26, 254),
      (26, 255),  (26, 256),
      (26, 257),  (26, 258),  
      (26, 259),  (26, 260);-- tested and working 17/03

      --Memory management Quiz 3/ 261-270
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (27, 261),  (27, 262), 
      (27, 263),  (27, 264),
      (27, 265),  (27, 266),
      (27, 267),  (27, 268),  
      (27, 269),  (27, 270);-- tested and working 17/03

      --Process management Quiz 1/ 271-280 tested
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (28, 271),  (28, 272), 
      (28, 273),  (28, 274),
      (28, 275),  (28, 276),
      (28, 277),  (28, 278),  
      (28, 279),  (28, 280);

      --Process management Quiz 2 / 281-290 tested
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (29, 281),  (29, 282), 
      (29, 283),  (29, 284),
      (29, 285),  (29, 286),
      (29, 287),  (29, 288),  
      (29, 289),  (29, 290);

 --Process management Quiz 3 / 291-300 tested
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (30, 291),  (30, 292), 
      (30, 293),  (30, 294),
      (30, 295),  (30, 296),
      (30, 297),  (30, 298),  
      (30, 299),  (30, 300);



-- File management Quiz 1 / 301-310 tested
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (31, 301),  (31, 302), 
      (31, 303),  (31, 304),
      (31, 305),  (31, 306),
      (31, 307),  (31, 308),  
      (31, 309),  (31, 310);

-- File management Quiz 2 / 311-320 tested
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (32, 311),  (32, 312), 
      (32, 313),  (32, 314),
      (32, 315),  (32, 316),
      (32, 317),  (32, 318),  
      (32, 319),  (32, 320);

--File management Quiz 3 / 321-330 tested
    INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES
      (33, 321),  (33, 322), 
      (33, 323),  (33, 324),
      (33, 325),  (33, 326),
      (33, 327),  (33, 328),  
      (33, 329),  (33, 330);



---math exam contain mixed questions from all topics / quiz_id 34 
--topic_1-algebra/ question_id 1-30 , topic_2-ratio and proportion / question_id 31-60, topic_3-percentage / question_id 61-90
  
INSERT INTO quiz_questions(
        quiz_id, question_id)
    VALUES 
(34, 3), (34, 8),   
(34, 12), (34, 27),  
(34, 33),  (34, 36),  
(34, 40), (34, 45),  
(34, 50),  (34, 61),  
(34, 66),  (34, 70),  
(34, 75), (34, 82),  
(34, 89);  -- tested and working 

      

--- english exam - quiz_id 35, contain mixed questions from all topics
--topic_4-english / question_id 91-120, topic_5-grammar / question_id 121-150,

INSERT INTO quiz_questions (quiz_id, question_id)
VALUES 
(35, 92), (35, 97),   
(35, 101), (35, 108),  
(35, 115),  (35, 121),  
(35, 125), (35, 128),  
(35, 132),  (35, 137),  
(35, 141),  (35, 144),  
(35, 147),  (35, 118),  
(35, 110);      -- tested and working

--- physics exam quiz_id 36 contain mixed questions from all topics
---topic_6-mechanics / question_id 151-180, topic_7-thermodynamics / question_id 181-210, topic_8-electromagnetism / question_id 211-240,

INSERT INTO quiz_questions (quiz_id, question_id)
VALUES 
(36, 153),(36, 159),
(36, 165),(36, 172),
(36, 178),(36, 183),
(36, 187),(36, 192),
(36, 198),(36, 209),
(36, 215),(36, 221),
(36, 228),(36, 234),
(36, 239);  -- tested and working

--- operating systems exam contain mixed questions from all topics
---topic_9-memory management / question_id 241-270, topic_10-process management / question_id 271-300, topic_11-file management / question_id 301-330

INSERT INTO quiz_questions (quiz_id, question_id)
VALUES 
(37, 243),(37, 248),
(37, 255),(37, 262),
(37, 269),(37, 273),
(37, 278),(37, 284),
(37, 291),(37, 299),
(37, 305),(37, 312),
(37, 318),(37, 324),
(37, 330);
-- tested and working

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

INSERT INTO
  answers (question_id,answer_text, is_correct)
VALUES


---10 questions (id 11-20) Math /Algebra /level Medium answers (id 31-60) tested and working
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


---10 questions (id 21-30) Math /Algebra /level Hard answers (id 61-90) 
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
(30, '167', FALSE); ---for quest 30 tested and working





---10 questions (id 31-40) Math /Ratio and Proportion /level Easy answers (id 91-120) 
INSERT INTO answers (question_id, answer_text, is_correct) VALUES

(31, '2:1', TRUE),
(31, '1:4', FALSE)
,(31, '4:8', FALSE),  -- Que 31

(32, '3:1', TRUE),
(32, '5:3', FALSE),
(32, '15:1', FALSE), -- Qq 32

(33, '£12', TRUE),
(33, '£9', FALSE),
(33, '£18', FALSE), --33

(34, '10', TRUE),
(34, '8', FALSE),
(34, '6', FALSE), --- Q 34

(35, '£4', TRUE),
(35, '£5', FALSE),
(35, '£6', FALSE), -- 35

(36, '1:3', TRUE),
(36, '3:1', FALSE),
(36, '2:1', FALSE), -- 36

(37, '4 cups', TRUE),
(37, '5 cups', FALSE),
(37, '2 cups', FALSE), -- Q37

(38, '12', TRUE),
(38, '14', FALSE),
(38, '10', FALSE), -- Q 38

(39, '£24 and £36', TRUE),
(39, '£30 and £30', FALSE),
(39, '£20 and £40', FALSE), -- Q39

(40, '£3', TRUE),
(40, '£4', FALSE),
(40, '£2', FALSE); -- Q 40  tested and working 17/08




---10 questions (id 41-50) Math /Ratio and Proportion /level Medium answers (id 121-150) 

INSERT INTO answers (question_id, answer_text, is_correct) VALUES

(41, '6 days', TRUE),
(41, '10 days', FALSE),
(41, '12 days', FALSE), -- Q 41

(42, '£450 and £750', TRUE),
(42, '£400 and £800', FALSE),
(42, '£500 and £700', FALSE),--  42
(43, '81', TRUE),
(43, '72', FALSE),
(43, '90', FALSE),----43

(44, '6', TRUE),
(44, '8', FALSE),
(44, '9', FALSE),--44

(45, '£27', TRUE),
(45, '£30', FALSE),
(45, '£24', FALSE),--45

(46, '50 liters', TRUE),
(46, '40 liters', FALSE),
(46, '60 liters', FALSE),--46

(47, '35', TRUE),
(47, '30', FALSE),
(47, '28', FALSE),--47

(48, '3:4', TRUE),
(48, '4:5', FALSE),
(48, '5:6', FALSE),--48

(49, '£100', TRUE),
(49, '£150', FALSE),
(49, '£200', FALSE),--49

(50, '2 km', TRUE),(
  50, '4 km', FALSE),
  (50, '5 km', FALSE);---50 tested and working



---10 questions (id 51-60) Math /Ratio and Proportion /level Hard answers (id 151-180) 

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
--  51
(51, '£4000', TRUE),
(51, '£3800', FALSE),
(51, '£4200', FALSE),
--  52
(52, '30 liters', TRUE),
(52, '25 liters', FALSE),
(52, '35 liters', FALSE),
-- 53
(53, '36', TRUE),
(53, '32', FALSE),
(53, '40', FALSE),
--  54
(54, '£396', TRUE),
(54, '£360', FALSE),
(54, '£420', FALSE),
--  55
(55, '24 and 30 years', TRUE),
(55, '20 and 25 years', FALSE),
(55, '18 and 24 years', FALSE),
--  56
(56, '29:16', TRUE),
(56, '31:19', FALSE),
(56, '27:14', FALSE),
-- 57
(57, '864 cm²', TRUE),
(57, '756 cm²', FALSE),
(57, '912 cm²', FALSE),
-- 58
(58, '£1800 and £1400', TRUE),
(58, '£1600 and £1200', FALSE),
(58, '£2000 and £1500', FALSE),
--  59
(59, '28:45', TRUE),
(59, '30:43', FALSE),
(59, '32:47', FALSE),
--  60
(60, '5:9', TRUE),
(60, '4:7', FALSE),
(60, '6:11', FALSE);  -- tested and working




---10 questions (id 61-70) Math /Percentage /level Easy answers (id 181-210) 
INSERT INTO answers (question_id, answer_text, is_correct) VALUES

(61, '50', TRUE),
(61, '40', FALSE),
(61, '60', FALSE),--61
(62, '£72', TRUE),
(62, '£75', FALSE),
(62, '£70', FALSE),
(63, '20%', TRUE),
(63, '25%', FALSE),
(63, '15%', FALSE),
(64, '£138', TRUE),
(64, '£140', FALSE),
(64, '£135', FALSE),
(65, '50', TRUE),
(65, '40', FALSE),
(65, '60', FALSE),
(66, '50', TRUE),
(66, '40', FALSE),
(66, '60', FALSE),
(67, '£150', TRUE),
(67, '£160', FALSE),
(67, '£155', FALSE),
(68, '50%', TRUE),
(68, '45%', FALSE),
(68, '40%', FALSE),
(69, '20%', TRUE),
(69, '15%', FALSE),
(69, '25%', FALSE),
(70, '£120', TRUE),
(70, '£130', FALSE),
(70, '£110', FALSE); --70 tested and working



---10 questions (id 71-80) Math /Percentage /level Medium answers (id 211-240) 

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
--71
(71, '20%', TRUE),
(71, '15%', FALSE),
(71, '25%', FALSE),
--72
(72, '£150', TRUE),
(72, '£120', FALSE),
(72, '£180', FALSE),
--73
(73, '80', TRUE),
(73, '75', FALSE),
(73, '85', FALSE),
--74
(74, '1,700', TRUE),
(74, '1,800', FALSE),
(74, '1,750', FALSE),
--75
(75, '30%', TRUE),
(75, '25%', FALSE),
(75, '35%', FALSE),
--76
(76, '150', TRUE),
(76, '135', FALSE),
(76, '165', FALSE),
--77
(77, '£200', TRUE),
(77, '£190', FALSE),
(77, '£210', FALSE),
--78
(78, '£340', TRUE),
(78, '£350', FALSE),
(78, '£330', FALSE),
--79
(79, '90%', TRUE),
(79, '85%', FALSE),
(79, '95%', FALSE),
--80
(80, '£405', TRUE),
(80, '£410', FALSE),
(80, '£400', FALSE);


---10 questions (id 81-90) Math /Percentage /level Hard answers (id 241-270) 
INSERT INTO answers (question_id, answer_text, is_correct) VALUES
-- Question 81
(81, '30%', TRUE),
(81, '25%', FALSE),
(81, '28%', FALSE),

-- Question 82
(82, '20%', TRUE),
(82, '18%', FALSE),
(82, '22%', FALSE),

-- Question 83
(83, '£300', TRUE),
(83, '£320', FALSE),
(83, '£280', FALSE),

-- Question 84
(84, '£1,000', TRUE),
(84, '£950', FALSE),
(84, '£1,050', FALSE),

-- Question 85
(85, '£700', TRUE),
(85, '£680', FALSE),
(85, '£720', FALSE),

-- Question 86
(86, '180', TRUE),
(86, '175', FALSE),
(86, '185', FALSE),

-- Question 87
(87, '0%', TRUE),
(87, '5%', FALSE),
(87, '-5%', FALSE),

-- Question 88
(88, '£56,925', TRUE),
(88, '£55,000', FALSE),
(88, '£54,750', FALSE),

-- Question 89
(89, '14.75%', TRUE),
(89, '10%', FALSE),
(89, '12.5%', FALSE),

-- Question 90
(90, '£17,107.20', TRUE),
(90, '£18,000', FALSE),
(90, '£16,800', FALSE); -- tested and working
        
---20 questions MOCK Exam /Medium answers  

---10 questions (id 91-100) English /Vocabulary /level Easy answers (id 271-300)

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
-- Question 91
(91, 'Joyful', TRUE),
(91, 'Sad', FALSE)
,(91, 'Angry', FALSE),
-- Q 92
(92, 'Small', TRUE),
(92, 'Tall', FALSE),
(92, 'Wide', FALSE),
-- Q 93
(93, 'Quick', TRUE),
(93, 'Slow', FALSE),
(93, 'Lazy', FALSE),
-- Q 94
(94, 'Chilly', TRUE),
(94, 'Hot', FALSE),
(94, 'Bright', FALSE),
-- Q 95
(95, 'Late', TRUE),
(95, 'Soon', FALSE),
(95, 'Fast', FALSE),
-- Q 96
(96, 'Attractive', TRUE),
(96, 'Ugly', FALSE),
(96, 'Heavy', FALSE),
-- Q 97
(97, 'Rapid', TRUE),
(97, 'Lazy', FALSE),
(97, 'Dull', FALSE),
-- Q 98
(98, 'Difficult', TRUE),
(98, 'Simple', FALSE),
(98, 'Quick', FALSE),
-- Q 99
(99, 'Powerful', TRUE),
(99, 'Weak', FALSE),
(99, 'Tired', FALSE),
-- Q 100
(100, 'Clever', TRUE),
(100, 'Slow', FALSE),
(100, 'Sad', FALSE); --tested and working


---10 questions ( id 101-110) English /Vocabulary /level Medium answers     (id 301-330)
-- Question 101
INSERT INTO answers (question_id, answer_text, is_correct) 
VALUES
(101, 'Sociable', TRUE),
(101, 'Shy', FALSE),
(101, 'Energetic', FALSE),

-- Q 102
(102, 'Careful and precise', TRUE),
(102, 'Fast and lazy', FALSE),
(102, 'Generous and kind', FALSE),

-- Q 103
(103, 'Difficult to find or catch', TRUE),
(103, 'Easy to capture', FALSE),
(103, 'Old and faded', FALSE),

-- Q 104
(104, 'Clarify', TRUE),
(104, 'Complicate', FALSE),
(104, 'Ignore', FALSE),
-- Q 105
(105, 'Clear and logical', TRUE),
(105, 'Confusing', FALSE),
(105, 'Random', FALSE),

-- Q 106
(106, 'Improve', TRUE),
(106, 'Destroy', FALSE),
(106, 'Make worse', FALSE),

-- Question 107
(107, 'Productive and creative', TRUE),
(107, 'Lazy and unproductive', FALSE),
(107, 'Slow and steady', FALSE),

-- Q 108
(108, 'Pungent', TRUE),
(108, 'Sweet', FALSE),
(108, 'Bitter', FALSE),

-- Q 109
(109, 'Short-lived', TRUE),
(109, 'Everlasting', FALSE),
(109, 'Slow', FALSE),
-- Q 110
(110, 'Uncertainty', TRUE),
(110, 'Confidence', FALSE),
(110, 'Excitement', FALSE); --tested and working


---10 questions (id 111-120) English /Vocabulary /level Hard answers   (id 331-360)
-- Question 111
INSERT INTO answers (question_id, answer_text, is_correct) 
VALUES
(111, 'Beauty', TRUE),
(111, 'Strength', FALSE),
(111, 'Happiness', FALSE),

(112, 'Stubborn and resistant to authority', TRUE),
(112, 'Submissive and obedient', FALSE),
(112, 'Confused and uncertain', FALSE),

(113, 'A person who uses long words', TRUE),
(113, 'A type of insect', FALSE),
(113, 'A food-related term', FALSE),

(114, 'Before the biblical flood', TRUE),
(114, 'A modern concept', FALSE),
(114, 'A type of animal', FALSE),

(115, 'The realization that others have lives as vivid and complex as your own', TRUE),
(115, 'A fear of the unknown', FALSE),
(115, 'The process of dreaming', FALSE),

(116, 'Strolling aimlessly', TRUE),
(116, 'Running quickly', FALSE),
(116, 'Dancing energetically', FALSE),

(117, 'The joy of anticipating something', TRUE),
(117, 'The sadness after an event', FALSE),
(117, 'The fear of new experiences', FALSE),

(118, 'Fear of long words', TRUE),
(118, 'Fear of spiders', FALSE),
(118, 'Fear of heights', FALSE),

(119, 'The study of mythical animals', TRUE),
(119, 'The study of ancient civilizations', FALSE),
(119, 'The study of languages', FALSE),

(120, 'A situation in which one is forced to make a difficult choice', TRUE),
(120, 'A game with no winners', FALSE),
(120, 'A type of strategic move in chess', FALSE);--- tested and working



---10 questions (id 121-130) English /Grammar /level Easy answers  (id 361-390)
-- Insert Answers
INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(121, 'goes', TRUE),
(121, 'going', FALSE),
(121, 'gone', FALSE),

(122, 'He don’t like apples.', FALSE),
(122, 'He doesn’t like apples.', TRUE),
(122, 'He don’t likes apples.', FALSE),

(123, 'few', FALSE),
(123, 'much', FALSE),
(123, 'many', TRUE),

(124, 'It’s John book.', FALSE),
(124, 'It’s Johns book.', FALSE),
(124, 'It’s John’s book.', TRUE),

(125, 'She eat lunch.', FALSE),
(125, 'She ate lunch.', TRUE),
(125, 'She eaten lunch.', FALSE),

(126, 'yours', TRUE),
(126, 'you', FALSE),
(126, 'your', FALSE),


(127, 'She has an apple.', TRUE),
(127, 'She apple has.', FALSE),
(127, 'Apple has she an.', FALSE),

(128, 'their', TRUE),
(128, 'there', FALSE),
(128, 'they’re', FALSE),

(129, 'on', FALSE),
(129, 'under', FALSE),
(129, 'at', TRUE),

(130, 'I like coffee and she likes tea.', TRUE),
(130, 'I like coffee, but she likes tea.', TRUE),
(130, 'I like coffee because she likes tea.', FALSE);-- tested and working

---10 questions (id 131-140) English /Grammar /level Medium answers  (id 391-420)

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
-- Q 131
(131, 'Huge', TRUE),
(131, 'Tiny', FALSE),
(131, 'Weak', FALSE),
-- Q 132
(132, 'Malevolent', TRUE),
(132, 'Kind', FALSE),
(132, 'Gentle', FALSE),
-- Q 133
(133, 'Precise', TRUE),
(133, 'Careless', FALSE),
(133, 'Clumsy', FALSE),
-- Q 134
(134, 'Brief', TRUE),
(134, 'Permanent', FALSE),
(134, 'Slow', FALSE),
-- Q 135
(135, 'Chaotic', TRUE),
(135, 'Peaceful', FALSE),
(135, 'Bright', FALSE),
-- Q 136
(136, 'Examine closely', TRUE),
(136, 'Ignore', FALSE),
(136, 'Relax', FALSE),
-- Q 137
(137, 'Stubborn', TRUE),
(137, 'Flexible', FALSE),
(137, 'Gentle', FALSE),
-- Q138
(138, 'Lazy', TRUE),
(138, 'Hardworking', FALSE),
(138, 'Smart', FALSE),
-- Q 139
(139, 'Unclear', TRUE),
(139, 'Obvious', FALSE),
(139, 'Simple', FALSE),
-- Q 140
(140, 'Energetic', TRUE),
(140, 'Weak', FALSE),
(140, 'Slow', FALSE);



---10 questions (id 141-150) English /Grammar /level Hard answers  (id 421-450)
INSERT INTO answers (question_id, answer_text, is_correct) VALUES
-- Q 141
(141, 'Confuse', TRUE),
(141, 'Clarify', FALSE),
(141, 'Reduce', FALSE),

-- Q 142
(142, 'Mild', TRUE),
(142, 'Harsh', FALSE),
(142, 'Irritating', FALSE),

-- Q 143
(143, 'Inclination', TRUE),
(143, 'Dislike', FALSE),
(143, 'Avoidance', FALSE),

-- Q 144
(144, 'Defiant', TRUE),
(144, 'Obedient', FALSE),
(144, 'Passive', FALSE),

-- Q 145
(145, 'Stimulating', TRUE),
(145, 'Sleep-inducing', FALSE),
(145, 'Boring', FALSE),

-- Q 146
(146, 'Everywhere', TRUE),
(146, 'Rare', FALSE),
(146, 'Limited', FALSE),

-- Q 147
(147, 'Uncompromising', TRUE),
(147, 'Flexible', FALSE),
(147, 'Easygoing', FALSE),

-- Q 148
(148, 'Long-lasting', TRUE),
(148, 'Temporary', FALSE),
(148, 'Short-lived', FALSE),

-- Q149
(149, 'Harmful', TRUE),
(149, 'Harmless', FALSE),
(149, 'Helpful', FALSE),

-- Q150
(150, 'Secretive', TRUE),
(150, 'Obvious', FALSE),
(150, 'Loud', FALSE);

   

---10 questions (id 151-160)  Physics /Mechanics /level Easy answers  (id 451-480)
INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(151, 'Time', FALSE), 
(151, 'Speed', FALSE), 
(151, 'Weight', TRUE),

(152, 'Joule', FALSE), 
(152, 'Watt', FALSE), 
(152, 'Newton', TRUE),

(153, '2 m/s²', TRUE), 
(153, '5 m/s²', FALSE), 
(153, '10 m/s²', FALSE),

(154, 'For every action, there is an equal and opposite reaction', FALSE), 
(154, 'An object in motion will stay in motion unless acted upon by a force.', TRUE), 
(154, 'Force equals mass times acceleration.', FALSE),

(155, 'The rate of change of displacement with direction', TRUE), 
(155, 'The speed of an object', FALSE), 
(155, 'The force exerted on an object', FALSE),

(156, 'Zero', TRUE), 
(156, 'Equal to its mass', FALSE), 
(156, 'Equal to its weight', FALSE),

(157, 'A car moving on a highway', FALSE), 
(157, 'A book resting on a shelf', TRUE), 
(157, 'A ball rolling down a hill', FALSE),

(158, 'Work = Force × Time', FALSE), 
(158, 'Work = Force × Displacement', TRUE), 
(158, 'Work = Energy × Distance', FALSE),

(159, 'The speed of an object', FALSE), 
(159, 'The energy required to stop an object', FALSE), 
(159, 'The product of mass and velocity', TRUE),

(160, 'A rock thrown upward', FALSE), 
(160, 'A car accelerating on a flat road', FALSE), 
(160, 'A stone dropped from a height', TRUE);

---10 questions (id 161-170) Physics /Mechanics /level Medium answers  (id 481-510)

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(161, '6 m/s²', FALSE),
 (161, '5 m/s²', FALSE), 
 (161, '4 m/s²', TRUE),

(162, '2 m/s²', FALSE), 
(162, '10 m/s²', FALSE),
 (162, '5 m/s²', TRUE),

(163, '5 m/s²', FALSE),
 (163, '1 m/s²', FALSE), 
 (163, '10 m/s²', TRUE),

(164, '200 J', FALSE),
 (164, '20 J', FALSE),
  (164, '100 J', TRUE),

(165, '10 m', FALSE), 
(165, '40 m', FALSE),
 (165, '20 m', TRUE),

(166, '30 J', FALSE),
 (166, '15 J', FALSE),
 (166, '45 J', TRUE),

(167, '50 J', FALSE), 
(167, '400 J', FALSE),
 (167, '200 J', TRUE),
(168, '25 kg·m/s', FALSE),
 (168, '100 kg·m/s', FALSE),
  (168, '50 kg·m/s', TRUE),

(169, '30 J', FALSE), 
(169, '120 J', FALSE), 
(169, '60 J', TRUE),

(170, '100 N', FALSE), 
(170, '25 N', FALSE), 
(170, '50 N', TRUE); -- tested and works 

---10 questions (id 171-180) Physics /Mechanics /level Hard answers  (id 511-540)

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(171, '5 m/s', FALSE), 
(171, '2 m/s', FALSE), 
(171, '4 m/s', TRUE),

(172, '10 kg·m/s', FALSE),
 (172, '-20 kg·m/s', FALSE),
  (172, '20 kg·m/s', TRUE),

(173, '4 J', FALSE),
 (173, '2 J', FALSE), 
 (173, '1 J', TRUE),

(174, '3 m/s', FALSE),
 (174, '4 m/s', FALSE),
  (174, '2 m/s', TRUE),

(175, '10 seconds', FALSE), 
(175, '25 seconds', FALSE), 
(175, '20 seconds', TRUE),

(176, '36 N', FALSE), 
(176, '16 N', FALSE), 
(176, '18 N', TRUE),

(177, '70 m/s', FALSE),
 (177, '60 m/s', FALSE), 
 (177, '30 m/s', TRUE),

(178, '2.0 s', FALSE), 
(178, '2.5 s', FALSE), 
(178, '1.0 s', TRUE),

(179, '2 rad/s', FALSE),
 (179, '8 rad/s', FALSE), 
 (179, '4 rad/s', TRUE),

(180, '400 N', FALSE),
 (180, '700 N', FALSE), 
 (180, '600 N', TRUE); -- tested and working





---10 questions (id 181-190) Physics  /Thermodynamics /level Easy answers  (id 541-570)
INSERT INTO answers (question_id, answer_text, is_correct) 
VALUES 
(181, 'Geothermal heat', FALSE),
(181, 'Fossil fuels', FALSE),
(181, 'The Sun', TRUE),

(182, 'Celsius (°C)', FALSE),
(182, 'Fahrenheit (°F)', FALSE),
(182, 'Kelvin (K)', TRUE),

(183, 'Zeroth Law', FALSE),
(183, 'Second Law', FALSE),
(183, 'First Law', TRUE),

(184, 'Isothermal expansion', FALSE),
(184, 'Isobaric compression', FALSE),
(184, 'Adiabatic expansion', TRUE),

(185, 'Energy', FALSE),
(185, 'Enthalpy', FALSE),
(185, 'Entropy', TRUE),

(186, 'Isothermal process', FALSE),
(186, 'Adiabatic process', FALSE),
(186, 'Isobaric process', TRUE),

(187, 'Work done', FALSE),
(187, 'Q_out', FALSE),
(187, 'Q_in', TRUE),

(188, 'The total energy of a system is always constant.', FALSE),
(188, 'Heat always flows from colder bodies to hotter bodies.', FALSE),
(188, 'In any energy transfer, some energy is lost as waste heat.', TRUE),

(189, 'The temperature increases.', FALSE),
(189, 'The temperature decreases.', FALSE),
(189, 'The temperature remains constant.', TRUE),

(190, 'The amount of heat required to melt a substance', FALSE),
(190, 'The temperature at which a substance changes state', FALSE),
(190, 'The amount of heat required to raise the temperature of a substance by 1°C', TRUE); -- tested and working


---10 questions(id 191-200) Physics /Thermodynamics /level Medium answers ( id 571-600)
INSERT INTO answers (question_id, answer_text, is_correct) 
VALUES 
(191, 'Internal energy', FALSE),
(191, 'Pressure', FALSE),
(191, 'Temperature', TRUE),

(192, 'The temperature of the system increases.', FALSE),
(192, 'The pressure remains constant.', FALSE),
(192, 'The system does not exchange heat with its surroundings.', TRUE),

(193, '75%', FALSE),
(193, '100%', FALSE),
(193, '50%', TRUE),

(194, 'Equal to the work done by the gas', FALSE),
(194, 'Zero', FALSE),
(194, 'Equal to the heat absorbed by the gas', TRUE),

(195, 'The temperature of the substance changes.', FALSE),
(195, 'The pressure must remain constant.', FALSE),
(195, 'The internal energy increases due to heat absorption.', TRUE),

(196, 'Heat flows from hot to cold objects.', FALSE),
(196, 'Energy is always conserved.', FALSE),
(196, 'The entropy of an isolated system always increases.', TRUE),

(197, '57.6%', FALSE),
(197, '60%', FALSE),
(197, '66.67%', TRUE),

(198, 'The temperature of the gas increases.', FALSE),
(198, 'The volume of the gas decreases.', FALSE),
(198, 'The work done by the gas is equal to the heat absorbed by the gas.', TRUE),

(199, 'The temperature of the cold reservoir', FALSE),
(199, 'The temperature of the hot reservoir', FALSE),
(199, 'The type of fuel used', TRUE),

(200, 'It remains the same.', FALSE),
(200, 'It halves.', FALSE),
(200, 'It doubles.', TRUE); -- tested and working

---10 questions (id 201-210) Physics /Thermodynamics /level Hard answers   (id 601-630)
INSERT INTO answers (question_id, answer_text, is_correct)
VALUES 
(201, '30%', FALSE),
(201, '25%', FALSE),
(201, '40%', TRUE),
(202, '7000 J', FALSE),
(202, '6000 J', FALSE),
(202, '5000 J', TRUE),
(203, '3500 J', FALSE),
(203, '5000 J', FALSE),
(203, '4200 J', TRUE),
(204, '100 J', FALSE),
(204, '150 J', FALSE),
(204, '150 J', TRUE),
(205, 'The system absorbs heat.', FALSE),
(205, 'The internal energy of the system increases.', FALSE),
(205, 'The system does work on its surroundings.', TRUE),
(206, '600 K', FALSE),
(206, '400 K', FALSE),
(206, '500 K', TRUE),
(207, 'ΔS=T/Q', FALSE),
(207, 'ΔS=QxT', FALSE),
(207, 'ΔS=Q/T', TRUE),
(208, '600 J', FALSE),
(208, '180 J', FALSE),
(208, '400 J', TRUE),
(209, 'It increases', FALSE),
(209, 'It decreases', FALSE),
(209, 'It remains the same', TRUE),
(210, '226000', FALSE),
(210, '2260', FALSE),
(210, '22600 J', TRUE); -- tested and working


---10 questions (id 211-220) Physics /Electromagnetism /level Easy answers   (id 631-660)
INSERT INTO  answers (question_id, answer_text, is_correct)
VALUES 
(211, 'Ohm (Ω)', FALSE),
 (211, 'Volt (V)', FALSE), 
 (211, 'Ampere (A)', TRUE), 

(212, 'Electric potential', FALSE), 
(212, 'Electric charge', FALSE), 
(212, 'Electric field', TRUE),  

(213, 'Ampere (A)', FALSE), 
(213, 'Coulomb (C)', FALSE), 
(213, 'Ohm (Ω)', TRUE),  

(214, '10 Ω', FALSE),
 (214, '20 Ω', FALSE), 
 (214, '5 Ω', TRUE),  

(215, '1.62 N', FALSE),
 (215, '3.24 N', FALSE), 
 (215, '2.88 N', TRUE),  

(216, 'It is parallel to the current.', FALSE), 
(216, 'It is perpendicular to the wire.', FALSE), 
(216, 'It forms concentric circles around the wire.', TRUE), 

(217, 'Rubber', FALSE),
 (217, 'Wood', FALSE), 
 (217, 'Copper', TRUE),  

(218, 'Volt (V)', FALSE), 
(218, 'Ohm (Ω)', FALSE), 
(218, 'Coulomb (C)', TRUE), 

(219, 'Longitudinal wave', FALSE), 
(219, 'Matter wave', FALSE), 
(219, 'Transverse wave', TRUE), 

(220, 'It decreases', FALSE),
 (220, 'It stays the same', FALSE),
  (220, 'It increases', TRUE);  --tested and working



---10 questions (id 221-230) Physics /Electromagnetism /level Medium answers  (id 661-690)
INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
(221, '48 W', FALSE), 
(221, '12 W', FALSE),
 (221, '24 W', TRUE),

(222, '3.14 × 10⁻⁵ N/m', FALSE),
 (222, '4.71 × 10⁻⁵ N/m', FALSE), 
 (222, '1.57 × 10⁻⁵ N/m', TRUE),

(223, '100 V', FALSE),
 (223, '500 V', FALSE), 
 (223, '1000 V', TRUE),

(224, '1 A', FALSE),
 (224, '2 A', FALSE), 
 (224, '3 A', TRUE),

(225, '0.25 J', FALSE), 
(225, '0.05 J', FALSE), 
(225, '0.05 J', TRUE),

(226, '2.5 N', FALSE), 
(226, '2 N', FALSE), 
(226, '1.5 N', TRUE),

(227, '1.5 Wb', FALSE), 
(227, '0.5 Wb', FALSE), 
(227, '1.0 Wb', TRUE),

(228, '20 Hz', FALSE), 
(228, '15 Hz', FALSE), 
(228, '10 Hz', TRUE),

(229, '4 V', FALSE),
 (229, '3 V', FALSE),
  (229, '5 V', TRUE),

(230, '0.25 H', FALSE), 
(230, '0.5 H', FALSE), 
(230, '0.05 H', TRUE);
--tested and working



---10 questions (id 231-240) Physics /Electromagnetism /level Hard answers (id 691-720)

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES 
(231, '2.2 V', FALSE), (231, '0.2 V', FALSE), (231, '2.0 V', TRUE),
(232, '0.1 Wb', FALSE), (232, '0.4 Wb', FALSE), (232, '0.2 Wb', TRUE),
(233, '180 V', FALSE), (233, '120 V', FALSE), (233, '60 V', TRUE),
(234, '1.8 N', FALSE), (234, '2.4 N', FALSE), (234, '1.2 N', TRUE),
(235, '0.5 m', FALSE), (235, '1.5 m', FALSE), (235, '1.0 m', TRUE),
(236, '180 μC', FALSE), (236, '240 μC', FALSE), (236, '120 μC', TRUE),
(237, '60 V', FALSE), (237, '20 V', FALSE), (237, '40 V', TRUE),
(238, '0.06 cm', FALSE), (238, '6 cm', FALSE), (238, '0.06 m', TRUE),
(239, '60°', FALSE), (239, '30°', FALSE), (239, '90°', TRUE),
(240, '5.4 × 10⁻¹³ N', FALSE), (240, '3.0 × 10⁻¹³ N', FALSE), (240, '1.8 × 10⁻¹³ N', TRUE);
--tested and working


---10 questions (id 241-250) Operating systems /Memory management /level Easy answers  (id 721-750)
INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (241, 'To allocate and manage the system’s RAM effectively', TRUE),
  (241, 'To manage the user interface and graphical displays', FALSE),
  (241, 'To allocate CPU time for processes', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (242, 'Swapping', FALSE),
  (242, 'Segmentation', FALSE),
  (242, 'Paging', TRUE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (243, 'Virtual memory stores data permanently in a file system.', FALSE),
  (243, 'Virtual memory allows a computer to compensate for physical memory shortages by temporarily transferring data to disk storage.', TRUE),
  (243, 'Virtual memory is the total RAM available on the system.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (244, 'When memory is allocated but not used, causing fragmentation', TRUE),
  (244, 'When memory is fragmented and has holes between allocations', FALSE),
  (244, 'When memory is continuously cleared and reset', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (245, 'Central Processing Unit (CPU)', FALSE),
  (245, 'Memory management unit (MMU)', TRUE),
  (245, 'Disk Controller', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (246, 'Physical memory refers to actual hardware, while virtual memory is a technique to simulate additional memory.', TRUE),
  (246, 'Physical memory refers to disk storage, while virtual memory refers to RAM.', FALSE),
  (246, 'Physical memory is the sum of virtual memory and cache memory.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (247, 'It divides memory into fixed-size pages and uses page tables to map them to physical memory.', TRUE),
  (247, 'It uses variable-sized memory blocks to allocate processes.', FALSE),
  (247, 'It allocates a fixed amount of memory for each process regardless of size.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (248, 'When memory is continuously swapped between disk and RAM', FALSE),
  (248, 'When the memory allocation is based on the priority of processes', FALSE),
  (248, 'When memory that is no longer needed is not properly released, causing a program to consume more memory over time.', TRUE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (249, 'It stores data in sequential memory blocks based on their addresses.', FALSE),
  (249, 'It stores mappings of virtual addresses to physical addresses in memory.', TRUE),
  (249, 'It maps virtual memory to secondary storage locations for faster access.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (250, 'Through allocation strategies like First Fit, Best Fit, and Worst Fit.', TRUE),
  (250, 'By using a fixed memory allocation size for all processes.', FALSE),
  (250, 'Through dynamic swapping of memory based on process priority.', FALSE);



---10 questions (id 251-260) Operating systems /Memory management /level Medium answers (id 751-780)
INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
 (251, 'It is responsible for allocating CPU time to each process.', FALSE),
  (251, 'It maps virtual addresses to physical addresses for memory access.', TRUE),
  (251, 'It stores the virtual memory configuration for the user.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (252, 'Contiguous allocation divides memory into small chunks, while non-contiguous allocation uses one continuous block.', FALSE),
  (252, 'Contiguous allocation places processes in adjacent memory locations, while non-contiguous allocation allows processes to be scattered across memory.', TRUE),
  (252, 'Contiguous allocation involves using multiple hard drives, while non-contiguous uses a single drive.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (253, 'By physically encrypting all memory regions to prevent unauthorized access.', FALSE),
  (253, 'By using protection mechanisms like access control lists and virtual memory protections.', TRUE),
  (253, 'By creating memory zones that are inaccessible to processes that are not authorized.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (254, 'It stores all data in a contiguous block, eliminating fragmentation.', FALSE),
  (254, 'It dynamically allocates memory blocks of different sizes to processes.', FALSE),
  (254, 'It divides memory into fixed-size pages and maintains a mapping table to translate virtual addresses to physical addresses.', TRUE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (255, 'A segmentation fault occurs when a process tries to access restricted or invalid memory.', TRUE),
  (255, 'A segmentation fault occurs when the operating system cannot allocate enough memory for a process.', FALSE),
  (255, 'A segmentation fault is caused by processes exceeding their CPU time allocation.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (256, 'A hard page fault occurs when the page is not in memory and needs to be retrieved from disk, while a soft page fault occurs when the page is in memory but not mapped.', TRUE),
  (256, 'A hard page fault occurs when there is insufficient RAM, and a soft page fault occurs when the page is temporarily swapped to the disk.', FALSE),
  (256, 'A hard page fault occurs when a page is already in memory but is accessed incorrectly, and a soft page fault happens when the page is still in the cache.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (257, 'Thrashing happens when processes are unable to access CPU time and are left idle.', FALSE),
  (257, 'Thrashing happens when a system runs out of storage space for files.', FALSE),
  (257, 'Thrashing happens when the system spends more time swapping data in and out of memory than executing processes.', TRUE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (258, 'Demand paging loads pages only when they are needed, reducing memory usage.', TRUE),
  (258, 'Demand paging loads all pages into memory when a program starts.', FALSE),
  (258, 'Demand paging eliminates memory fragmentation by using contiguous memory allocation.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (259, 'It involves permanently removing old data from memory to increase processing speed.', FALSE),
  (259, 'It involves transferring processes from physical memory to disk storage to free up space for other processes.', TRUE),
  (259, 'It only occurs when physical memory is completely full and no processes are currently running.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (260, 'Operating systems detect memory leaks by checking process execution time.', FALSE),
  (260, 'Operating systems detect memory leaks through monitoring tools and by analyzing memory usage patterns over time.', TRUE),
  (260, 'Operating systems detect memory leaks by periodically clearing unused memory spaces.', FALSE);


---10 questions (id 261-270) Operating systems /Memory management /level Hard answers (id 781-810)
INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (261, 'Memory-mapped I/O is used to manage virtual memory in operating systems.', FALSE),
  (261, 'Memory-mapped I/O is a technique used to prevent memory fragmentation.', FALSE),
  (261, 'Memory-mapped I/O maps device registers and buffers directly into the memory space, allowing the CPU to communicate with devices more efficiently.', TRUE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (262, 'Memory management in multi-core systems is challenging due to cache coherence and the need to synchronize memory access between cores.', TRUE),
  (262, 'Memory management in multi-core systems is easier due to the uniformity of memory.', FALSE),
  (262, 'Multi-core systems use single-core memory management strategies, which simplifies their operation.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (263, 'Large memory addresses are not supported by the operating system; they are handled by the hardware only.', FALSE),
  (263, '64-bit processors do not need to handle large memory addresses as they can access a small amount of RAM only.', FALSE),
  (263, 'The operating system uses techniques like segmentation and paging to handle large memory addresses, especially with 64-bit processors.', TRUE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (264, 'A 64-bit memory addressing scheme allows the system to address more than 4GB of memory, improving performance and enabling the handling of large datasets.', TRUE),
  (264, 'A 64-bit memory addressing scheme decreases the system’s memory access speed.', FALSE),
  (264, 'A 64-bit memory addressing scheme only increases the number of processes that can run simultaneously.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (265, 'Virtual memory improves memory performance by directly accessing storage devices.', FALSE),
  (265, 'Virtual memory improves memory access performance by providing the illusion of more memory than is physically available through swapping and paging techniques.', TRUE),
  (265, 'Virtual memory reduces the need for disk storage by eliminating the need for swapping.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (266, 'Through hardware protection mechanisms like memory segmentation and access control policies enforced by the operating system.', TRUE),
  (266, 'By using encryption techniques to protect memory contents.', FALSE),
  (266, 'By isolating memory used by processes from physical memory.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (267, 'Insufficient memory causes the operating system to reduce the number of active processes.', FALSE),
  (267, 'Insufficient memory results in faster CPU execution and better system performance.', FALSE),
  (267, 'Insufficient memory leads to excessive swapping, system slowdown, and in extreme cases, system crashes or freezing.', TRUE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (268, 'Real-time operating systems require deterministic memory allocation to ensure critical processes are always provided the necessary memory resources.', TRUE),
  (268, 'Real-time operating systems do not require any specific memory allocation schemes.', FALSE),
  (268, 'Real-time operating systems use virtual memory to guarantee timely memory access for processes.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (269, 'Memory allocation strategies are based on the size of the CPU cache rather than the memory.', FALSE),
  (269, 'Some strategies include First Fit, Best Fit, and Worst Fit, which determine how memory blocks are allocated to processes.', TRUE),
  (269, 'Memory allocation strategies rely solely on the process priority and execution time.', FALSE);

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (270, 'Memory compaction breaks memory into smaller, fixed-size blocks for faster access.', FALSE),
  (270, 'Memory compaction is a method used to reduce memory usage by deleting unused memory sections.', FALSE),
  (270, 'Memory compaction involves rearranging fragmented memory to create larger contiguous blocks of free memory.', TRUE);

---10 questions (271-280) Operating systems /Process management /level Easy answers (id 811-840)
INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (271, 'A program in execution', TRUE),
  (271, 'A type of memory', FALSE),
  (271, 'A hardware component', FALSE),

  (272, 'fork()', TRUE),
  (272, 'create()', FALSE),
  (272, 'start()', FALSE),

  (273, 'A data structure containing process information', TRUE),
  (273, 'A type of memory allocation', FALSE),
  (273, 'A scheduling algorithm', FALSE),

  (274, 'Waiting', TRUE),
  (274, 'Running', FALSE),
  (274, 'Terminated', FALSE),

  (275, 'The process that creates another process', TRUE),
  (275, 'A process that has no child processes', FALSE),
  (275, 'A process that is terminated', FALSE),

  (276, 'Sleeping', FALSE),
  (276, 'Running', FALSE),
  (276, 'Executing', TRUE),

  (277, 'It is the first process started by the kernel', TRUE),
  (277, 'It handles user authentication', FALSE),
  (277, 'It manages network connections', FALSE),

  (278, 'Replaces the current process image with a new one', TRUE),
  (278, 'Terminates the current process', FALSE),
  (278, 'Creates a new thread', FALSE),

  (279, 'Blocked', TRUE),
  (279, 'Sleeping', FALSE),
  (279, 'Idle', FALSE),

  (280, 'To determine which process runs next', TRUE),
  (280, 'To allocate memory to processes', FALSE),
  (280, 'To manage file systems', FALSE); -- tested and working




---10 questions (281-290) Operating systems /Process management /level Medium answers (id 841-870)
INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (281, 'Switching the CPU from one process to another', TRUE),
  (281, 'Switching from user mode to kernel mode', FALSE),
  (281, 'Changing memory allocation', FALSE),

  (282, 'Round Robin', TRUE),
  (282, 'First-Come, First-Served', FALSE),
  (282, 'Shortest Job Next', FALSE),

  (283, 'To control access to shared resources', TRUE),
  (283, 'To schedule processes', FALSE),
  (283, 'To manage memory allocation', FALSE),

  (284, 'A process that has completed execution but still has an entry in the process table', TRUE),
  (284, 'A process that is waiting for I/O', FALSE),
  (284, 'A process that is in a deadlock', FALSE),

  (285, 'First-Come, First-Served', TRUE),
  (285, 'Round Robin', FALSE),
  (285, 'Shortest Remaining Time First', FALSE),

  (286, 'Mechanism for processes to communicate and synchronize', TRUE),
  (286, 'Method for memory allocation', FALSE),
  (286, 'Technique for CPU scheduling', FALSE),

  (287, 'It can cause the convoy effect', TRUE),
  (287, 'It is complex to implement', FALSE),
  (287, 'It requires special hardware', FALSE),

  (288, 'To make the parent process wait until the child process finishes', TRUE),
  (288, 'To terminate the parent process', FALSE),
  (288, 'To create a new process', FALSE),

  (289, 'It allows multiple threads within a process to run concurrently', TRUE),
  (289, 'It prevents concurrent execution', FALSE),
  (289, 'It is only used in single-core systems', FALSE),

  (290, 'User-level threads are managed by user-level libraries, while kernel-level threads are managed by the OS kernel', TRUE),
  (290, 'User-level threads are faster than kernel-level threads', FALSE),
  (290, 'Kernel-level threads cannot run on multiple processors', FALSE); -- tested and working



---10 questions (291-300) Operating systems /Process management /level Hard answers (id 871-900)

INSERT INTO answers (question_id, answer_text, is_correct)
VALUES
  (291, 'To set the priority of a process', TRUE),
  (291, 'To terminate a process', FALSE),
  (291, 'To create a new process', FALSE),

  (292, 'A situation where multiple processes access shared data concurrently, leading to inconsistent results', TRUE),
  (292, 'A condition where a process is stuck in an infinite loop', FALSE),
  (292, 'A scenario where a process waits indefinitely for a resource', FALSE),

  (293, 'To avoid deadlock by ensuring safe resource allocation', TRUE),
  (293, 'To schedule processes in a round-robin manner', FALSE),
  (293, 'To manage memory allocation', FALSE),

  (294, 'A mutex is a locking mechanism for mutual exclusion, while a semaphore is a signaling mechanism', TRUE),
  (294, 'A mutex can be used by multiple processes simultaneously', FALSE),
  (294, 'A semaphore is only used for memory management', FALSE),

  (295, 'To send signals to processes, typically to terminate them', TRUE),
  (295, 'To create new processes', FALSE),
  (295, 'To change the priority of a process', FALSE),

  (296, 'A thread is a lightweight process that shares resources with other threads in the same process', TRUE),
  (296, 'A process is a part of a thread', FALSE),
  (296, 'Threads cannot run concurrently', FALSE),

  (297, 'To display information about active processes', TRUE),
  (297, 'To change the priority of a process', FALSE),
  (297, 'To terminate a process', FALSE),

  (298, 'In cooperative multitasking, processes voluntarily yield control; in preemptive multitasking, the OS forcibly takes control', TRUE),
  (298, 'Cooperative multitasking is used in modern operating systems', FALSE),
  (298, 'Preemptive multitasking does not allow multiple processes to run concurrently', FALSE),

  (299, 'To display real-time information about system processes and resource usage', TRUE),
  (299, 'To terminate processes', FALSE),
  (299, 'To change file permissions', FALSE),

  (300, 'Hard real-time systems have strict timing constraints; soft real-time systems have more relaxed constraints', TRUE),
  (300, 'Soft real-time systems are used in critical applications', FALSE),
  (300, 'Hard real-time systems can tolerate delays', FALSE);




---10 questions(301-310) Operating systems /File management /level Easy answers (id 901-930)
INSERT INTO answers (question_id, answer_text, is_correct) 
VALUES
  (301, 'A named collection of data stored on disk', TRUE),
  (301, 'A memory register used for I/O', FALSE),
  (301, 'A function call in C', FALSE),

  (302, 'File size', TRUE),
  (302, 'CPU speed', FALSE),
  (302, 'RAM type', FALSE),

  (303, 'To organize files for easy access and management', TRUE),
  (303, 'To execute programs in the background', FALSE),
  (303, 'To monitor CPU usage', FALSE),

  (304, 'NTFS', TRUE),
  (304, 'HTML', FALSE),
  (304, 'HTTP', FALSE),

  (305, 'A plain text file', TRUE),
  (305, 'An image file', FALSE),
  (305, 'A system executable', FALSE),

  (306, 'To open a file and return its file descriptor', TRUE),
  (306, 'To close a file', FALSE),
  (306, 'To move a file to another directory', FALSE),

  (307, 'Delete', TRUE),
  (307, 'Copy', FALSE),
  (307, 'Open', FALSE),

  (308, 'Absolute paths start from root, relative paths start from current directory', TRUE),
  (308, 'Relative paths are only used in Windows', FALSE),
  (308, 'There is no difference', FALSE),

  (309, 'An integer that uniquely identifies an open file in a process', TRUE),
  (309, 'The size of a file', FALSE),
  (309, 'The type of a file', FALSE),

  (310, 'The operating system', TRUE),
  (310, 'The monitor', FALSE),
  (310, 'The application software', FALSE); -- tested and working

---10 questions (311-320) Operating systems /File management /level Medium answers (id 931-960)

INSERT INTO answers (question_id, answer_text, is_correct) 
VALUES
  (311, 'It stores metadata about a file', TRUE),
  (311, 'It compresses file contents', FALSE),
  (311, 'It executes user programs', FALSE),

  (312, 'Linked allocation', TRUE),
  (312, 'Contiguous allocation', FALSE),
  (312, 'Indexed allocation', FALSE),

  (313, 'To define who can access a file and with what permissions', TRUE),
  (313, 'To store file contents', FALSE),
  (313, 'To encrypt files', FALSE),

  (314, 'Using a File Allocation Table', TRUE),
  (314, 'Using an inode table', FALSE),
  (314, 'By writing to RAM', FALSE),

  (315, 'Seek operation', TRUE),
  (315, 'Open operation', FALSE),
  (315, 'Write operation', FALSE),

  (316, 'Hard links point directly to file data; symbolic links point to file name', TRUE),
  (316, 'Symbolic links are larger than hard links', FALSE),
  (316, 'Hard links are temporary', FALSE),

  (317, 'chmod', TRUE),
  (317, 'ls', FALSE),
  (317, 'cat', FALSE),

  (318, 'By recording file changes before applying them', TRUE),
  (318, 'By disabling user access', FALSE),
  (318, 'By creating backup copies', FALSE),

  (319, 'When file blocks are scattered across the disk', TRUE),
  (319, 'When multiple users edit a file', FALSE),
  (319, 'When a file is copied twice', FALSE),

  (320, 'creat()', TRUE),
  (320, 'open()', FALSE),
  (320, 'write()', FALSE); -- tested and working


---10 questions (321-330) Operating systems /File management /level Hard answers (id 961-990)

INSERT INTO answers (question_id, answer_text, is_correct) 
VALUES
  (321, 'Fast random access with minimal fragmentation', TRUE),
  (321, 'Low memory overhead', FALSE),
  (321, 'Unlimited file size', FALSE),

  (322, 'It attaches a file system to a directory structure', TRUE),
  (322, 'It copies all files to memory', FALSE),
  (322, 'It renames files on disk', FALSE),

  (323, 'It provides a uniform interface to different file systems', TRUE),
  (323, 'It compresses files', FALSE),
  (323, 'It formats disks', FALSE),

  (324, 'Delays writing dirty blocks to disk to improve efficiency', TRUE),
  (324, 'Writes data in reverse order', FALSE),
  (324, 'Removes unused files', FALSE),

  (325, 'Improper shutdowns or hardware failures', TRUE),
  (325, 'Too many files in a folder', FALSE),
  (325, 'Slow CPU speed', FALSE),

  (326, 'It delays actual data copy until modification', TRUE),
  (326, 'It copies all files when opened', FALSE),
  (326, 'It writes data directly to disk', FALSE),

  (327, 'Uses multiple levels of index blocks to address large files', TRUE),
  (327, 'Duplicates file data in memory', FALSE),
  (327, 'Deletes files automatically', FALSE),

  (328, 'By scanning with tools like fsck and restoring logs', TRUE),
  (328, 'By reformatting the disk', FALSE),
  (328, 'By restarting the system', FALSE),

  (329, 'Synchronous writes wait for disk operation to complete; asynchronous writes don’t', TRUE),
  (329, 'Both write data in the same way', FALSE),
  (329, 'Asynchronous writes are slower', FALSE),

  (330, 'Because they reduce write amplification and improve wear leveling', TRUE),
  (330, 'They are cheaper to implement', FALSE),
  (330, 'They increase power usage', FALSE); -- tested and working
    

    













