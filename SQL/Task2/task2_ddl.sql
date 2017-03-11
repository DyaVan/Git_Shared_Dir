CREATE TABLE classes_types
(ct_id NUMBER(11) NOT NULL,
 ct_name NVARCHAR2(255) NOT NULL,
 CONSTRAINT classes_types_PK PRIMARY KEY (ct_id)
 ENABLE
);

CREATE SEQUENCE classes_types_SEQ;

CREATE TRIGGER classes_types_TRG 
BEFORE INSERT ON classes_types
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ct_id IS NULL THEN
      SELECT classes_types_SEQ.NEXTVAL INTO :NEW.ct_id FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

CREATE TABLE students (
  st_id NUMBER(11) NOT NULL,
  st_name NVARCHAR2(255) NOT NULL,
  CONSTRAINT students_PK PRIMARY KEY (st_id)
  ENABLE
);

CREATE SEQUENCE students_SEQ;

CREATE TRIGGER students_TRG 
BEFORE INSERT ON students
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.st_id IS NULL THEN
      SELECT students_SEQ.NEXTVAL INTO :NEW.st_id FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

CREATE TABLE subjects (
  sb_id NUMBER(11) NOT NULL,
  sb_name NVARCHAR2(255) NOT NULL,
  CONSTRAINT subjects_PK PRIMARY KEY (sb_id)
  ENABLE
);

CREATE SEQUENCE subjects_SEQ;

CREATE TRIGGER subjects_TRG 
BEFORE INSERT ON subjects
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.sb_id IS NULL THEN
      SELECT subjects_SEQ.NEXTVAL INTO :NEW.sb_id FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

CREATE TABLE tutors (
  tt_id NUMBER(11) NOT NULL,
  tt_name NVARCHAR2(255) NOT NULL,
  CONSTRAINT tutors_PK PRIMARY KEY (tt_id)
  ENABLE
);

CREATE SEQUENCE tutors_SEQ;

CREATE TRIGGER tutors_TRG 
BEFORE INSERT ON tutors
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.tt_id IS NULL THEN
      SELECT tutors_SEQ.NEXTVAL INTO :NEW.tt_id FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

CREATE TABLE education (
  ed_id NUMBER(11) NOT NULL,
  ed_student NUMBER(11) NOT NULL,
  ed_tutor NUMBER(11) NOT NULL,
  ed_subject NUMBER(11) NOT NULL,
  ed_class_type NUMBER(11) NOT NULL,
  ed_mark NUMBER(11) DEFAULT NULL,
  ed_date DATE NOT NULL,
  CONSTRAINT education_PK PRIMARY KEY (ed_id),
  CONSTRAINT education_ibfk_1 FOREIGN KEY (ed_tutor) 
  REFERENCES tutors (tt_id) ON DELETE CASCADE,
  CONSTRAINT education_ibfk_2 FOREIGN KEY (ed_student) 
  REFERENCES students (st_id) ON DELETE CASCADE,
  CONSTRAINT education_ibfk_3 FOREIGN KEY (ed_subject) 
  REFERENCES subjects (sb_id) ON DELETE CASCADE,
  CONSTRAINT education_ibfk_4 FOREIGN KEY (ed_class_type) 
  REFERENCES classes_types (ct_id) ON DELETE CASCADE
  ENABLE
);

CREATE INDEX ed_student_index ON education (ed_student);
CREATE INDEX ed_tutor_index ON education (ed_tutor);
CREATE INDEX ed_subject_index ON education (ed_subject);
CREATE INDEX ed_class_type_index ON education (ed_class_type);

CREATE SEQUENCE education_SEQ START WITH 217;

CREATE TRIGGER education_TRG 
BEFORE INSERT ON education
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ed_id IS NULL THEN
      SELECT education_SEQ.NEXTVAL INTO :NEW.ed_id FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

INSERT INTO classes_types (ct_name) VALUES ('Лекция');
INSERT INTO classes_types (ct_name) VALUES ('Экзамен');
INSERT INTO classes_types (ct_name) VALUES ('Лабораторная работа');

INSERT INTO students (st_name) VALUES ('Воробьёв В.В.');
INSERT INTO students (st_name) VALUES ('Соколов С.С.');
INSERT INTO students (st_name) VALUES ('Орлов О.О.');
INSERT INTO students (st_name) VALUES ('Беркутов Б.Б.');
INSERT INTO students (st_name) VALUES ('Филинов Ф.Ф.');
INSERT INTO students (st_name) VALUES ('Прогульщиков П.П.');

INSERT INTO subjects (sb_name) VALUES ('Программирование');
INSERT INTO subjects (sb_name) VALUES ('Химия');
INSERT INTO subjects (sb_name) VALUES ('Физика');
INSERT INTO subjects (sb_name) VALUES ('Математика');
INSERT INTO subjects (sb_name) VALUES ('Английский язык');
INSERT INTO subjects (sb_name) VALUES ('История КПСС');

INSERT INTO tutors (tt_name) VALUES ('Профессор Иванов');
INSERT INTO tutors (tt_name) VALUES ('Доцент Петров');
INSERT INTO tutors (tt_name) VALUES ('Ассистент Сидоров');
INSERT INTO tutors (tt_name) VALUES ('Ассистент Неизвестный');

INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (1, 1, 1, 1, 1, 4, TO_DATE('2012-10-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (7, 1, 1, 1, 3, NULL, TO_DATE('2011-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (26, 3, 2, 1, 3, NULL, TO_DATE('2012-09-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (31, 4, 1, 1, 2, 8, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (50, 1, 2, 2, 2, 10, TO_DATE('2012-09-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (53, 1, 2, 2, 3, 6, TO_DATE('2012-09-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (61, 2, 1, 2, 3, 4, TO_DATE('2012-09-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (62, 2, 2, 2, 3, NULL, TO_DATE('2011-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (78, 4, 3, 2, 2, 10, TO_DATE('2012-12-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (91, 1, 1, 3, 1, 4, TO_DATE('2012-10-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (93, 1, 3, 3, 1, 7, TO_DATE('2012-12-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (96, 1, 3, 3, 2, NULL, TO_DATE('2012-09-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (101, 2, 2, 3, 1, 9, TO_DATE('2012-03-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (103, 2, 1, 3, 2, NULL, TO_DATE('2011-09-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (106, 2, 1, 3, 3, NULL, TO_DATE('2010-04-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (108, 2, 3, 3, 3, NULL, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (113, 3, 2, 3, 2, 7, TO_DATE('2012-01-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (121, 4, 1, 3, 2, 4, TO_DATE('2012-09-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (127, 5, 1, 3, 1, 8, TO_DATE('2012-10-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (145, 2, 1, 4, 1, 9, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (146, 2, 2, 4, 1, 4, TO_DATE('2012-09-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (149, 2, 2, 4, 2, 10, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (157, 3, 1, 4, 2, 6, TO_DATE('2012-10-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (186, 1, 3, 5, 2, NULL, TO_DATE('2012-04-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (202, 3, 1, 5, 2, NULL, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (208, 4, 1, 5, 1, NULL, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (212, 4, 2, 5, 2, NULL, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (215, 4, 2, 5, 3, 10, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO education (ed_id, ed_student, ed_tutor, ed_subject, ed_class_type, ed_mark, ed_date) 
VALUES (216, 4, 3, 5, 3, 10, TO_DATE('2012-11-19 15:20:00', 'YYYY-MM-DD HH24:MI:SS'));