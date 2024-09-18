USE `soft_uni`;

SELECT `first_name`, `last_name`
FROM `employees`
WHERE `first_name` LIKE 'sa%'
ORDER BY `employee_id`;

SELECT `first_name`, `last_name`
FROM `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`;

SELECT *
FROM `employees`;

SELECT YEAR('1998-07-31 00:00:00.000000');

SELECT `first_name`
FROM `employees`
WHERE `department_id` IN (3, 10) AND YEAR(`hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;

SELECT 'Design Engineer' LIKE '%engineer%';

SELECT `first_name`, `last_name`
FROM `employees`
WHERE NOT `job_title` LIKE '%engineer%'
ORDER BY `employee_id`;

SELECT `name`
FROM `towns`
WHERE CHAR_LENGTH(`name`) IN (5, 6)
ORDER BY `name`;

SELECT CHAR_LENGTH('Berlin');

SELECT *
FROM `towns`
WHERE `name` REGEXP '^[mkbe]'
ORDER BY `name`;

SELECT *
FROM `towns`
WHERE `name` REGEXP '^[^rbd]'
ORDER BY `name`;

DROP VIEW `v_employees_hired_after_2000`;

CREATE VIEW `v_employees_hired_after_2000` AS
	SELECT `first_name`, `last_name`
    FROM `employees`
    WHERE YEAR(`hire_date`) > 2000;
    
SELECT * FROM `v_employees_hired_after_2000`;

SELECT * FROM `employees`;

SELECT `first_name`, `last_name`
FROM `employees`
WHERE CHAR_LENGTH(`last_name`) = 5;

SELECT 'Albania' LIKE '%a%a%a%';

USE `geography`;

SELECT `country_name`, `iso_code`
FROM `countries`
WHERE `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code`;

SELECT `peak_name`, `river_name`, LOWER(CONCAT(`peak_name`, SUBSTR(`river_name`, 2))) AS `mix`
FROM `peaks`, `rivers`
WHERE RIGHT(`peak_name`, 1) = LEFT(`river_name`, 1)
ORDER BY `mix`;

USE `diablo`;

SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS `start`
FROM `games`
WHERE YEAR(`start`) IN (2011, 2012)
ORDER BY `start`, `name`
LIMIT 50;

SELECT SUBSTR('aaa@abv.bg', LOCATE('@', 'aaa@abv.bg') + 1);

SELECT `user_name`, SUBSTR(`email`, LOCATE('@', `email`) + 1) AS `email_provider`
FROM `users`
ORDER BY `email_provider`, `user_name`;

SELECT `user_name`, `ip_address`
FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

SELECT * FROM `games`;
SELECT HOUR('2014-06-07 23:19:14.000000');

SELECT
	`name` AS `game`,
    IF(
		HOUR(`start`) >= 0 AND HOUR(`start`) < 12, 'Morning',
        IF(
			HOUR(`start`) >= 12 AND HOUR(`start`) < 18, 'Afternoon',
			'Evening'
		)
	) AS `Part of the Day`,
    IF(
		`duration` <= 3, 'Extra Short',
        IF(
			`duration` <= 6, 'Short',
            IF(
				`duration` <= 10, 'Long',
                'Extra Long'
			)
		)
	) AS `Duration`
FROM `games`;

SELECT ADDDATE('2016-09-19 00:00:00', INTERVAL 3 DAY);

SELECT
    `product_name`,
    `order_date`,
    ADDDATE(`order_date`, INTERVAL 3 DAY) AS `pay_due`,
    ADDDATE(`order_date`, INTERVAL 1 MONTH) AS `deliver_due`
FROM `orders`;