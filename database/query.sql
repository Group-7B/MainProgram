select * from quizzes;
select quiz_name  from quizzes;
/* quiz_id | subject_id | topic_id |          quiz_name          | quiz_type | quiz_level 
---------+------------+----------+-----------------------------+-----------+------------
       1 |          1 |        1 | Algebra Quiz 1              | quiz      | Easy
       2 |          1 |        1 | Algebra Quiz 2              | quiz      | Medium
       3 |          1 |        1 | Algebra Quiz 3              | quiz      | Hard
       4 |          1 |        2 | Ratio and Proportion Quiz 1 | quiz      | Easy
       5 |          1 |        2 | Ratio and Proportion Quiz 2 | quiz      | Medium
       6 |          1 |        2 | Ratio and Proportion Quiz 3 | quiz      | Hard
       7 |          1 |        3 | Percentage Quiz 1           | quiz      | Easy
       8 |          1 |        3 | Percentage Quiz 2           | quiz      | Medium
       9 |          1 |        3 | Percentage Quiz 3           | quiz      | Hard
      10 |          1 |          | Math exam                   | MOCK Exam | Medium
      11 |          2 |        4 | Vocabulary Quiz 1           | quiz      | Easy
      12 |          2 |        4 | Vocabulary Quiz 2           | quiz      | Medium
      13 |          2 |        4 | Vocabulary Quiz 3           | quiz      | Hard
      14 |          2 |        5 | Grammar Quiz 1              | quiz      | Easy
      15 |          2 |        5 | Grammar Quiz 2              | quiz      | Medium
      16 |          2 |        5 | Grammar Quiz 3              | quiz      | Hard
      17 |          2 |          | English exam                | MOCK Exam | Medium
      18 |          3 |        6 | Mechanics Quiz 1            | quiz      | Easy
      19 |          3 |        6 | Mechanics Quiz 2            | quiz      | Medium
      20 |          3 |        6 | Mechanics Quiz 3            | quiz      | Hard
      21 |          3 |        7 | Thermodynamics Quiz 1       | quiz      | Easy
      22 |          3 |        7 | Thermodynamics Quiz 2       | quiz      | Medium
      23 |          3 |        7 | Thermodynamics Quiz 3       | quiz      | Hard
      24 |          3 |        8 | Electromagnetism Quiz 1     | quiz      | Easy
      25 |          3 |        8 | Electromagnetism Quiz 2     | quiz      | Medium
      26 |          3 |        8 | Electromagnetism Quiz 3     | quiz      | Hard
      27 |          3 |          | Physics exam                | MOCK Exam | Medium
      28 |          4 |        9 | Memory management Quiz 1    | quiz      | Easy
      29 |          4 |        9 | Memory management Quiz 2    | quiz      | Medium
      30 |          4 |        9 | Memory management Quiz 3    | quiz      | Hard
      31 |          4 |       10 | Process management Quiz 1   | quiz      | Easy
      32 |          4 |       10 | Process management Quiz 2   | quiz      | Medium
      33 |          4 |       10 | Process management Quiz 3   | quiz      | Hard
      34 |          4 |       11 | File management Quiz 1      | quiz      | Easy
      35 |          4 |       11 | File management Quiz 2      | quiz      | Medium
      36 |          4 |       11 | File management Quiz 3      | quiz      | Hard
      37 |          4 |          | Operating systems exam      | MOCK Exam | Medium
(37 rows)*/


select * from questions where question_id between 11 and 20;

/* question_id | topic_id |                     question_text                      | points | question_level
-------------+----------+--------------------------------------------------------+--------+----------------
          11 |        1 | What is the value of x in the equation: 2x + 3 = 11?   |      2 | Medium
          12 |        1 | Solve for x: 3x - 5 = 10                               |      2 | Medium
          13 |        1 | What is 4x - 3 = 13 when solved for x?                 |      2 | Medium
          14 |        1 | What is the next term in the pattern: 3, 6, 9, 12, __? |      2 | Medium
          15 |        1 | What is the simplified form of 4x + 5x?                |      2 | Medium
          16 |        1 | If x = 4, what is the value of 3x + 6?                 |      2 | Medium
          17 |        1 | Which expression is equivalent to x * x * x?           |      2 | Medium
          18 |        1 | If y = 15, what is y - 8?                              |      2 | Medium
          19 |        1 | Solve for x: x/3 = 7                                   |      2 | Medium
          20 |        1 | What is the value of 4(x + 3) = 28?                    |      2 | Medium
(10 rows)*/



select * from quiz_questions where quiz_id =2;

/*quiz_id | question_id
---------+-------------
       2 |          11
       2 |          12
       2 |          13
       2 |          14
       2 |          15
       2 |          16
       2 |          17
       2 |          18
       2 |          19
       2 |          20
(10 rows)*/




SELECT 
    q.question_id,
    q.question_text,
    STRING_AGG(a.answer_text, ', ') AS all_answers,
    quizzes.quiz_name,
    quizzes.quiz_level
FROM questions q
JOIN answers a ON q.question_id = a.question_id
JOIN quiz_questions qq ON q.question_id = qq.question_id
JOIN quizzes ON qq.quiz_id = quizzes.quiz_id
where quiz_name = 'Algebra Quiz 3' -- just change the name of the quiz to get the questions and answers for that quiz
GROUP BY q.question_id, q.question_text, quizzes.quiz_name, quizzes.quiz_level
ORDER BY q.question_id;


/*question_id |                     question_text                      |                  all_answers                   |   quiz_name    | quiz_level 
-------------+--------------------------------------------------------+------------------------------------------------+----------------+------------
          11 | What is the value of x in the equation: 2x + 3 = 11?   | x = 4, x = 7, x = 12                           | Algebra Quiz 2 | Medium
          12 | Solve for x: 3x - 5 = 10                               | (x - 6)(x - 3), (x + 6)(x - 3), (x - 9)(x + 2) | Algebra Quiz 2 | Medium
          13 | What is 4x - 3 = 13 when solved for x?                 | x = -3, x = 2, x = 3, x = -2, x = 3, x = 2     | Algebra Quiz 2 | Medium
          14 | What is the next term in the pattern: 3, 6, 9, 12, __? | x + 2, x^2 + 4, 2x + 2                         | Algebra Quiz 2 | Medium
          15 | What is the simplified form of 4x + 5x?                | f(2) = 6, f(2) = 4, f(2) = 6                   | Algebra Quiz 2 | Medium
          16 | If x = 4, what is the value of 3x + 6?                 | x = 7, x = 6, x = 5                            | Algebra Quiz 2 | Medium
          17 | Which expression is equivalent to x * x * x?           | x = 3, x = 2, x = -3, x = 2, x = -3, x = -2    | Algebra Quiz 2 | Medium
          18 | If y = 15, what is y - 8?                              | x = 9, x = 8, x = 7                            | Algebra Quiz 2 | Medium
          19 | Solve for x: x/3 = 7                                   | a + b = 7, a + b = 10, a + b = 5               | Algebra Quiz 2 | Medium
          20 | What is the value of 4(x + 3) = 28?                    | x^2 + 3x - 10, x^2 + x - 10, x^2 + 7x - 10     | Algebra Quiz 2 | Medium
(10 rows)*/



select* from questions where question_id between 21 and 30;
/*
 question_id | topic_id |                                              question_text                                              | points | question_level
-------------+----------+---------------------------------------------------------------------------------------------------------+--------+----------------
          21 |        1 | Solve for x: 3x - 7 = 2x + 5                                                                            |      3 | Hard
          22 |        1 | Factor completely: x^3 - 6x^2 + 11x - 6                                                                 |      3 | Hard
          23 |        1 | Find the roots of the equation: 2x^2 - 5x - 3 = 0                                                       |      3 | Hard
          24 |        1 | Simplify: (2x - 3)(x + 4) - (x - 2)(x + 1)                                                              |      3 | Hard
          25 |        1 | Solve for x: (x + 2)/(x - 1) = (x - 3)/(x + 4)                                                          |      3 | Hard
          26 |        1 | Find the inverse function of f(x) = (3x - 4)/5                                                          |      3 | Hard
          27 |        1 | Determine the value of x in the system: 2x + 3y = 7 and 4x - y = 5                                      |      3 | Hard
          28 |        1 | Solve the inequality: (x - 2)(x + 5) < 0                                                                |      3 | Hard
          29 |        1 | Evaluate the determinant of the matrix: | 2  -1 | | 3  4 |                                              |      3 | Hard
          30 |        1 | Find the sum of the first 10 terms of the arithmetic sequence with first term 7 and common difference 3 |      3 | Hard
(10 rows)
*/

select * from quiz_questions where quiz_id =3;
/*
 quiz_id | question_id
---------+-------------
       3 |          21
       3 |          22
       3 |          23
       3 |          24
       3 |          25
       3 |          26
       3 |          27
       3 |          28
       3 |          29
       3 |          30
(10 rows)*/

select * from answers where question_id between 21 and 30;
/*
 answer_id | question_id |      answer_text       | is_correct
-----------+-------------+------------------------+------------
        61 |          21 | x = 12                 | t
        62 |          21 | x = -12                | f
        63 |          21 | x = 8                  | f
        64 |          22 | (x - 1)(x - 2)(x - 3)  | t
        65 |          22 | (x + 1)(x - 2)(x - 3)  | f
        66 |          22 | (x - 1)(x + 2)(x - 3)  | f
        67 |          23 | x = 3, x = -0.5        | t
        68 |          23 | x = -3, x = 0.5        | f
        69 |          23 | x = 1, x = -3          | f
        70 |          24 | x^2 + 3x - 10          | t
        71 |          24 | 2x^2 - x + 5           | f
        72 |          24 | x^2 - 3x + 10          | f
        73 |          25 | x = -1                 | t
        74 |          25 | x = 5                  | f
        75 |          25 | x = 2                  | f
        76 |          26 | f^(-1)(x) = (5x + 4)/3 | t
        77 |          26 | f^(-1)(x) = (3x - 4)/5 | f
        78 |          26 | f^(-1)(x) = (5x - 4)/3 | f
        79 |          27 | x = 2                  | t
        80 |          27 | x = -2                 | f
        81 |          27 | x = 3                  | f
        82 |          28 | -5 < x < 2             | t
        83 |          28 | x > 5 or x < -2        | f
        84 |          28 | x > 2 and x < -5       | f
        85 |          29 | 11                     | t
        86 |          29 | 10                     | f
        87 |          29 | 12                     | f
        88 |          30 | 157                    | t
        89 |          30 | 147                    | f
        90 |          30 | 167                    | f
(30 rows)*/




--- list question id, quiz_question_id, and answer _id for all questions in the quiz Ratio and Proportion Quiz 3
select q.question_id, qq.quiz_id, a.answer_id
from questions q
join quiz_questions qq on q.question_id = qq.question_id
join answers a on q.question_id = a.question_id
join quizzes on qq.quiz_id = quizzes.quiz_id
where qq.quiz_id=7
order by q.question_id;

