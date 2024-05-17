-- -- CREATE TABLE track (
-- --   track_id VARCHAR PRIMARY KEY,
-- --   track_title VARCHAR
-- -- );

-- -- CREATE TABLE course (
-- --   course_id VARCHAR primary key,
-- --   track_id VARCHAR,
-- --   course_title VARCHAR,
-- --   FOREIGN KEY (track_id) REFERENCES track(track_id)
-- -- );

-- -- CREATE TABLE topic (
-- --   topic_id VARCHAR PRIMARY KEY,
-- --   course_id VARCHAR,
-- --   topic_title VARCHAR,
-- --   FOREIGN KEY (course_id) REFERENCES course(course_id)
-- -- );

-- -- CREATE TABLE lesson (
-- --   lesson_id VARCHAR PRIMARY KEY,
-- --   topic_id VARCHAR,
-- --   lesson_title VARCHAR,
-- --   lesson_type VARCHAR,
-- --   duration_in_sec INTEGER,
-- --   FOREIGN KEY (topic_id) REFERENCES topic(topic_id)
-- -- );

-- -- CREATE TABLE registrations (
-- --   user_id VARCHAR PRIMARY KEY,
-- --   registration_date DATE,
-- --   user_info VARCHAR
-- -- );

-- -- CREATE TABLE user_lesson_progress (
-- --   id VARCHAR,
-- --   user_id VARCHAR,
-- --   lesson_id VARCHAR,
-- --   completion_percentage_difference FLOAT,
-- --   overall_completion_percentage FLOAT,
-- --   activity_recorded_datetime_in_utc TIMESTAMP WITH TIME ZONE,
-- --   FOREIGN KEY (user_id) REFERENCES registrations(user_id),
-- --   FOREIGN KEY (lesson_id) REFERENCES lesson(lesson_id)
-- -- );

-- -- CREATE TABLE user_feedback (
-- --   id VARCHAR PRIMARY KEY,
-- --   feedback_id VARCHAR,
-- --   creation_datetime TIMESTAMP WITH TIME ZONE,
-- --   user_id VARCHAR,
-- --   lesson_id VARCHAR,
-- --   language VARCHAR,
-- --   question VARCHAR,
-- --   answer VARCHAR,
-- --   FOREIGN KEY (user_id) REFERENCES registrations(user_id),
-- --   FOREIGN KEY (lesson_id) REFERENCES lesson(lesson_id)
-- -- );


-- copy track from 'D:\PROJECTS\Analytics Engineer\track_table.csv' csv header;
-- -- Assuming the `track` table has been loaded as per your initial command
-- -- COPY track FROM 'D:\PROJECTS\Analytics Engineer\track_table.csv' CSV HEADER;

-- COPY course FROM 'D:\PROJECTS\Analytics Engineer\course_table.csv' CSV HEADER;

-- COPY topic FROM 'D:\PROJECTS\Analytics Engineer\topic_table.csv' CSV HEADER;

-- COPY lesson FROM 'D:\PROJECTS\Analytics Engineer\lesson_table.csv' CSV HEADER;

-- COPY registrations FROM 'D:\PROJECTS\Analytics Engineer\user_registrations.csv' CSV HEADER;

-- COPY user_lesson_progress FROM 'D:\PROJECTS\Analytics Engineer\user_lesson_progress_log.csv' CSV HEADER;

-- COPY user_feedback FROM 'D:\PROJECTS\Analytics Engineer\user_feedback.csv' CSV HEADER;

-- How many users have logged progress in any lesson within the last 30 days?

SELECT COUNT(DISTINCT user_id) AS active_users
FROM user_lesson_progress
WHERE activity_recorded_datetime_in_utc >= 
	((select max(activity_recorded_datetime_in_utc) from user_lesson_progress) - INTERVAL '30 days');

-- How many courses are available for each track?

SELECT t1.track_id,t1.Track_title,count (distinct t2.course_id) number_of_courses
FROM track t1 left join course t2 on t1.track_id=t2.track_id
GROUP BY t1.track_id,t1.Track_title;


-- What is the average duration of lessons in each course?


SELECT c.course_title, ROUND(AVG(l.duration_in_sec),2) AS avg_duration_in_sec
FROM course c
JOIN topic t ON c.course_id = t.course_id
JOIN lesson l ON t.topic_id = l.topic_id
GROUP BY c.course_title;

-- What is the overall completion percentage for each user on 'Google Colab and Numpy' lesson?


SELECT user_id, overall_completion_percentage
FROM user_lesson_progress t1
	left join lesson t2 on t1.lesson_id=t2.lesson_id 
and t2.lesson_id = 'Google Colab and Numpy'
limit 10;

-- What is the average completion percentage of lessons across all users?
SELECT l.lesson_title, 
	ROUND(AVG(ulp.overall_completion_percentage)::numeric,2) AS avg_completion
FROM lesson l
JOIN user_lesson_progress ulp ON l.lesson_id = ulp.lesson_id
GROUP BY l.lesson_title
ORDER BY 2 Desc;


-- How many feedback entries have been submitted for each lesson?
SELECT l.lesson_title, COUNT(uf.id) AS feedback_count
FROM lesson l
JOIN user_feedback uf ON l.lesson_id = uf.lesson_id
GROUP BY l.lesson_title
ORDER BY 2 DESC;

-- What are the most common aspects mentioned in user feedback for the categories "LIKED", "OTHER", and "BETTER_TO_IMPROVE"?
-- LIKED
SELECT liked, COUNT(*) AS frequency
FROM (
  SELECT unnest(string_to_array(answer, ', ')) AS liked
  FROM user_feedback
  WHERE question = 'LIKED'
) AS liked_feedback
GROUP BY liked
ORDER BY frequency DESC
LIMIT 10;

-- OTHER
SELECT other, COUNT(*) AS frequency
FROM (
  SELECT unnest(string_to_array(answer, ', ')) AS other
  FROM user_feedback
  WHERE question = 'OTHER'
) AS other_feedback
GROUP BY other
ORDER BY frequency DESC
LIMIT 10;

-- BETTER_TO_IMPROVE
SELECT better_to_improve, COUNT(*) AS frequency
FROM (
  SELECT unnest(string_to_array(answer, ', ')) AS better_to_improve
  FROM user_feedback
  WHERE question = 'BETTER_TO_IMPROVE'
) AS improve_feedback
GROUP BY better_to_improve
ORDER BY frequency DESC
LIMIT 10;


