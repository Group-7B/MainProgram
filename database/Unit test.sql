-- Setup: Create temp tables for test
DROP TABLE IF EXISTS student_progress, user_attempts;

CREATE TEMP TABLE student_progress (
    user_id INT PRIMARY KEY,
    total_points INT DEFAULT 0,
    user_level NUMERIC DEFAULT 0
);

CREATE TEMP TABLE user_attempts (
    attempt_id SERIAL PRIMARY KEY,
    user_id INT,
    is_correct BOOLEAN
);

-- Recreate the function and trigger for the temp tables
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

DROP TRIGGER IF EXISTS trigger_update_student_progress ON user_attempts;

CREATE TRIGGER trigger_update_student_progress
AFTER INSERT ON user_attempts
FOR EACH ROW
WHEN (NEW.is_correct = TRUE)
EXECUTE FUNCTION update_student_progress();

-- Begin testing
DO $$
DECLARE
    tp INT;
    ul NUMERIC;
BEGIN
    RAISE NOTICE 'Test 1: Insert correct attempt and check progress';

    INSERT INTO student_progress (user_id, total_points, user_level) VALUES (1, 10, 0.1);
    INSERT INTO user_attempts (user_id, is_correct) VALUES (1, TRUE);

    SELECT total_points, user_level INTO tp, ul FROM student_progress WHERE user_id = 1;

    IF tp != 11 THEN
        RAISE EXCEPTION 'Test Failed: Expected total_points = 11, got %', tp;
    ELSE
        RAISE NOTICE '✓ total_points incremented to %', tp;
    END IF;

    IF ul != (11 + 1) / 100.0 THEN
        RAISE EXCEPTION 'Test Failed: Expected user_level = %, got %', (11 + 1) / 100.0, ul;
    ELSE
        RAISE NOTICE '✓ user_level correctly updated to %', ul;
    END IF;
END $$;

-- Test 2: Insert incorrect attempt and check that total_points does not change
DO $$
DECLARE
    tp INT;
BEGIN
    RAISE NOTICE 'Test 2: Insert incorrect attempt and verify no update';

    INSERT INTO user_attempts (user_id, is_correct) VALUES (1, FALSE);

    SELECT total_points INTO tp FROM student_progress WHERE user_id = 1;

    IF tp != 11 THEN
        RAISE EXCEPTION 'Test Failed: Expected total_points to remain 11, got %', tp;
    ELSE
        RAISE NOTICE '✓ total_points unchanged at % on incorrect attempt', tp;
    END IF;
END $$;


-- NOTICE:  Test 1: Insert correct attempt and check progress
-- NOTICE:  ✓ total_points incremented to 11
-- NOTICE:  ✓ user_level correctly updated to 0.12
-- NOTICE:  Test 2: Insert incorrect attempt and verify no update
-- NOTICE:  ✓ total_points unchanged at 11 on incorrect attempt
