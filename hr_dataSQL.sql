/*
This SQL file illustrates the process of parsing text fields into DATE values using TO_DATE(), 
converting text data types to DATE, adding new columns, inserting values into those columns, and 
renaming columns.
*/


DROP TABLE IF EXISTS hr;
CREATE TABLE hr (
iiid TEXT PRIMARY KEY ,
first_name TEXT,
last_time TEXT,
birthdate TEXT,
gender TEXT,
race TEXT,
department TEXT,
jobtitle TEXT,
location TEXT,
hire_date TEXT, 
termdate TEXT,
location_city TEXT,
location_state TEXT
);

SELECT * FROM hr;

-- Rename the column name iiid to id.
ALTER TABLE hr
RENAME COLUMN iiid TO id;

-- Change the datatye of id column.
ALTER TABLE hr
ALTER COLUMN id TYPE VARCHAR(50); 


-- For birthdate, parse the date using TO_DATE and convert it to the DATE data type..
UPDATE hr
SET birthdate=
	CASE WHEN trim(birthdate) ~'^\d{4}-\d{1,2}-\d{1,2}$' THEN TO_DATE(trim(birthdate), 'YYYY-MM-DD')::TEXT
	     WHEN trim(birthdate) ~'^\d{1,2}/\d{1,2}/\d{4}$' THEN TO_DATE(trim(birthdate), 'MM/DD/YYYY')::TEXT
		 WHEN trim(birthdate) ~'^[A-Za-z]+, [A-Za-z]+ \d{1,2}, \d{4}$' THEN TO_DATE(trim(birthdate), 'FMDay, FMMonth DD, YYYY')::TEXT
		 ELSE birthdate
		 END;  

ALTER TABLE hr
ALTER COLUMN birthdate TYPE DATE
USING birthdate::DATE; 


-- For hire_date, parse the date using TO_DATE and convert it to the DATE data type.
UPDATE hr
SET hire_date = 
	CASE WHEN trim(hire_date) ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN TO_DATE(trim(hire_date), 'MM/DD/YYYY')::TEXT
		 WHEN trim(hire_date) ~ '^\d{4}-\d{1,2}-\d{1,2}$' THEN TO_DATE(trim(hire_date), 'YYYY-MM-DD')::TEXT
		 WHEN trim(hire_date) ~ '^[A-Za-z]+, [A-Za-z]+ \d{1,2}, \d{4}$' THEN TO_DATE(trim(hire_date), 'FMDay, FMMonth DD, YYYY')::TEXT
		 ELSE hire_date
		 END;

ALTER TABLE hr
ALTER COLUMN hire_date TYPE DATE
USING hire_date::DATE;


-- For termdate, parse the date using TO_DATE and convert it to the DATE data type.
UPDATE hr
SET termdate = CASE WHEN trim(termdate) ~ '^\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2} UTC$' THEN TO_DATE(trim(termdate), 'YYYY-MM-DD-HH24-MI-SS UTC')::TEXT
					ELSE termdate
					END;
ALTER TABLE hr
ALTER COLUMN termdate TYPE DATE
USING termdate::DATE;

-- Adding new column age with data type int.
 ALTER TABLE hr
 ADD COLUMN age INT;

-- Insert values into age column.
UPDATE hr
SET age= EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate));


