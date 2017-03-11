--1. Написать запрос, показывающий список преподавателей с количеством обучаемых ими студентов.

SELECT  tt_id, tt_name, COUNT(st_name) students_count 
FROM  (
		SELECT  DISTINCT tt_id, tt_name, st_name
		  FROM  tutors
	 LEFT JOIN  education
		    ON  ed_tutor = tt_id
	 LEFT JOIN  students
		    ON  st_id = ed_student
	)
GROUP BY  (tt_id, tt_name)
ORDER BY  COUNT(st_name) DESC;

--2. Написать запрос, показывающий список студентов с количеством преподавателей, у которых они обучаются.

SELECT  st_id, st_name, COUNT (tt_name)
FROM  (
		SELECT  DISTINCT  st_id, st_name, tt_name
		FROM  students
		JOIN  education
		ON  ed_student = st_id
		JOIN  tutors
		ON  tt_id = ed_tutor
	)
GROUP BY  (st_id, st_name)
ORDER BY  st_id;

-- 3. Написать запрос, показывающий id и имя преподавателя (преподавателей), проведшего больше всего занятий в сентябре 2012 года.

SELECT tt_id, tt_name, COUNT(ed_id)
FROM tutors
JOIN education
ON tt_id = ed_tutor
WHERE to_char(ed_date, 'YYYYMM') = '201209'
GROUP BY tt_id, tt_name
HAVING COUNT(ed_id) = ( 
	SELECT MAX(COUNT(ed_id))
	FROM tutors
	JOIN education
	ON tt_id = ed_tutor
	WHERE to_char(ed_date, 'YYYYMM') = '201209'
	GROUP BY tt_id, tt_name
);

--4. Написать запрос, показывающий список студентов и их средние баллы. */

SELECT  st_id, st_name, AVG(ed_mark)
FROM  students
LEFT JOIN  education
ON  st_id = ed_student
GROUP BY  st_id, st_name
ORDER BY  st_id;

--5. Написать запрос, показывающий список студентов и названия предметов, 
--по которым они получили самые высокие оценки.

SELECT  st_id, st_name, LISTAGG(convert(sb_name, 'UTF8', 'AL16UTF16'), ',') within group (ORDER BY st_id), maxmark
FROM  (
		SELECT  st_id, st_name, MAX(ed_mark) maxmark
		FROM  students
		LEFT JOIN  education
		ON  st_id = ed_student
		GROUP BY  st_id, st_name
		ORDER BY  st_id
	)
LEFT JOIN  education 
ON  st_id = ed_student AND ed_mark = maxmark
LEFT JOIN  subjects
ON  ed_subject = sb_id
GROUP BY  (st_id, st_name, maxmark);

--6. Написать запрос, показывающий имя преподавателя (преподавателей),
--поставившего самую низкую оценку студенту Соколову С.С.

SELECT  tt_name
FROM  tutors
JOIN  education
ON  tt_id = ed_tutor
JOIN  students
ON  ed_student = st_id AND st_name = 'Соколов С.С.'
WHERE  ed_mark = (
		SELECT  MIN(ed_mark) minmark
		FROM  students
		LEFT JOIN  education
		ON  st_id = ed_student
		GROUP BY  st_id, st_name
		HAVING (st_name = 'Соколов С.С.')
);

--7. Написать запрос, проверяющий, не закралась ли в базу ошибка, состоящая в том,
--что оценка была выставлена по типу занятий, для которого не бывает оценок.
--Оценки допустимы только для экзаменов и лабораторных работ. Запрос должен
--возвращать 1 (TRUE), если ошибка есть, и 0 (FALSE), если ошибки нет.

SELECT DISTINCT 
  CASE WHEN EXISTS  ( 
		SELECT  ct_name, ed_mark
		FROM  classes_types
		JOIN  education
		ON  ct_id = ed_class_type
		WHERE  ed_mark IS NOT NULL 
		AND  ct_name NOT IN ('Экзамен', 'Лабораторная работа'))
      THEN 1
      ELSE 0
    END AS answer
FROM  tutors;

--8. Написать запрос, показывающий 2012-й год по месяцам, причём для каждого месяца
--вывести название предмета (предметов), по которому было проведено больше всего
--занятий.

SELECT shortdate, LISTAGG(convert(sb_name, 'UTF8', 'AL16UTF16'), ',') within group (ORDER BY shortdate), classes_number
FROM (
    SELECT to_char(ed_date, 'YYYYMM') shortdate, sb_name, COUNT(sb_name) classes_number
    FROM education outertab
    JOIN subjects
    ON ed_subject = sb_id
    WHERE to_char(ed_date, 'YYYY') = '2012'
    GROUP BY to_char(ed_date, 'YYYYMM'), sb_name
    HAVING  COUNT(sb_name) = (
        SELECT MAX(COUNT(sb_name))
        FROM education
        JOIN subjects
        ON ed_subject = sb_id
        WHERE to_char(ed_date, 'YYYYMM') = to_char(outertab.ed_date, 'YYYYMM')
        GROUP BY to_char(ed_date, 'YYYYMM'), sb_name
	)
)
GROUP BY shortdate, classes_number
ORDER BY shortdate desc;


--9. Написать запрос, показывающий список студентов, чей средний балл ниже среднего--
--балла по университету.

SELECT st_name, AVG(ed_mark)
FROM students
JOIN education
ON st_id = ed_student
GROUP BY st_name
HAVING AVG(ed_mark) < (
    SELECT AVG(ed_mark)
    FROM education
);


--10. Написать запрос, показывающий список студентов, не изучавших химию и физику.

SELECT st_name
FROM students
WHERE st_id NOT IN (
SELECT DISTINCT st_id
FROM students
JOIN education
ON st_id = ed_student
JOIN subjects
ON ed_subject = sb_id
WHERE sb_name = 'Физика' OR sb_name = 'Химия');

--11. Написать запрос, показывающий список студентов, ни разу не получавших 10-ки.

SELECT st_id, st_name
FROM students
WHERE st_id NOT IN (
SELECT DISTINCT st_id
FROM students
JOIN education
ON ed_student = st_id
WHERE ed_mark = 10);


--12. Написать запрос, показывающий список предметов, успеваемость студентов по
--которым выше средней успеваемости по всем предметам в университете.

SELECT sb_id, sb_name, AVG (ed_mark)
FROM subjects
JOIN education
ON sb_id = ed_subject
GROUP BY (sb_id, sb_name)
HAVING (AVG (ed_mark) > ( 
    SELECT AVG(ed_mark)
    FROM education)
);


--15. Написать запрос, показывающий список преподавателей и количество проведённых
--каждым преподавателем занятий.

SELECT tt_id, tt_name, COUNT (ed_id) "classes"
FROM tutors
LEFT JOIN education
ON tt_id = ed_tutor
GROUP BY (tt_id, tt_name)
ORDER BY tt_id;


--16. Написать запрос, показывающий имя преподавателя (преподавателей), не
--поставившего ни одной оценки.

SELECT distinct tt_id, tt_name
FROM tutors
LEFT JOIN education
ON tt_id = ed_tutor
WHERE ed_id IS NULL;


--17. Написать запрос, показывающий список преподавателей и количества поставленных
--ими оценок в порядке убывания этого количества.

SELECT tt_id, tt_name, COUNT (ed_mark) marks
FROM tutors
LEFT JOIN education
ON tt_id = ed_tutor
GROUP BY (tt_id, tt_name)
ORDER BY marks DESC;


--18. Написать запрос, показывающий список предметов и средних баллов каждого
--студента по каждому предмету в порядке убывания среднего балла.

SELECT sb_name, st_name, To_char( AVG (ed_mark),'999999.9999') "avg"
FROM students
JOIN education
ON st_id = ed_student
JOIN subjects
ON sb_id = ed_subject
GROUP BY sb_name, st_name
ORDER BY sb_name, "avg" DESC;


--19. Написать запрос, показывающий средний балл каждого студента по каждому месяцу
--обучения.



--20. Написать запрос, показывающий список студентов и максимальный балл, когда либо
--полученный данным студентом.

SELECT st_name, MAX(ed_mark)
FROM students
JOIN education
ON st_id = ed_student
GROUP BY st_name
ORDER BY MAX(ed_mark) DESC;


--21. Написать запрос, показывающий студента (студентов) получивших максимальное
--количество баллов ниже 5.

SELECT st_name, COUNT(ed_mark) 
FROM students
JOIN education
ON ed_student = st_id
WHERE ed_mark < 5
GROUP BY st_name
HAVING  COUNT(ed_mark) = (
	SELECT MAX(COUNT(ed_mark)) marks
	FROM students
	JOIN education
	ON st_id = ed_student
	WHERE ed_mark < 5
	GROUP BY st_name
);


--22. Написать запрос, показывающий студента (студентов) посетивших наибольшее
--количество занятий.

SELECT st_id, st_name, COUNT (ed_id)
FROM students
JOIN education
ON st_id = ed_student
GROUP BY st_id, st_name
HAVING COUNT (ed_id) = (
    SELECT MAX(COUNT (ed_id))
    FROM students
    JOIN education
    ON st_id = ed_student
    GROUP BY st_id, st_name
);


--23. Написать запрос, показывающий список преподавателей и количество проведённых
--ими занятий и порядке убывания этого количества.

SELECT tt_id, tt_name, COUNT(ed_id)
FROM tutors
LEFT JOIN education
ON tt_id = ed_tutor
GROUP BY tt_id, tt_name
ORDER BY COUNT(ed_id) DESC;


--24. Написать запрос, показывающий студента (если такой есть), посетившего большее
--количество занятий, чем любой другой студент.

--25. Написать запрос, показывающий информацию о том, какой преподаватель по какому
--предмету поставил какой максимальный балл какому студенту.

SELECT tt_name, sb_name, st_name, MAX(ed_mark)
FROM tutors
JOIN education
ON tt_id = ed_tutor
JOIN students
ON st_id = ed_student
JOIN subjects
ON sb_id = ed_subject
WHERE ed_mark IS NOT NULL
GROUP BY tt_name, sb_name, st_name
ORDER BY tt_name DESC;

--26. Написать запрос, показывающий студента (студентов), набравшего минимальную
--сумму баллов.
SELECT st_name, SUM(ed_mark)
FROM students
JOIN education
ON st_id = ed_student
GROUP BY st_name
HAVING SUM(ed_mark) = (
	SELECT MIN(SUM(ed_mark))
	FROM students
	JOIN education
	ON st_id = ed_student
	GROUP BY st_name
);

--27. Написать запрос, показывающий список предметов, по которым не было ни оценок,
--ни занятий (занятиями считается любой вид учебной деятельности).

SELECT sb_name
FROM subjects
LEFT JOIN education
ON sb_id = ed_subject
WHERE ed_id IS NULL;


--28. Написать запрос, показывающий список лабораторных работ по химии, по которым
--были случаи «студент был на занятии, но не получил оценки».

SELECT ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date
FROM education
JOIN classes_types
ON ct_id = ed_class_type
JOIN subjects
ON sb_id = ed_subject
WHERE sb_name = 'Химия' AND ct_name = 'Лабораторная работа' 
AND ed_mark IS NULL;


--29. Написать запрос, показывающий предмет (предметы), по которому в 2012 году было
--проведено больше всего экзаменов.

SELECT sb_name, COUNT(ed_id)
FROM subjects
JOIN education
ON sb_id = ed_subject
JOIN classes_types
ON ct_id = ed_class_type
WHERE   ct_name = 'Экзамен' AND
	    ed_date BETWEEN to_date('01-JAN-2012','DD-MON-YYYY') 
	    AND to_date('31-DEC-2012','DD-MON-YYYY')
GROUP BY sb_name
HAVING COUNT(ed_id) = (
		SELECT MAX(COUNT (ed_id))
		FROM subjects
		JOIN education
		ON sb_id = ed_subject
		JOIN classes_types
		ON ct_id = ed_class_type
		WHERE ct_name = 'Экзамен' AND
		  ed_date BETWEEN to_date('01-JAN-2012','DD-MON-YYYY') 
		  AND to_date('31-DEC-2012','DD-MON-YYYY')
		GROUP BY sb_name
);












