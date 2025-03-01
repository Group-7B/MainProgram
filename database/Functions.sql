-- Create the student_progress table
CREATE TABLE student_progress (
    user_id INT,  -- Foreign key to users table
    subject_id INT,  -- Foreign key to subjects table
    current_level FLOAT DEFAULT 0,  -- Student's level in the subject
    correct_answers INT DEFAULT 0,  -- Number of correct answers by the student in the subject
    total_answers INT DEFAULT 0,    -- Total number of answers attempted by the student
    last_update TIMESTAMP DEFAULT NOW(),  -- Last time progress was updated
    PRIMARY KEY (user_id, subject_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


-- Function to update student progress after completing a quiz
CREATE OR REPLACE FUNCTION update_student_progress_after_quiz(p_user_id INT, p_quiz_id INT) RETURNS VOID AS $$
DECLARE
    v_subject_id INT;
    v_correct_answers INT;
    v_total_questions INT;
BEGIN
    -- Fetch the subject_id of the quiz
    SELECT subject_id INTO v_subject_id FROM quizzes WHERE quiz_id = p_quiz_id;

    -- Count the number of correct answers the user got in this quiz
    SELECT COUNT(*) INTO v_correct_answers
    FROM quiz_questions qq
    JOIN answers a ON qq.question_id = a.question_id
    WHERE qq.quiz_id = p_quiz_id AND a.is_correct = TRUE;

    -- Count the total number of questions in the quiz
    SELECT COUNT(*) INTO v_total_questions FROM quiz_questions WHERE quiz_id = p_quiz_id;

    -- Check if the student already has a progress record for the subject
    IF EXISTS (SELECT 1 FROM student_progress WHERE user_id = p_user_id AND subject_id = v_subject_id) THEN
        -- Update the student's progress: add correct answers and recalculate level
        UPDATE student_progress
        SET correct_answers = correct_answers + v_correct_answers,
            total_answers = total_answers + v_total_questions,
            current_level = current_level + (v_correct_answers::FLOAT / v_total_questions::FLOAT),  -- Adjust level logic as needed
            last_update = NOW()
        WHERE user_id = p_user_id AND subject_id = v_subject_id;
    ELSE
        -- If no progress exists, insert a new record with the correct answers
        INSERT INTO student_progress (user_id, subject_id, current_level, correct_answers, total_answers)
        VALUES (p_user_id, v_subject_id, (v_correct_answers::FLOAT / v_total_questions::FLOAT), v_correct_answers, v_total_questions);
    END IF;
END;
$$ LANGUAGE plpgsql;