CREATE SCHEMA `minions`;

USE `minions`;

CREATE TABLE `minions`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50),
    `age` INT
);

CREATE TABLE `towns`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50)
);

ALTER TABLE `minions`
ADD COLUMN `town_id` INT;

ALTER TABLE `minions`
ADD CONSTRAINT `fk_town_id`
FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`);

INSERT INTO `towns` VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO `minions` VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

TRUNCATE `minions`;

DROP TABLE `towns`, `minions`;

CREATE TABLE `people`(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `picture` BLOB,
    `height` REAL(10, 2),
    `weight` REAL(10, 2),
    `gender` ENUM('m', 'f') NOT NULL,
    `birthdate` DATE NOT NULL,
    `biography` TEXT
);

INSERT INTO `people` VALUES
(1, 'John', NULL, 1.8, 85.6, 'm', '1987-02-01', NULL),
(2, 'Mary', NULL, 1.2, 82, 'f', '1987-02-01', NULL),
(3, 'Ann', NULL, 1.9, 95.6, 'f', '1987-02-01', NULL),
(4, 'Ben', NULL, 1.7, 81.6, 'm', '1987-02-01', NULL),
(5, 'Dan', NULL, 1.3, 5.6, 'm', '1987-02-01', NULL);

CREATE TABLE `users`(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT UNIQUE,
    `username` VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(26) NOT NULL,
    `profile_picture` BLOB,
    `last_login_time` TIMESTAMP,
    `is_deleted` BOOLEAN
);

INSERT INTO `users` VALUES
(1, 'john', '123', NULL, NULL, NULL),
(2, 'john2', '123', NULL, NULL, NULL),
(3, 'john3', '123', NULL, NULL, NULL),
(4, 'john4', '123', NULL, NULL, NULL),
(5, 'john5', '123', NULL, NULL, NULL);

ALTER TABLE `users`
DROP PRIMARY KEY,
ADD PRIMARY KEY `pk_users` (`id`, `username`);

ALTER TABLE `users`
MODIFY COLUMN `last_login_time` DATETIME DEFAULT NOW();

ALTER TABLE `users`
DROP PRIMARY KEY,
ADD PRIMARY KEY `pk_users` (`id`);

ALTER TABLE `users`
MODIFY COLUMN `username` VARCHAR(30) UNIQUE;

CREATE SCHEMA `movies`;

USE `movies`;

CREATE TABLE `directors`(
	`id` INT NOT NULL PRIMARY KEY,
    `director_name` VARCHAR(50) NOT NULL,
    `notes` VARCHAR(200)
);

CREATE TABLE `genres`(
	`id` INT NOT NULL PRIMARY KEY,
    `genre_name` VARCHAR(50) NOT NULL,
    `notes` VARCHAR(200)
);

CREATE TABLE `categories`(
	`id` INT NOT NULL PRIMARY KEY,
    `category_name` VARCHAR(50) NOT NULL,
    `notes` VARCHAR(200)
);

CREATE TABLE `movies`(
	`id` INT NOT NULL PRIMARY KEY,
    `title` VARCHAR(100) NOT NULL,
    `director_id` INT NOT NULL,
    `copyright_year` INT,
    `length` INT,
    `genre_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    `rating` INT,
    `notes` VARCHAR(200)
);

ALTER TABLE `movies`
ADD CONSTRAINT `fk_movies`
FOREIGN KEY (`director_id`) REFERENCES `directors`(`id`);

ALTER TABLE `movies`
ADD CONSTRAINT `fk_movies_genre`
FOREIGN KEY (`genre_id`) REFERENCES `genres`(`id`);

ALTER TABLE `movies`
ADD CONSTRAINT `fk_movies_category`
FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`);

INSERT INTO `directors` VALUES
(1, 'john', NULL),
(2, 'john2', NULL),
(3, 'john3', NULL),
(4, 'john4', NULL),
(5, 'john5', NULL);

INSERT INTO `genres` VALUES
(1, 'john', NULL),
(2, 'john2', NULL),
(3, 'john3', NULL),
(4, 'john4', NULL),
(5, 'john5', NULL);

INSERT INTO `categories` VALUES
(1, 'aaa', NULL),
(2, 'john2', NULL),
(3, 'john3', NULL),
(4, 'john4', NULL),
(5, 'john5', NULL);

INSERT INTO `movies` VALUES
(1, 'john', 2, NULL, NULL, 2, 1, NULL, NULL),
(2, 'john2', 2, NULL, NULL, 2, 1, NULL, NULL),
(3, 'john3', 3, NULL, NULL, 2, 1, NULL, NULL),
(4, 'john4', 5, NULL, NULL, 2, 1, NULL, NULL),
(5, 'john5', 1, NULL, NULL, 2, 1, NULL, NULL);

CREATE SCHEMA `car_rental`;

USE `car_rental`;

CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `daily_rate` DOUBLE(5, 2),
    `weekly_rate` DOUBLE(5, 2),
    `monthly_rate` DOUBLE(5, 2),
    `weekend_rate` DOUBLE(5, 2)
);

CREATE TABLE `cars`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `plate_number` INT NOT NULL,
    `make` VARCHAR(50),
    `model` VARCHAR(50),
    `car_year` INT,
    `category_id` INT NOT NULL,
    `doors` INT,
    `picture` BLOB,
    `car_condition` VARCHAR(50),
    `available` BOOLEAN
);

CREATE TABLE `employees`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `first_name` VARCHAR(50),
    `last_name` VARCHAR(50),
	`title` VARCHAR(50),
    `notes` VARCHAR(250)
);

CREATE TABLE `customers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `driver_license_number` INT,
    `full_name` VARCHAR(50),
	`address` VARCHAR(50),
    `city` VARCHAR(50),
    `zip_code` VARCHAR(50),
    `notes` VARCHAR(250)
);

CREATE TABLE `rental_orders`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `employee_id` INT NOT NULL,
    `customer_id` INT NOT NULL,
	`car_id` INT NOT NULL,
    `car_condition` VARCHAR(50),
    `tank_level` INT,
    `kilometrage_start` INT,
    `kilometrage_end` INT,
    `total_kilometrage` INT,
    `start_date` DATETIME,
    `end_date` DATETIME,
    `total_days` INT,
    `rate_applied` DOUBLE(5, 2),
    `tax_rate` DOUBLE(5, 2),
    `order_status` VARCHAR(50),
    `notes` VARCHAR(250)
);

INSERT INTO `categories` VALUES
(1, 'car', NULL, NULL, NULL, NULL),
(2, 'SUV', NULL, NULL, NULL, NULL),
(3, 'car', NULL, NULL, NULL, NULL);

INSERT INTO `cars` VALUES
(1, 123, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(2, 123, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL),
(3, 123, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL);

INSERT INTO `employees` VALUES
(1, NULL, NULL, NULL, NULL),
(2, NULL, NULL, NULL, NULL),
(3, NULL, NULL, NULL, NULL);

INSERT INTO `customers` VALUES
(1, NULL, NULL, NULL, NULL, NULL, NULL),
(2, NULL, NULL, NULL, NULL, NULL, NULL),
(3, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO `rental_orders` VALUES
(1, 2, 1, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 2, 1, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 2, 1, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

CREATE SCHEMA `soft_uni`;

USE `soft_uni`;

CREATE TABLE `towns`(
	`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `addresses`(
	`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `address_text` VARCHAR(100),
    `town_id` INT NOT NULL
);

CREATE TABLE `departments`(
	`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `employees`(
	`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `middle_name` VARCHAR(50),
    `last_name` VARCHAR(50) NOT NULL,
    `job_title` VARCHAR(50),
    `department_id` INT NOT NULL,
    `hire_date` DATETIME,
    `salary` DOUBLE(10, 2),
    `address_id` INT
);

INSERT INTO `towns` VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna'),
(4, 'Burgas');

INSERT INTO `departments` VALUES
(1, 'Engineering'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Software Development'),
(5, 'Quality Assurance');

ALTER TABLE `addresses`
ADD CONSTRAINT `fk_employees`
FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`);

ALTER TABLE `employees`
ADD CONSTRAINT `fk_employees`
FOREIGN KEY (`department_id`) REFERENCES `towns`(`id`);

INSERT INTO `employees` VALUES
(1, 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00, NULL),
(2, 'Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00, NULL),
(3, 'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25, NULL),
(4, 'Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00, NULL),
(5, 'Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88, NULL);

SELECT `name`
FROM `towns`
ORDER BY `name`;

SELECT `name`
FROM `departments`
ORDER BY `name`;

SELECT `first_name`, `last_name`, `job_title`, `salary`
FROM `employees`
ORDER BY `salary` DESC;

UPDATE `employees`
SET `salary` = `salary` * 1.1;

SELECT `salary`
FROM `employees`;
