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


-- testing
INSERT INTO users (user_name, user_last_name, user_email, user_password, join_date)
VALUES ('John', 'Doe', 'john.doe@example.com', 'password123', NOW()) RETURNING user_id;

INSERT INTO student_progress (user_id, total_points, user_level) 
VALUES (1, 0, 0); 

-- when a new user logs into app, a insert needs to be made into these tables, we can keep points and level 0 for every new user insert. 

INSERT INTO user_attempts (user_id, question_id, answer_id, is_correct)
VALUES (1, 1, 3, TRUE);
INSERT INTO user_attempts (user_id, question_id, answer_id, is_correct)
VALUES (1, 2, 3, TRUE);
INSERT INTO user_attempts (user_id, question_id, answer_id, is_correct)
VALUES (1, 3, 3, TRUE);
INSERT INTO user_attempts (user_id, question_id, answer_id, is_correct)
VALUES (1, 4, 3, TRUE);
INSERT INTO user_attempts (user_id, question_id, answer_id, is_correct)
VALUES (1, 5, 3 TRUE);
INSERT INTO user_attempts (user_id, question_id, answer_id, is_correct)
VALUES (1, 6, 3, TRUE);
INSERT INTO user_attempts (user_id, question_id, answer_id, is_correct)
VALUES (1, 7, 3, TRUE);
-- After user attempts a question in a quiz/mock test. The user inputs are recorded (inserted) into user_attempts.
-- So that the update_student_progress function can check from the database whether the user answer is TRUE or FALSE
-- Then the function calculates the total_points/level into student_progress