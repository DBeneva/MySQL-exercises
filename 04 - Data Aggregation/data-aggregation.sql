SELECT COUNT(`id`) AS `count`
FROM `wizzard_deposits`;

SELECT MAX(`magic_wand_size`) AS `longest_magic_wand`
FROM `wizzard_deposits`;

SELECT `deposit_group`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY AVG(`magic_wand_size`)
LIMIT 1;

SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum`;

SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum`
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;

SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum`
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS `min_deposit_charge`
FROM `wizzard_deposits`
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator`, `deposit_group`;

SELECT IF(
	`age` >= 0 AND `age` <= 10, '[0-10]',
		IF(`age` > 10 AND `age` <= 20, '[11-20]',
			IF(`age` > 20 AND `age` <= 30, '[21-30]',
				IF(`age` > 30 AND `age` <= 40, '[31-40]',
					IF(`age` > 40 AND `age` <= 50, '[41-50]',
						IF(`age` > 50 AND `age` <= 60, '[51-60]',
							'[61+]'
						)
					)
				)
			)
		)
	) AS `age_group`,
    COUNT(*) AS `wizard_count`
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `age_group`;

SELECT LEFT(`first_name`, 1) AS `first_letter`
FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter`;

SELECT `deposit_group`, `is_deposit_expired`, AVG(`deposit_interest`) AS `average_interest`
FROM `wizzard_deposits`
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group`, `is_deposit_expired`
ORDER BY `deposit_group` DESC, `is_deposit_expired`;

USE `soft_uni`;

SELECT `department_id`, MIN(`salary`) AS `min_salary`
FROM `employees`
WHERE `department_id` IN (2, 5, 7) AND `hire_date` >= '2000-01-01'
GROUP BY `department_id`
ORDER BY `department_id`;

SELECT `department_id`, AVG(IF(`department_id` = 1, `salary` + 5000, `salary`)) AS `avg_salary`	
FROM `employees`
WHERE `salary` > 30000 AND NOT `manager_id` = 42
GROUP BY `department_id`
ORDER BY `department_id`;

SELECT `department_id`, MAX(`salary`) AS `max_salary`
FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id`;

SELECT COUNT(`salary`) AS ``
FROM `employees`
WHERE `manager_id` IS NULL;

SELECT DISTINCT
	`department_id`,
    (SELECT DISTINCT `salary`
		FROM `employees` AS `e`
		WHERE `e`.`department_id` = `employees`.`department_id`
        ORDER BY `salary` DESC
		LIMIT 1 OFFSET 2
	) AS `third_highest_salary`
FROM `employees`
HAVING `third_highest_salary` IS NOT NULL
ORDER BY `department_id`;

SELECT `first_name`, `last_name`, `department_id`
FROM `employees`
WHERE `salary` > (
	SELECT AVG(`salary`)  AS `avg_salary`
    FROM `employees` AS `e`
    WHERE `e`.`department_id` = `employees`.`department_id`
    GROUP BY `department_id`
)
ORDER BY `department_id`, `employee_id`
LIMIT 10;


SELECT `department_id`, SUM(`salary`) AS `total_salary`
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;