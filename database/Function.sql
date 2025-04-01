-- Updated Student_progress table to track points separately
CREATE TABLE Student_progress( 
    student_progress_id SERIAL PRIMARY KEY,
    user_id INT,
    quiz_id INT,
    progress_level INT DEFAULT 0, -- Starts at level 0
    total_points INT DEFAULT 0, -- Tracks accumulated points
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id)
);

ALTER TABLE answers ADD COLUMN user_id INT;

-- Add a foreign key constraint to link answers to users
ALTER TABLE answers ADD CONSTRAINT fk_answers_users
FOREIGN KEY (user_id) REFERENCES users(user_id);


CREATE OR REPLACE FUNCTION update_progress(user_id_param INT, question_id_param INT) RETURNS VOID AS $$
DECLARE
    earned_points INT := 0;
    current_points INT := 0;
    current_level INT := 0;
    quiz_id_param INT;
BEGIN
    -- Get the quiz_id for the given question
    SELECT quizzes.quiz_id INTO quiz_id_param
    FROM quizzes
    JOIN quiz_questions ON quizzes.quiz_id = quiz_questions.quiz_id
    WHERE quiz_questions.question_id = question_id_param
    LIMIT 1;

    -- Get the points for the correct answer
    SELECT points INTO earned_points 
    FROM questions 
    WHERE question_id = question_id_param;

    -- Ensure the answer is correct
    IF EXISTS (
        SELECT 1 FROM answers
        WHERE question_id = question_id_param 
        AND user_id = user_id_param
        AND is_correct = TRUE
    ) THEN
        -- Check if progress exists
        SELECT total_points, progress_level INTO current_points, current_level
        FROM Student_progress
        WHERE user_id = user_id_param AND quiz_id = quiz_id_param;

        -- If no progress exists, insert a new record
        IF NOT FOUND THEN
            INSERT INTO Student_progress (user_id, quiz_id, total_points, progress_level)
            VALUES (user_id_param, quiz_id_param, earned_points, 0);
        ELSE
            -- Update points
            current_points := current_points + earned_points;

            -- Level up if needed
            IF current_points >= 100 THEN
                current_level := current_level + 1;
                current_points := current_points - 100;
            END IF;

            -- Update the progress table
            UPDATE Student_progress
            SET total_points = current_points, progress_level = current_level
            WHERE user_id = user_id_param AND quiz_id = quiz_id_param;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION trigger_update_progress() RETURNS TRIGGER AS $$
BEGIN
    -- Call update_progress for the user and question
    PERFORM update_progress(NEW.user_id, NEW.question_id);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger on the answers table
CREATE TRIGGER trg_update_student_progress
AFTER INSERT ON answers
FOR EACH ROW
EXECUTE FUNCTION trigger_update_progress();



CREATE OR REPLACE FUNCTION insert_progress_for_new_user() RETURNS TRIGGER AS $$
BEGIN
    -- Insert a progress record for each quiz that exists
    INSERT INTO Student_progress (user_id, quiz_id)
    SELECT NEW.user_id, quiz_id FROM quizzes;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to insert progress when a new user is added
CREATE TRIGGER trg_insert_progress_for_new_user
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION insert_progress_for_new_user();


INSERT INTO Student_progress (user_id, quiz_id, progress_level, total_points)
VALUES (1, 1, 0, 0);

INSERT INTO users (user_name, user_last_name, user_email, user_password, join_date)
VALUES ('John', 'Doe', 'john.doe@example.com', 'password123', NOW()) RETURNING user_id;

SELECT update_progress(1, 1);

SELECT * FROM Student_progress WHERE user_id = 1;

UPDATE answers SET user_id = 1;
