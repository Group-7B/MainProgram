SELECT 
qu.quiz_name AS "Quiz Name",
s.subject_name AS "Subject Name",
t.topic_name AS "Topic Name",
qu.quiz_type AS "Quiz Type",
qu.quiz_level AS "Quiz Level",
q.question_id AS "Question ID",
q.question_text AS "Question Text",
    STRING_AGG(CONCAT(a.answer_text, ' ', a.is_correct::text), ', ') AS "Answers"
FROM subjects s
JOIN topics t ON s.subject_id = t.subject_id
JOIN quizzes qu ON t.topic_id = qu.topic_id
JOIN quiz_questions qq ON qu.quiz_id = qq.quiz_id
JOIN questions q ON qq.question_id = q.question_id
JOIN answers a ON q.question_id = a.question_id
GROUP BY qu.quiz_name, t.topic_name, qu.quiz_type, qu.quiz_level, q.question_id, q.question_text,subject_name
ORDER BY qu.quiz_name, q.question_id;


/* Quiz Name    | Subject Name | Topic Name | Quiz Type | Quiz Level | Question ID |                     Question Text                     |            Answers
----------------+--------------+------------+-----------+------------+-------------+-------------------------------------------------------+-------------------------------
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           1 | What is the value of x in the equation: x + 5 = 10?   | 10 true, 5 false, 3 false
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           2 | Solve for x: 2x = 8                                   | 6 false, 4 true, 2 false
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           3 | What is 5x - 3 = 7 when solved for x?                 | 6 false, 2 true, 3 false
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           4 | What is the next term in the pattern: 2, 4, 6, 8, __? | 12 false, 10 true, 9 false
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           5 | What is the simplified form of 3x + 4x?               | 3x4 false, 12x false, 7x true
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           6 | If x = 3, what is the value of 2x + 5?                | 8 false, 11 true, 6 false
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           7 | Which expression is equivalent to x * x?              | x+1 false, 2x false, x² true
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           8 | If y = 10, what is y - 6?                             | 8 false, 6 false, 4 true
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |           9 | Solve for x: x/2 = 6                                  | 8 false, 3 false, 12 true
 Algebra Quiz 1 | Mathematics  | Algebra    | quiz      | Easy       |          10 | What is the value of 3(x + 2) = 12?                   | 4 false, 2 true, 3 false
(10 rows)  */




select q.question_id,quizzes.quiz_name, qq.quiz_id, a.answer_id, quizzes.quiz_type, quizzes.quiz_level, a.answer_text, a.is_correct
from questions q
join quiz_questions qq on q.question_id = qq.question_id
join answers a on q.question_id = a.question_id
join quizzes on qq.quiz_id = quizzes.quiz_id
where qq.quiz_id= 36
order by q.question_id;


/* question_id |  quiz_name   | quiz_id | answer_id | quiz_type | quiz_level |                            answer_text                             | is_correct
-------------+--------------+---------+-----------+-----------+------------+--------------------------------------------------------------------+------------
         153 | Physics exam |      36 |       457 | MOCK Exam | Medium     | 2 m/s²                                                             | t
         153 | Physics exam |      36 |       458 | MOCK Exam | Medium     | 5 m/s²                                                             | f
         153 | Physics exam |      36 |       459 | MOCK Exam | Medium     | 10 m/s²                                                            | f
         159 | Physics exam |      36 |       475 | MOCK Exam | Medium     | The speed of an object                                             | f
         159 | Physics exam |      36 |       476 | MOCK Exam | Medium     | The energy required to stop an object                              | f
         159 | Physics exam |      36 |       477 | MOCK Exam | Medium     | The product of mass and velocity                                   | t
         165 | Physics exam |      36 |       493 | MOCK Exam | Medium     | 10 m                                                               | f
         165 | Physics exam |      36 |       494 | MOCK Exam | Medium     | 40 m                                                               | f
         165 | Physics exam |      36 |       495 | MOCK Exam | Medium     | 20 m                                                               | t
         172 | Physics exam |      36 |       514 | MOCK Exam | Medium     | 10 kg·m/s                                                          | f
         172 | Physics exam |      36 |       515 | MOCK Exam | Medium     | -20 kg·m/s                                                         | f*/