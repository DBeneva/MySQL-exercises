SELECT `e`.`employee_id`, `e`.`job_title`, `a`.`address_id`, `a`.`address_text`
FROM `employees` AS `e`
JOIN `addresses` AS `a`
	ON `e`.`address_id` = `a`.`address_id`
ORDER BY `a`.`address_id`
LIMIT 5;

SELECT `e`.`first_name`, `e`.`last_name`, `t`.`name` AS `town`, `a`.`address_text`
FROM `employees` AS `e`
JOIN `addresses` AS `a`
	ON `e`.`address_id` = `a`.`address_id`
JOIN `towns` AS `t`
	ON `a`.`town_id` = `t`.`town_id`
ORDER BY `e`.`first_name`, `last_name`
LIMIT 5;

SELECT `e`.`employee_id`, `e`.`first_name`, `e`.`last_name`, `d`.`name` AS `department_name`
FROM `employees` AS `e`
JOIN `departments` AS `d`
	ON `e`.`department_id` = `d`.`department_id`
WHERE `d`.`name` = 'Sales'
ORDER BY `e`.`employee_id` DESC;

SELECT `e`.`employee_id`, `e`.`first_name`, `e`.`salary`, `d`.`name` AS `department_name`
FROM `employees` AS `e`
JOIN `departments` AS `d`
	ON `e`.`department_id` = `d`.`department_id`
WHERE `e`.`salary` > 15000
ORDER BY `d`.`department_id` DESC
LIMIT 5;

SELECT `e`.`employee_id`, `e`.`first_name`
FROM `employees` AS `e`
LEFT JOIN `employees_projects` AS `ep`
	ON `e`.`employee_id` = `ep`.`employee_id`
WHERE `ep`.`project_ID` IS NULL
ORDER BY `e`.`employee_id` DESC
LIMIT 3;

SELECT `e`.`first_name`, `e`.`last_name`, `e`.`hire_date`, `d`.`name` AS `dept_name`
FROM `employees` AS `e`
JOIN `departments` AS `d`
	ON `e`.`department_id` = `d`.`department_id`
WHERE `e`.`hire_date` > '1999-01-01' AND `d`.`name` IN ('Sales', 'Finance')
ORDER BY `e`.`hire_date`;

SELECT `e`.`employee_id`, `e`.`first_name`, `p`.`name` AS `project_name`
FROM `employees` AS `e`
JOIN `employees_projects` AS `ep`
	ON `e`.`employee_id` = `ep`.`employee_id`
JOIN `projects` AS `p`
	ON `ep`.`project_id` = `p`.`project_id`
WHERE DATE(`p`.`start_date`) > '2002-08-13' AND `p`.`end_date` IS NULL
ORDER BY `e`.`first_name`, `project_name`
LIMIT 5;

SELECT
	`e`.`employee_id`,
    `e`.`first_name`,
    IF(YEAR(`p`.`start_date`) >= 2005, NULL, `p`.`name`) AS `project_name`
FROM `employees` AS `e`
	JOIN `employees_projects` AS `ep`
		ON `e`.`employee_id` = `ep`.`employee_id`
	JOIN `projects` AS `p`
		ON `ep`.`project_id` = `p`.`project_id`
WHERE `e`.`employee_id` = 24
ORDER BY `project_name`;

SELECT
	`e`.`employee_id`,
    `e`.`first_name`,
    `e`.`manager_id`,
    `m`.`first_name` AS `manager_name`
FROM `employees` AS `e`
	JOIN `employees` AS `m`
		ON `e`.`manager_id` = `m`.`employee_id`
WHERE `m`.`employee_id` IN (3, 7)
ORDER BY `e`.`first_name`;

SELECT
	`e`.`employee_id`,
    CONCAT(`e`.`first_name`, ' ', `e`.`last_name`) AS `employee_name`,
    CONCAT(`m`.`first_name`, ' ', `m`.`last_name`) AS `manager_name`,
    `d`.`name` AS `department_name`
FROM `employees` AS `e`
	JOIN `employees` AS `m`
		ON `e`.`manager_id` = `m`.`employee_id`
	JOIN `departments` AS `d`
		ON `e`.`department_id` = `d`.`department_id`
ORDER BY `e`.`employee_id`
LIMIT 5;

SELECT AVG(`e`.`salary`) AS `min_average_salary`
FROM `employees` AS `e`
GROUP BY `department_id`
ORDER BY `min_average_salary`
LIMIT 1;

USE `geography`;

SELECT `mc`.`country_code`, `m`.`mountain_range`, `p`.`peak_name`, `p`.`elevation`
FROM `peaks` AS `p`
	JOIN `mountains` AS `m`
		ON `p`.`mountain_id` = `m`.`id`
	JOIN `mountains_countries` AS `mc`
		ON `m`.`id` = `mc`.`mountain_id`
WHERE `mc`.`country_code` = 'BG' AND `p`.`elevation` > 2835
ORDER BY `p`.`elevation` DESC;

SELECT `mc`.`country_code`, COUNT(`m`.`id`) AS `mountain_range`
FROM `mountains` AS `m`
	JOIN `mountains_countries` AS `mc`
		ON `m`.`id` = `mc`.`mountain_id`
WHERE `mc`.`country_code` IN ('US', 'RU', 'BG')
GROUP BY `mc`.`country_code`
ORDER BY `mountain_range` DESC;

SELECT `c`.`country_name`, `r`.`river_name`
FROM `countries` AS `c`
	LEFT JOIN `countries_rivers` AS `cr`
		ON `c`.`country_code` = `cr`.`country_code`
	LEFT JOIN `rivers` AS `r`
		ON `cr`.`river_id` = `r`.`id`
WHERE `c`.`continent_code` = 'AF'
ORDER BY `country_name`
LIMIT 5;

SELECT `c1`.`continent_code`, `c1`.`currency_code`, COUNT(*) AS `currency_usage` 
FROM `countries` AS `c1`
GROUP BY `c1`.`continent_code`, `c1`.`currency_code`
HAVING `currency_usage` > 1 AND `currency_usage` = (
	SELECT COUNT(*) AS `most_used_currency`
	FROM `countries` AS `c2`
	WHERE `c2`.`continent_code` = `c1`.`continent_code`
	GROUP BY `c2`.`currency_code`
    ORDER BY `most_used_currency` DESC
    LIMIT 1
)
ORDER BY `c1`.`continent_code`, `c1`.`currency_code`;

SELECT COUNT(*)
FROM (
	SELECT DISTINCT `c`.`country_name` AS `country_count`
    FROM `countries` AS `c`
		JOIN `mountains_countries` AS `mc`
			ON `c`.`country_code` NOT IN (
				SELECT DISTINCT `country_code`
				FROM `mountains_countries`
			)
) AS `tmp`;

SELECT COUNT(*)
FROM `countries` AS `c`
	LEFT JOIN `mountains_countries` AS `mc`
		ON `c`.`country_code` = `mc`.`country_code`
WHERE `mc`.`mountain_id` IS NULL;

SELECT `c`.`country_name`
FROM `countries` AS `c`
	JOIN `mountains_countries` AS `mc`
		ON `c`.`country_code` = `mc`.`country_code`;
        
SELECT
	`c`.`country_name`,
    MAX(`p`.`elevation`) AS `highest_peak_elevation`,
    MAX(`r`.`length`) AS `longest_river_length`
FROM `countries` AS `c`
	JOIN `mountains_countries` AS `mc`
		ON `c`.`country_code` = `mc`.`country_code`
	JOIN `peaks` AS `p`
		ON `mc`.`mountain_id` = `p`.`mountain_id`
	JOIN `countries_rivers` AS `cr`
		ON `c`.`country_code` = `cr`.`country_code`
	JOIN `rivers` AS `r`
		ON `cr`.`river_id` = `r`.`id`
GROUP BY `c`.`country_name`
ORDER BY `highest_peak_elevation` DESC, `longest_river_length` DESC, `country_name`
LIMIT 5;

SELECT `c1`.`continent_code`, `c1`.`currency_code`, COUNT(*) AS `currency_usage`
FROM `countries` AS `c1`
GROUP BY `continent_code`, `currency_code`
HAVING
	`currency_usage` > 1
    AND `currency_usage` = (
		SELECT COUNT(*) AS `max_currency_usage`
        FROM `countries` AS `c2`
        WHERE `c1`.`continent_code` = `c2`.`continent_code`
        GROUP BY `currency_code`
        ORDER BY `max_currency_usage` DESC
        LIMIT 1
	)
ORDER BY `continent_code`, `currency_code`;

SELECT `t`.`town_id`, `t`.`name` AS `town_name`, `a`.`address_text`
FROM `addresses` AS `a`
JOIN `towns` AS `t`
	ON `t`.`town_id` = `a`.`town_id`
WHERE `t`.`name` IN ('San Francisco', 'Sofia', 'carnation')
ORDER BY `t`.`town_id`, `a`.`address_id`;

USE `soft_uni`;
SELECT `employee_id`, `first_name`, `last_name`, `department_id`, `salary`
FROM `employees`
WHERE `manager_id` IS NULL;
