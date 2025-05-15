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
  (1, 1, 'Algebra Quiz 1', 'quiz', 'Easy'),  --quiz_id=1
  (1, 1, 'Algebra Quiz 2', 'quiz', 'Medium'),--- quiz_id=2
  (1, 1, 'Algebra Quiz 3', 'quiz', 'Hard'),---quiz_id=3
  (1, 2, 'Ratio and Proportion Quiz 1', 'quiz', 'Easy'),-- quiz_id=4
  (1, 2, 'Ratio and Proportion Quiz 2', 'quiz', 'Medium'),--- quiz_id=5
  (1, 2, 'Ratio and Proportion Quiz 3', 'quiz', 'Hard'),---quiz_id=6
  (1, 3, 'Percentage Quiz 1', 'quiz', 'Easy'),--- quiz_id =7
  (1, 3, 'Percentage Quiz 2', 'quiz', 'Medium'),--- quiz_id=8
  (1, 3, 'Percentage Quiz 3', 'quiz', 'Hard'),--- quiz_id=9

 

  (2, 4, 'Vocabulary Quiz 1', 'quiz', 'Easy'),-- quiz_id =10
  (2, 4, 'Vocabulary Quiz 2', 'quiz', 'Medium'),---quiz_id=11
  (2, 4, 'Vocabulary Quiz 3', 'quiz', 'Hard'),--- quiz_id=12
  (2, 5, 'Grammar Quiz 1', 'quiz', 'Easy'), --- quiz_id=13
  (2, 5, 'Grammar Quiz 2', 'quiz', 'Medium'),---quiz_id = 14
  (2, 5, 'Grammar Quiz 3', 'quiz', 'Hard'),--- quiz_id =15
  
 
  
  (3, 6, 'Mechanics Quiz 1', 'quiz', 'Easy'),--- quiz_id =16
  (3, 6, 'Mechanics Quiz 2', 'quiz', 'Medium'),--- quiz_id =17 
  (3, 6, 'Mechanics Quiz 3', 'quiz', 'Hard'), ---quiz_id=18
  (3, 7, 'Thermodynamics Quiz 1', 'quiz', 'Easy'), --- quiz_id =19
  (3, 7, 'Thermodynamics Quiz 2', 'quiz', 'Medium'),--- quiz_id=20
  (3, 7, 'Thermodynamics Quiz 3', 'quiz', 'Hard'),--- quiz_id=21
  (3, 8, 'Electromagnetism Quiz 1', 'quiz', 'Easy'),--- quiz_id =22
  (3, 8, 'Electromagnetism Quiz 2', 'quiz', 'Medium'),--- quiz_id =23
  (3, 8, 'Electromagnetism Quiz 3', 'quiz', 'Hard'),--- quiz_id=24

   

  (4, 9, 'Memory management Quiz 1', 'quiz', 'Easy'),--- quiz_id =25  
  (4, 9, 'Memory management Quiz 2', 'quiz', 'Medium'), --- quiz_id =26 
  (4, 9, 'Memory management Quiz 3', 'quiz', 'Hard'), --- quiz_id =27 
  (4, 10, 'Process management Quiz 1', 'quiz', 'Easy'),--- quiz_id =28
  (4, 10, 'Process management Quiz 2', 'quiz', 'Medium'), --- quiz_id=29
  (4, 10, 'Process management Quiz 3', 'quiz', 'Hard'),--- quiz_id =30
  (4, 11, 'File management Quiz 1', 'quiz', 'Easy'),--- quiz_id =31
  (4, 11, 'File management Quiz 2', 'quiz', 'Medium'),--- quiz_id =32
  (4, 11, 'File management Quiz 3', 'quiz', 'Hard'),--- quiz_id =33

-- quiz_id 1-33 are quizzes



 --Math mock exam contain mixed questions from all topics
(1,NULL,'Math exam', 'MOCK Exam', 'Medium'),--- quiz_id 34
 --English mock exam contain mixed questions from all topics
  (2,NULL,'English exam','MOCK Exam', 'Medium'), --- quiz_id 35
   --Physics mock exam contain mixed questions from all topics
    (3,NULL,'Physics exam','MOCK Exam', 'Medium'),--- quiz_id 36
  --Operating systems mock exam contain mixed questions from all topics
  (4,NULL,'Operating systems exam','MOCK Exam', 'Medium');  --- quiz_id 37
-- quiz_id 34,35,36,37 are mock exams





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
(2, 'If 12 oranges cost £9, what is the cost of 4 oranges?', 1, 'Easy');-- tested and working

--10 questions Math /Ratio and Proportion /level Medium (id 41-50)
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
(2, 'A map scale is 1:50000. What is the real distance if the map shows 4 cm?', 2, 'Medium');  -- tested and working

--10 questions Math /Ratio and Proportion /level Hard (id 51-60)
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


--10 questions Math /Percentage /level Easy (id 61-70)
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

--10 questions Math /Percentage /level Medium (id 71-80)
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

--10 questions Math /Percentage /level Hard (id 81-90)
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


--20 questions MOCK Exam /Medium 

--10 questions English /Vocabulary /level Easy (id 91-100)
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

--10 questions English /Vocabulary /level Medium  (id 101-110)
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

--10 questions English /Vocabulary /level Hard  (id 111-120)
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

--10 questions English /Grammar /level Easy   (id 121-130)
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


--10 questions English /Grammar /level Medium (id 131-140)
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

--10 questions English /Grammar /level Hard   (id 141-150)
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




--10 questions Physics /Mechanics /level Easy (id 151-160)
--10 questions Physics /Mechanics /level Medium (id 161-170)
--10 questions Physics /Mechanics /level Hard   (id 171-180)
--10 questions Physics /Thermodynamics /level Easy  (id 181-190)
--10 questions Physics /Thermodynamics /level Medium  (id 191-200)
--10 questions Physics /Thermodynamics /level Hard  (id 201-210)
--10 questions Physics /Electromagnetism /level Easy  (id 211-220)
--10 questions Physics /Electromagnetism /level Medium  (id 221-230)
--10 questions Physics /Electromagnetism /level Hard  (id 231-240)






--10 questions  Operating systems /Memory management /level Easy  (id 241-250)
--10 questions Operating systems /Memory management /level Medium   (id 251-260)
--10 questions Operating systems /Memory management /level Hard   (id 261-270)
--10 questions Operating systems /Process management /level Easy    (id 271-280)
--10 questions Operating systems /Process management /level Medium  (id 281-290)
--10 questions Operating systems /Process management /level Hard  (id 291-300)
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
  (1, 9),  (1, 10),

  --Algebra Quiz 2 level medium questions medium
  --question_id 11 - 20
 (2, 11),  (2, 12), 
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


--Ratio and Proportion Quiz 1 easy
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (4, 31),  (4, 32), 
  (4, 33),  (4, 34),
  (4, 35),  (4, 36),
  (4, 37),  (4, 38),  
  (4, 39),  (4, 40);-- tested and working

--Ratio and Proportion Quiz 2 medium
INSERT INTO
  quiz_questions(
    quiz_id, question_id)   
VALUES
  (5, 41),  (5, 42), 
  (5, 43),  (5, 44),
  (5, 45),  (5, 46),
  (5, 47),  (5, 48),  
  (5, 49),  (5, 50);-- tested and working


---Ratio and Proportion Quiz 3
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (6, 51),  (6, 52), 
  (6, 53),  (6, 54),
  (6, 55),  (6, 56),
  (6, 57),  (6, 58),  
  (6, 59),  (6, 60);-- tested and working 

 ---Percentage Quiz 1
 INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (7, 61),  (7, 62), 
  (7, 63),  (7, 64),
  (7, 65),  (7, 66),
  (7, 67),  (7, 68),  
  (7, 69),  (7, 70);-- tested and working 

--- Percentage Quiz 2
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (8, 71),  (8, 72), 
  (8, 73),  (8, 74),
  (8, 75),  (8, 76),
  (8, 77),  (8, 78),  
  (8, 79),  (8, 80);-- tested and working 

---Percentage Quiz 3
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (9, 81),  (9, 82), 
  (9, 83),  (9, 84),
  (9, 85),  (9, 86),
  (9, 87),  (9, 88),  
  (9, 89),  (9, 90);-- tested and working



 ---Vocabulary Quiz 1
 INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (10, 91),  (10, 92), 
  (10, 93),  (10, 94),
  (10, 95),  (10, 96),
  (10, 97),  (10, 98),  
  (10, 99),  (10, 100);-- tested and working 17/03

--- Vocabulary Quiz 2
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (11, 101),  (11, 102), 
  (11, 103),  (11, 104),
  (11, 105),  (11, 106),
  (11, 107),  (11, 108),  
  (11, 109),  (11, 110);-- tested and working 17/03

--- Vocabulary Quiz 3
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (12, 111),  (12, 112), 
  (12, 113),  (12, 114),
  (12, 115),  (12, 116),
  (12, 117),  (12, 118),  
  (12, 119),  (12, 120);-- tested and working 17/03

 ---Grammar Quiz 1
 INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (13, 121),  (13, 122), 
  (13, 123),  (13, 124),
  (13, 125),  (13, 126),
  (13, 127),  (13, 128),  
  (13, 129),  (13, 130);-- tested and working 17/03

---Grammar Quiz 2
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (14, 131),  (14, 132), 
  (14, 133),  (14, 134),
  (14, 135),  (14, 136),
  (14, 137),  (14, 138),  
  (14, 139),  (14, 140);-- tested and working 17/03

---Grammar Quiz 3
INSERT INTO
  quiz_questions(
    quiz_id, question_id)
VALUES
  (15, 141),  (15, 142), 
  (15, 143),  (15, 144),
  (15, 145),  (15, 146),
  (15, 147),  (15, 148),  
  (15, 149),  (15, 150);-- tested and working 17/03


 --Mechanics Quiz 1
 --Mechanics Quiz 2
-- Mechanics Quiz 3
--Thermodynamics Quiz 1
 --Thermodynamics Quiz 2
 --Thermodynamics Quiz 3
 --Electromagnetism Quiz 1
 --Electromagnetism Quiz 2
 --Electromagnetism Quiz 3
 
-- Memory management Quiz 1
-- Memory management Quiz 2
 --Memory management Quiz 3
 --Process management Quiz 1
 --Process management Quiz 2
 --Process management Quiz 3
-- File management Quiz 1
-- File management Quiz 2
--File management Quiz 3



--- we need a function to mix the questions for the mock exams

--- Math exam
---English exam
--Physics exam
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
(40, '£2', FALSE); -- Q 40  tested and working


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
  (50, '5 km', FALSE);--50  tested and working


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
(80, '£400', FALSE); --80 tested and working

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
(90, '£16,800', FALSE); --90 tested and working

        


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


---10 questions (id 101-110) English /Vocabulary /level Medium answers     (id 301-330)
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


---10 questions (id 131-140)English /Grammar /level Medium answers  (id 391-420)
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
(150, 'Loud', FALSE);-- tested and working
    

--- start from here 
---10 questions (id 151-160)  Physics /Mechanics /level Easy answers    
---10 questions (id 161-170) Physics /Mechanics /level Medium answers    
---10 questions (id 171-180) Physics /Mechanics /level Hard answers  
---10 questions (id 181-190) Physics  /Thermodynamics /level Easy answers   
---10 questions(id 191-200) Physics /Thermodynamics /level Medium answers   
---10 questions (id 201-210) Physics /Thermodynamics /level Hard answers   
---10 questions (id 211-220) Physics /Electromagnetism /level Easy answers   
---10 questions (id 221-230) Physics /Electromagnetism /level Medium answers  
---10 questions (id 231-240) Physics /Electromagnetism /level Hard answers 




---10 questions (id 241-250) Operating systems /Memory management /level Easy answers  
---10 questions (id 251-260) Operating systems /Memory management /level Medium answers 
---10 questions (id 261-270) Operating systems /Memory management /level Hard answers 
---10 questions (271-280) Operating systems /Process management /level Easy answers 
---10 questions (281-290) Operating systems /Process management /level Medium answers 
---10 questions (291-300) Operating systems /Process management /level Hard answers 
---10 questions(301-310) Operating systems /File management /level Easy answers 
---10 questions (311-320) Operating systems /File management /level Medium answers 
---10 questions (321-330) Operating systems /File management /level Hard answers 




---dynamic generation
---20 questions Math MOCK Exam /Medium answers  
---20 questions  english /MOCK Exam /Medium answers    
---20 questions Physics /MOCK Exam /Medium answers 
---20 questions Operating systems /MOCK Exam /Medium answers 








-- Reward system/leaderboard system

CREATE TABLE user_attempts (
    attempt_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    answer_id INT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (question_id) REFERENCES questions(question_id),
    FOREIGN KEY (answer_id) REFERENCES answers(answer_id)
);

CREATE TABLE student_progress (
    progress_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    total_points INT DEFAULT 0,
    user_level INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE OR REPLACE FUNCTION update_student_progress()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE student_progress
    SET total_points = total_points + 1, 
        user_level = (total_points + 1) / 100
    WHERE user_id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_student_progress
AFTER INSERT ON user_attempts
FOR EACH ROW
WHEN (NEW.is_correct = TRUE)
EXECUTE FUNCTION update_student_progress();

-- when a new user logs into app, a insert needs to be made into these tables, we can keep points and level 0 for every new user insert. 

-- After user attempts a question in a quiz/mock test. The user inputs are recorded (inserted) into user_attempts.
-- So that the update_student_progress function can check from the database whether the user answer is TRUE or FALSE
-- Then the function calculates the total_points/level into student_progress



