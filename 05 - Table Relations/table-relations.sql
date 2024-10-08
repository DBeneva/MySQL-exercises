CREATE SCHEMA `table_relations`;
USE `table_relations`;

CREATE TABLE `people`(
	`person_id` INT NOT NULL,
    `first_name` VARCHAR(50),
    `salary` DECIMAL(10, 2),
    `passport_id` INT
);

CREATE TABLE `passports`(
	`passport_id` INT NOT NULL,
    `passport_number` VARCHAR(8) UNIQUE
);

ALTER TABLE `people`
MODIFY COLUMN `person_id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY;

ALTER TABLE `people`
MODIFY COLUMN `passport_id` INT UNIQUE;

ALTER TABLE `passports`
MODIFY COLUMN `passport_id` INT NOT NULL PRIMARY KEY;

ALTER TABLE `people`
ADD CONSTRAINT `fk_people_passports`
	FOREIGN KEY (`passport_id`)
    REFERENCES `passports`(`passport_id`);
    
INSERT INTO `passports`
VALUES
	(101, 'N34FG21B'),
    (102, 'K65LO4R7'),
    (103, 'ZE657QP2');
    
INSERT INTO `people` (`first_name`, `salary`, `passport_id`)
VALUES 
	('Roberto', 43300.00, 102),
    ('Tom', 56100.00, 103),
    ('Yana', 60200.00, 101);
    
CREATE TABLE `manufacturers`(
	`manufacturer_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50),
    `established_on` DATE
);

CREATE TABLE `models`(
	`model_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50),
	`manufacturer_id` INT
);

ALTER TABLE `models`
ADD CONSTRAINT `fk_models_manufacturers`
	FOREIGN KEY (`manufacturer_id`)
	REFERENCES `manufacturers`(`manufacturer_id`);
    
ALTER TABLE `models`
AUTO_INCREMENT = 101;

INSERT INTO `manufacturers`(`name`, `established_on`)
VALUES
	('BMW', '1916-03-01'),
    ('Tesla', '2003-01-01'),
    ('Lada', '1966-05-01');

INSERT INTO `models`(`name`, `manufacturer_id`)
VALUES
	('X1', 1),
    ('i6', 1),
    ('Model S', 2),
    ('Model X', 2),
    ('Model 3', 2),
    ('Nova', 3);
    
CREATE TABLE `exams`(
	`exam_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50)
);

CREATE TABLE `students`(
	`student_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50)
);

CREATE TABLE `students_exams`(
	`student_id` INT,
    `exam_id` INT,
    CONSTRAINT `pk_students_exams`
		PRIMARY KEY (`student_id`, `exam_id`),
	CONSTRAINT `fk_students_exams_students`
		FOREIGN KEY (`student_id`)
        REFERENCES `students`(`student_id`),
	CONSTRAINT `fk_students_exams_exams`
		FOREIGN KEY (`exam_id`)
        REFERENCES `exams`(`exam_id`)
);

ALTER TABLE `exams`
AUTO_INCREMENT = 101;

INSERT INTO `exams`(`name`)
VALUES
	('Spring MVC'),
    ('Neo4j'),
    ('Oracle 11g');
    
INSERT INTO `students`(`name`)
VALUES
	('Mila'),
    ('Toni'),
    ('Ron');
    
INSERT INTO `students_exams`
VALUES
	(1, 101),
    (1, 102),
    (2, 101),
    (3, 103),
    (2, 102),
    (2, 103);

DROP TABLE `teachers`;
CREATE TABLE `teachers`(
	`teacher_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50),
    `manager_id` INT DEFAULT NULL
);

ALTER TABLE `teachers`
AUTO_INCREMENT = 101;
    
INSERT INTO `teachers`(`name`, `manager_id`)
VALUES
	('John', NULL),
    ('Maya', 106),
    ('Silvia', 106),
    ('Ted', 105),
    ('Mark', 101),
    ('Greta', 101);
    
ALTER TABLE `teachers`
ADD CONSTRAINT `fk_teachers_teacher_id_teachers_manager_id`
	FOREIGN KEY (`manager_id`)
	REFERENCES `teachers`(`teacher_id`);

peaksCREATE SCHEMA `online_store`;
USE `online_store`;

CREATE TABLE `cities`(
	`city_id` INT(11) PRIMARY KEY,
    `name` VARCHAR(50)
);

CREATE TABLE `customers`(
	`customer_id` INT(11) PRIMARY KEY,
    `name` VARCHAR(50),
    `birthday` DATE,
    `city_id` INT(11)
);

ALTER TABLE `customers`
ADD CONSTRAINT `fk_customers_cities`
	FOREIGN KEY (`city_id`)
    REFERENCES `cities`(`city_id`);

CREATE TABLE `orders`(
	`order_id` INT(11) PRIMARY KEY,
    `customer_id` INT(11)
);

ALTER TABLE `orders`
ADD CONSTRAINT `fk_orders_customers`
	FOREIGN KEY (`customer_id`)
    REFERENCES `customers`(`customer_id`);
    
CREATE TABLE `item_types`(
	`item_type_id` INT(11) PRIMARY KEY,
    `name` VARCHAR(50)
);

CREATE TABLE `items`(
	`item_id` INT(11) PRIMARY KEY,
    `name` VARCHAR(50),
    `item_type_id` INT(11)
);

ALTER TABLE `items`
ADD CONSTRAINT `fk_items_item_types`
	FOREIGN KEY (`item_type_id`)
    REFERENCES `item_types`(`item_type_id`);

CREATE TABLE `order_items`(
	`order_id` INT(11),
    `item_id` INT(11)
);

ALTER TABLE `order_items`
ADD PRIMARY KEY (`order_id`, `item_id`),
ADD CONSTRAINT `pk_order_items_orders`
	FOREIGN KEY (`order_id`)
    REFERENCES `orders`(`order_id`),
ADD CONSTRAINT `pk_order_items_items`
	FOREIGN KEY (`item_id`)
    REFERENCES `items`(`item_id`);
    
SELECT `mountain_range`, `peak_name`, `elevation` AS `peak_elevation`
FROM `peaks` AS `p`
JOIN `mountains` AS `m`
	ON `m`.`id` = `p`.`mountain_id`
WHERE `mountain_range` = 'Rila'
ORDER BY `peak_elevation` DESC;

CREATE SCHEMA `university`;
USE `university`;

CREATE TABLE `majors`(
	`major_id` INT(11) PRIMARY KEY,
	`name` VARCHAR(50)
);

CREATE TABLE `students`(
	`student_id` INT(11) PRIMARY KEY,
    `student_number` VARCHAR(12),
	`student_name` VARCHAR(50),
    `major_id` INT(11)
);

ALTER TABLE `students`
ADD CONSTRAINT `fk_students_majors`
	FOREIGN KEY (`major_id`)
	REFERENCES `majors`(`major_id`);
    
CREATE TABLE `payments`(
	`payment_id` INT(11) PRIMARY KEY,
    `payment_date` DATE,
	`payment_amount` DECIMAL(8, 2),
    `student_id` INT(11)
);

ALTER TABLE `payments`
ADD CONSTRAINT `fk_payments_students`
	FOREIGN KEY (`student_id`)
	REFERENCES `students`(`student_id`);
    
CREATE TABLE `subjects`(
	`subject_id` INT(11) PRIMARY KEY,
	`subject_name` VARCHAR(50)
);

CREATE TABLE `agenda`(
	`student_id` INT(11),
	`subject_id` INT(11)
);

ALTER TABLE `agenda`
ADD PRIMARY KEY (`student_id`, `subject_id`),
ADD CONSTRAINT `fk_agenda_students`
	FOREIGN KEY (`student_id`)
    REFERENCES `students`(`student_id`),
ADD CONSTRAINT `fk_agenda_subjects`
	FOREIGN KEY (`subject_id`)
    REFERENCES `subjects`(`subject_id`);

    
