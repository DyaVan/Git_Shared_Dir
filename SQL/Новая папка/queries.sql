--1+. Написать запрос, показывающий список преподавателей с количеством обучаемых ими студентов.
SELECT tutors.tt_id, tutors.tt_name, COUNT(DISTINCT ed_student) as students_count
FROM education
RIGHT JOIN tutors ON tutors.tt_id = education.ed_tutor
GROUP BY tutors.tt_id, tutors.tt_name
ORDER BY tutors.tt_id;



--2+. Написать запрос, показывающий список студентов с количеством преподавателей, у которых они обучаются.
SELECT students.st_id, students.st_name, COUNT(DISTINCT ed_tutor) as tutors_count
FROM education
JOIN students ON students.st_id = education.ed_student
GROUP BY students.st_id, students.st_name
ORDER BY students.st_id;



--3+. Написать запрос, показывающий id и имя преподавателя (преподавателей) проведшего больше всего занятий в сентябре 2012 года.
SELECT tutors.tt_id, tutors.tt_name, COUNT(ed_class_type) as classes_count
FROM education
JOIN tutors ON ed_tutor = tutors.tt_id
WHERE 2012 = EXTRACT(YEAR FROM ed_date)
AND 9 = EXTRACT(MONTH FROM ed_date)
GROUP BY tutors.tt_id, tutors.tt_name
HAVING COUNT(ed_class_type) = (
            SELECT MAX(count) 
            FROM (SELECT COUNT(ed_class_type) as count FROM education
            JOIN tutors ON ed_tutor = tutors.tt_id
            WHERE 2012 = EXTRACT(YEAR FROM ed_date)
            AND 9 = EXTRACT(MONTH FROM ed_date)
            GROUP BY tutors.tt_id));


--4+. Написать запрос, показывающий список студентов и их средние баллы.
SELECT students.st_id, students.st_name, AVG (ed_mark) as mark
FROM education
RIGHT JOIN students ON students.st_id = education.ed_student
GROUP BY students.st_id, students.st_name
ORDER BY students.st_id;


--5+-. Написать запрос, показывающий список студентов и названия предметов, по которым они получили самые высокие оценки.
SELECT students.st_id, students.st_name, LISTAGG(sb_name, ',') WITHIN GROUP (ORDER BY subjects.sb_name) as subjects, MAX(ed_mark)
FROM education 
LEFT JOIN students ON ed_student = students.st_id
RIGHT JOIN subjects ON ed_subject = subjects.sb_id
GROUP BY students.st_id, students.st_name
ORDER BY students.st_id;



--6+. Написать запрос, показывающий имя преподавателя (преподавателей), поставившего самую низкую оценку студенту Соколову С.С.
SELECT DISTINCT tutors.tt_name
FROM education
JOIN tutors ON education.ed_tutor = tutors.tt_id
WHERE ed_student = (SELECT ed_student FROM students WHERE st_name = 'Соколов С.С.')
AND ed_mark = (SELECT MIN(ed_mark) FROM education);



--7+.Написать запрос, проверяющий, не закралась ли в базу ошибка, состоящая в том,
что оценка была выставлена по типу занятий, для которого не бывает оценок.
Оценки допустимы только для экзаменов и лабораторных работ. Запрос должен
возвращать 1 (TRUE), если ошибка есть, и 0 (FALSE), если ошибки нет.

SELECT 
CASE WHEN EXISTS(SELECT ed_id FROM education
JOIN classes_types ON classes_types.ct_id = education.ed_class_type
WHERE classes_types.ct_name = 'Лекция' AND ed_mark IS NOT NULL)
THEN 1
ELSE 0
END as answer
FROM dual;


--8-.Написать запрос, показывающий 2012-й год по месяцам, причём для каждого месяца
вывести название предмета (предметов), по которому было проведено больше всего
занятий.

--9+. Написать запрос, показывающий список студентов, чей средний балл ниже среднего балла по университету.
SELECT students.st_id, students.st_name, AVG (ed_mark) as mark
FROM education
JOIN students ON students.st_id = education.ed_student
GROUP BY students.st_id, students.st_name
HAVING AVG(ed_mark) < (SELECT AVG(ed_mark) FROM education)
ORDER BY students.st_id;

--10+. Написать запрос, показывающий список студентов, не изучавших химию и физику.
SELECT distinct students.st_id, students.st_name
FROM education
RIGHT JOIN students ON students.st_id = education.ed_student
LEFT JOIN subjects ON subjects.sb_id = education.ed_subject AND (subjects.sb_name = 'Химия' OR subjects.sb_name = 'Физика')
WHERE education.ED_SUBJECT IS NULL;



--11+ Написать запрос, показывающий список студентов, ни разу не получавших 10-ки.. 
SELECT DISTINCT st.st_id, st.st_name
FROM students st
WHERE (SELECT COUNT(ed_mark) FROM education WHERE ed_mark = 10 AND st.st_id = education.ed_student)= 0;

--12+.
SELECT subjects.sb_id, subjects.sb_name, AVG(ed_mark)
FROM education
RIGHT JOIN subjects ON ed_subject = subjects.sb_id
GROUP BY subjects.sb_id, subjects.sb_name
HAVING AVG(ed_mark) > (SELECT AVG(ed_mark) FROM education);

13+
SELECT subjects.sb_id, subjects.sb_name, TO_CHAR(classes_per_month, '0.0000') AS classes_per_month
FROM
  (SELECT ed_subject, COUNT(ed_subject) / MONTHS_BETWEEN(MAX(ed_date), MIN(ed_date)) AS classes_per_month
   FROM education
   GROUP BY ed_subject
  ) t1
  JOIN subjects ON t1.ed_subject = subjects.sb_id
ORDER BY sb_id;

14

--15+.Написать запрос, показывающий список преподавателей и количество проведённых каждым преподавателем занятий.

SELECT tutors.tt_id, tutors.tt_name, COUNT (ed_class_type) as classes
FROM education
RIGHT JOIN tutors ON ed_tutor = tutors.tt_id
GROUP BY tutors.tt_id, tutors.tt_name
ORDER BY tt_id;

--16+.Написать запрос, показывающий имя преподавателя (преподавателей), не поставившего ни одной оценки.
SELECT tutors.tt_id, tutors.tt_name
FROM education
RIGHT JOIN tutors ON ed_tutor = tutors.tt_id
GROUP BY tutors.tt_id, tutors.tt_name
HAVING COUNT(ed_mark) = 0;

--17+.Написать запрос, показывающий список преподавателей и количества поставленных ими оценок в порядке убывания этого количества.
SELECT tutors.tt_id, tutors.tt_name, COUNT(ed_mark) as marks
FROM education
RIGHT JOIN tutors ON ed_tutor = tutors.tt_id
GROUP BY tutors.tt_id, tutors.tt_name
ORDER BY marks DESC;

18+
SELECT subjects.sb_name, students.st_name, ROUND(AVG(ed_mark), 4) as "avg"
FROM education
JOIN students ON ed_student = students.st_id
JOIN subjects ON ed_subject = subjects.sb_id
GROUP BY subjects.sb_name, students.st_name
ORDER BY subjects.sb_name, "avg" DESC NULLS LAST;

19+
SELECT students.st_name, TO_CHAR(ed_date, 'YYYYMM'), ROUND(AVG(ed_mark),4)
FROM education
JOIN students ON students.st_id = education.ed_student
GROUP BY students.st_name, TO_CHAR(ed_date, 'YYYYMM')
ORDER BY students.st_name, AVG(ed_mark) DESC NULLS LAST;

20+
SELECT students.st_name, MAX(ed_mark)as max
FROM education
JOIN students ON students.st_id = education.ed_student
GROUP BY students.st_name
ORDER BY max DESC, students.st_name;



21+
SELECT students.st_name, COUNT(ed_mark) as bad_marks
FROM education
JOIN students ON students.st_id = education.ed_student
WHERE ed_mark < 5
GROUP BY students.st_name
HAVING COUNT(ed_mark) = (SELECT MAX(count) FROM 
(SELECT COUNT(ed_mark) as count FROM education WHERE ed_mark < 5 GROUP BY ed_student));



22+
SELECT students.st_name, COUNT(ed_class_type) as bad_marks
FROM education
JOIN students ON students.st_id = education.ed_student
GROUP BY students.st_name
HAVING COUNT(ed_class_type) = (
            SELECT MAX(count) 
            FROM (SELECT COUNT(ed_class_type) as count FROM education GROUP BY ed_student));


23+
SELECT tutors.tt_id, tutors.tt_name, COUNT (ed_class_type) as classes
FROM education
RIGHT JOIN tutors ON ed_tutor = tutors.tt_id
GROUP BY tutors.tt_id, tutors.tt_name
ORDER BY classes DESC;

24 (see 21?)

25+
SELECT tutors.tt_name, subjects.sb_name, students.st_name, MAX(ed_mark)
FROM education
JOIN tutors ON ed_tutor = tutors.tt_id
JOIN subjects ON ed_subject = subjects.sb_id
JOIN students ON ed_student = students.st_id
WHERE ed_mark IS NOT NULL
GROUP BY tutors.tt_name, subjects.sb_name,students.st_name
ORDER BY tutors.tt_name DESC, subjects.sb_name DESC, students.st_name DESC;

26+
SELECT students.st_name, SUM(ed_mark)
FROM education
JOIN students ON students.st_id = education.ed_student
GROUP BY students.st_name
HAVING SUM(ed_mark) = (
            SELECT MIN(sum) 
            FROM (SELECT SUM(ed_mark) as sum FROM education GROUP BY ed_student));


27+
SELECT subjects.sb_name, COUNT(ed_subject)
FROM education
RIGHT JOIN subjects ON ed_subject = subjects.sb_id
WHERE ed_mark IS NULL
AND ed_class_type IS NULL
GROUP BY subjects.sb_name;


28+
SELECT ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, TO_CHAR(ed_date, 'YYYY-MM-DD hh24:mi:ss')
FROM education
JOIN subjects ON ed_subject = subjects.sb_id
AND subjects.sb_name = 'Химия'
JOIN classes_types ON ed_class_type = classes_types.ct_id
AND classes_types.ct_name = 'Лабораторная работа'
WHERE ed_mark IS NULL;

29+
SELECT subjects.sb_name, COUNT(ed_class_type)
FROM education
JOIN subjects ON ed_subject = subjects.sb_id
JOIN classes_types ON ed_class_type = classes_types.ct_id
AND classes_types.ct_name = 'Экзамен'
WHERE 2012 = EXTRACT(YEAR FROM ed_date)
GROUP BY subjects.sb_name
HAVING COUNT(ed_class_type) = (
            SELECT MAX(count) 
            FROM (SELECT COUNT(ed_class_type) as count FROM education
            JOIN subjects ON ed_subject = subjects.sb_id
            JOIN classes_types ON ed_class_type = classes_types.ct_id
            AND classes_types.ct_name = 'Экзамен'
            WHERE 2012 = EXTRACT(YEAR FROM ed_date)
            GROUP BY ed_subject));

30+
SELECT subjects.sb_id, subjects.sb_name, ROUND(COUNT(ed_class_type) / 12, 4)as exams_per_month
FROM education
JOIN subjects ON ed_subject = subjects.sb_id
AND subjects.sb_name = 'Программирование'
JOIN classes_types ON ed_class_type = classes_types.ct_id
AND classes_types.ct_name = 'Экзамен'
GROUP BY subjects.sb_id, subjects.sb_name;


24, 14, 8, 5







