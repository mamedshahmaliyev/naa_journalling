DROP DATABASE IF EXISTS naa;

CREATE DATABASE naa DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

USE naa;

DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `short_name` varchar(10) NOT NULL,
  `hours` int NOT NULL,
  `credit` int,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subjects_UN_short_name` (`short_name`)
);

DROP TABLE IF EXISTS `teachers`;
CREATE TABLE `teachers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250),
  `surname` varchar(250),
  `patronymic` varchar(250),
  `gender` enum('male', 'female'),
  PRIMARY KEY (`id`),
  UNIQUE KEY `teachers_name_UN` (`name`,`surname`,`patronymic`) USING BTREE
);

DROP TABLE IF EXISTS `students`;
CREATE TABLE `students` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250),
  `surname` varchar(250),
  `patronymic` varchar(250),
  `gender` enum('male', 'female'),
  PRIMARY KEY (`id`),
  UNIQUE KEY `students_name_UN` (`name`,`surname`,`patronymic`) USING BTREE
);

DROP TABLE IF EXISTS `student_groups`;
CREATE TABLE `student_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50),
  `starosta_id` bigint unsigned,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_groups_UN1` (`name`),
  KEY `student_groups_FK1` (`starosta_id`),
  CONSTRAINT `student_groups_FK1` FOREIGN KEY (`starosta_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `student_groups__students`;
CREATE TABLE `student_groups__students` (
  `student_group_id` bigint unsigned NOT NULL,
  `student_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`student_group_id`,`student_id`),
  KEY `student_groups__students_FK2` (`student_id`),
  CONSTRAINT `student_groups__students_FK1` FOREIGN KEY (`student_group_id`) REFERENCES `student_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student_groups__students_FK2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `journals`;
CREATE TABLE `journals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kafedra` varchar(200),
  `student_group_id` bigint unsigned NOT NULL,
  `date_start` date NOT NULL,
  `date_end` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `journals___student_groups_FK` (`student_group_id`),
  CONSTRAINT `journals___student_groups_FK` FOREIGN KEY (`student_group_id`) REFERENCES `student_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `journal_records`;
CREATE TABLE `journal_records` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `journal_id` bigint unsigned NOT NULL,
  `teacher_id` bigint unsigned NOT NULL,
  `record_date` date NOT NULL,
  `subject_id` bigint unsigned NOT NULL,
  `record_type` enum('lecture','seminar','kollokvium','lab') NOT NULL,
  `hour` tinyint NOT NULL,
  `student_id` bigint unsigned NOT NULL,
  `is_present` tinyint(1) NOT NULL,
  `mark` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `journal_records_UN1` (`journal_id`,`record_date`,`subject_id`,`record_type`,`hour`,`student_id`),
  KEY `journal_records_FK1` (`subject_id`),
  KEY `journal_records_FK2` (`student_id`),
  KEY `journal_records_FK3` (`teacher_id`),
  CONSTRAINT `journal_records___journals_FK` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `journal_records_FK1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `journal_records_FK2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `journal_records_FK3` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO `subjects`(`id`, `name`, `short_name`, `hours`, `credit`) VALUES 
(1,'Operating Systems','OS',75,4),
(2,'Object Oriented Programming','OOP',75,4);


INSERT INTO `teachers`(`id`, `name`, `surname`, `patronymic`, `gender`) VALUES 
(1,'Məmməd','Şahmalıyev','Oqtay', 'male');

INSERT INTO `students`(`id`, `name`, `surname`, `patronymic`, `gender`) VALUES 
(1,'Turan','Şirinov','İlyas', 'male'),
(2,'Əsəd','Əsədzadə','Aydın', 'male'),
(3,'Əsmər','Məmmədova','Elçin', 'female'),
(4,'Qumru','Əliyeva','Arif', 'female'),
(5,'Əli','Abdullayev','Könül', 'male'),
(6,'Rəhiməxanım','Ələkbərova','Elşən', 'female'),
(7,'Namiq','Planov','Saleh', 'male'),
(8,'Səbinə','Əsgərova','Seyxunovna', 'female'),
(9,'Danil','Kuznetsov','Aleksey', 'male'),
(10,'Zaur','Qurbanov','İbrahimoviç', 'male'),
(11,'Eltun','Xəlilov','Nəsib', 'male');


INSERT INTO `student_groups`(`id`, `name`, `starosta_id`) VALUES 
(1,'2450i', 4), 
(2, '1459i', NULL),
(3, '2450a', NULL);


INSERT INTO `student_groups__students` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11);

INSERT INTO `journals`(`id`, `kafedra`, `student_group_id`, `date_start`, `date_end`) VALUES 
(1, 'Kompüter sistemləri və proqramlaşdırma', 1, '2022-09-15','2022-12-31');


INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 3, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-21', 1, 'lecture', 4, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 8, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 1, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lab', 2, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-09-28', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 1, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 2, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 3, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 4, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 5, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 6, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 7, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 8, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 9, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 10, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 1, 11, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-05', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lab', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-12', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 1, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 2, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 3, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 4, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 5, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 6, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 7, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 8, 1, 6);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 9, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 10, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 1, 11, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-19', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 1, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 3, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 1, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lab', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 1, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 1, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 1, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 3, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 5, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 1, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 3, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 5, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-10-26', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 1, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 2, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 3, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 4, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 5, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 6, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 7, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 8, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 9, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 10, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'seminar', 2, 11, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-02', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 1, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 2, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 3, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 4, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 5, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 6, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 7, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 8, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 9, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 10, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 1, 11, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-05', 1, 'kollokvium', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 3, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-16', 1, 'lecture', 4, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 1, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 1, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lab', 2, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 1, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'lecture', 2, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 1, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-23', 1, 'seminar', 2, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 1, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 2, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 3, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 4, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 5, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 6, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 7, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 8, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 9, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 10, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 1, 11, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-25', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-11-30', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 1, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 2, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 3, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 4, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 5, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 6, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 7, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 8, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 9, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 10, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 1, 11, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-02', 1, 'kollokvium', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 2, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 5, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 1, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 2, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 2, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 3, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-07', 1, 'lab', 4, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-14', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 9, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 10, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 1, 11, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lab', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 7, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 7, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'lecture', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 7, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 7, 0, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-21', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 1, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 2, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 3, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 4, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 5, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 6, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 7, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 8, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 9, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 10, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-23', 1, 'seminar', 1, 11, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'lab', 1, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'seminar', 2, 11, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 1, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 2, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 3, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 4, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 5, 1, 10);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 6, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 7, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 8, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 9, 1, 7);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 10, 1, 8);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 1, 11, 1, 9);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 1, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 2, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 3, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 4, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 5, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 6, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 7, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 8, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 9, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 10, 1, NULL);
INSERT INTO journal_records (journal_id, teacher_id, record_date, subject_id, record_type, `hour`, student_id, is_present, mark) VALUES(1, 1, '2022-12-28', 1, 'kollokvium', 2, 11, 1, NULL);