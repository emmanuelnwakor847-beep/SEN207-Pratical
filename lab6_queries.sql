-- ============================================
-- VUA-SEN307 Lab 6: Aggregates, Grouping and Subqueries
-- Name: Nwakor Chukwunweike Emmanuel Matric: 11233
-- ============================================
USE sen307_12368;

-- Task 1: Count the students enrolled in each course, including courses with zero students

SELECT c.course_code, c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title
ORDER BY total_students DESC;

-- Task 2: Find courses with more than a given number of students using HAVING (thresholds: 3, 5, and 7)

-- Threshold > 3
SELECT c.course_code, c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title
HAVING COUNT(e.student_id) > 3
ORDER BY total_students DESC;

-- Threshold > 5
SELECT c.course_code, c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title
HAVING COUNT(e.student_id) > 5
ORDER BY total_students DESC;

-- Threshold > 7
SELECT c.course_code, c.course_title, COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title
HAVING COUNT(e.student_id) > 7
ORDER BY total_students DESC;

-- Task 3: Calculate the average number of courses taken per student (including students with zero courses)

SELECT ROUND(AVG(course_count), 2) AS avg_courses_per_student
FROM (
    SELECT s.student_id, COUNT(e.course_id) AS course_count
    FROM Student s
    LEFT JOIN Enrolment e ON s.student_id = e.student_id
    GROUP BY s.student_id
) AS per_student;

-- Task 4 (Non-correlated subquery): Find students not enrolled in any course

SELECT s.student_id, s.matric_no, s.full_name
FROM Student s
WHERE s.student_id NOT IN (
    SELECT DISTINCT student_id 
    FROM Enrolment 
    WHERE student_id IS NOT NULL
)
ORDER BY s.full_name ASC;

-- Task 5 (Correlated subquery): For each department, find the student(s) with the highest number of enrolments

SELECT d.dept_name, s.full_name,
       (SELECT COUNT(*) FROM Enrolment e WHERE e.student_id = s.student_id) AS courses
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id
WHERE (SELECT COUNT(*) FROM Enrolment e WHERE e.student_id = s.student_id) = (
    SELECT MAX(dept_counts.course_cnt)
    FROM (
        SELECT s2.dept_id, COUNT(e2.course_id) AS course_cnt
        FROM Student s2
        LEFT JOIN Enrolment e2 ON s2.student_id = e2.student_id
        GROUP BY s2.student_id, s2.dept_id
    ) AS dept_counts
    WHERE dept_counts.dept_id = s.dept_id
)
ORDER BY d.dept_name ASC, s.full_name ASC;


