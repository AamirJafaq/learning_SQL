/* Two tables, student and student_log, were created. A trigger function 
and an associated trigger were then implemented. Whenever a new record is 
inserted into the student table, the trigger automatically logs the student’s 
name along with the registration timestamp into the student_log table, 
recording the exact time the student is registered in the system.
*/

-- Create student table.
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    registration_num VARCHAR(20) NOT NULL
);

-- Create student_log table
DROP TABLE IF EXISTS student_log;
CREATE TABLE student_log (
    log_id SERIAL PRIMARY KEY,
    student_id INT,
    name VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create trigger function
CREATE OR REPLACE FUNCTION student_log_data()
RETURNS TRIGGER 
LANGUAGE plpgsql 
AS $$
BEGIN 
INSERT INTO student_log (student_id, name) 
		VALUES (NEW.student_id, NEW.name);
		RETURN NEW;
END;
$$;
CREATE TRIGGER student_log_trigger
AFTER INSERT ON students
FOR EACH ROW
EXECUTE FUNCTION student_log_data();


-- Display the student_log table and insert some values.
SELECT * FROM student_log;

INSERT INTO students (student_id, name, age, registration_num) VALUES
(1, 'Aamir Khan', 22, 'AK081'),
(2, 'Sara Ali', 20, 'SA101'),
(3, 'John Doe', 21, 'JD0811'),
(4, 'Jane Smith', 23, 'JS092');

-- Display the student_log table aftering inserting values.
SELECT * FROM student_log;
