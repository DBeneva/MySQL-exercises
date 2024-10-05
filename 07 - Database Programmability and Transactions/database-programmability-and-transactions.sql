SELECT * FROM `employees`;

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_get_employees_salary_above_35000`;
CREATE PROCEDURE `usp_get_employees_salary_above_35000`()
BEGIN
	SELECT `first_name`, `last_name`
    FROM `employees`
    WHERE `salary` > 35000
    ORDER BY `first_name`, `last_name`, `employee_id`; 
END$$
DELIMITER ;

CALL `usp_get_employees_salary_above_35000`();

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_get_employees_salary_above`;
CREATE PROCEDURE `usp_get_employees_salary_above`(`min_salary` DECIMAL(10, 4))
BEGIN
	SELECT `first_name`, `last_name`
    FROM `employees`
    WHERE `salary` >= `min_salary`
    ORDER BY `first_name`, `last_name`, `employee_id`; 
END$$
DELIMITER ;

CALL `usp_get_employees_salary_above`(45000);

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_get_towns_starting_with`;
CREATE PROCEDURE `usp_get_towns_starting_with`(`initial_string` VARCHAR(50))
BEGIN
	SELECT `name` AS `town_name`
    FROM `towns`
    WHERE `name` LIKE CONCAT(`initial_string`,'%')
    ORDER BY `town_name`; 
END$$
DELIMITER ;

CALL `usp_get_towns_starting_with`('S');

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_get_employees_from_town`;
CREATE PROCEDURE `usp_get_employees_from_town`(`town_name` VARCHAR(50))
BEGIN
	SELECT `e`.`first_name`, `e`.`last_name`
    FROM `employees` AS `e`
		JOIN `addresses` AS `a` ON `a`.`address_id` = `e`.`address_id`
        JOIN `towns` AS `t` ON `t`.`town_id` = `a`.`town_id`
	WHERE `t`.`name` = `town_name`
    ORDER BY `first_name`, `last_name`, `employee_id`; 
END$$
DELIMITER ;

CALL `usp_get_employees_from_town`('Sofia');

DELIMITER $$
DROP FUNCTION IF EXISTS `ufn_get_salary_level`;
CREATE FUNCTION `ufn_get_salary_level`(`salary` DECIMAL(10, 2))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
	DECLARE `salary_level` VARCHAR(50);
    IF `salary` < 30000 THEN SET `salary_level` := 'Low';
    ELSEIF `salary` <= 50000 THEN SET `salary_level` := 'Average';
	ELSE SET `salary_level` := 'High';
    END IF;
    RETURN `salary_level`;
END$$
DELIMITER ;

SELECT `ufn_get_salary_level`(13500);

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_get_employees_by_salary_level`;
CREATE PROCEDURE `usp_get_employees_by_salary_level`(`salary_level` VARCHAR(50))
BEGIN
	SELECT `first_name`, `last_name`
    FROM `employees`
	WHERE
		`salary` < 30000 AND `salary_level` = 'low'
        OR `salary` >= 30000 AND `salary` <= 50000 AND `salary_level` = 'average'
        OR `salary` > 50000 AND `salary_level` = 'high'
    ORDER BY `first_name` DESC, `last_name` DESC;
END$$
DELIMITER ;

CALL `usp_get_employees_by_salary_level`('average');

DELIMITER $$
DROP FUNCTION IF EXISTS ufn_is_word_comprised;
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN word REGEXP(CONCAT('^[', set_of_letters, ']+$'));
END$$
DELIMITER ;

SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');

DELIMITER $$
DROP PROCEDURE IF EXISTS usp_get_holders_full_name;
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) AS full_name
    FROM account_holders
    ORDER BY full_name, id;
END$$
DELIMITER ;

CALL usp_get_holders_full_name();

DELIMITER $$
DROP FUNCTION IF EXISTS ufn_calculate_future_value;
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(10, 4), yearly_interest DOUBLE, years INT)
RETURNS DECIMAL(10, 4)
DETERMINISTIC
BEGIN
	RETURN sum * (POWER(1 + yearly_interest, years));
END$$
DELIMITER ;

SELECT ufn_calculate_future_value(1000, 0.5, 5);

DELIMITER $$
DROP PROCEDURE IF EXISTS usp_calculate_future_value_for_account;
CREATE PROCEDURE usp_calculate_future_value_for_account(acc_id INT, interest DOUBLE(19, 4))
BEGIN
	SELECT
		a.id AS account_id,
        ah.first_name,
        ah.last_name,
        a.balance AS current_balance,
        ufn_calculate_future_value(balance, interest, 5) AS balance_in_5_years
    FROM accounts a
    JOIN account_holders ah ON a.account_holder_id = ah.id
    WHERE a.id = acc_id;
END$$
DELIMITER ;

CALL usp_calculate_future_value_for_account(10, 0.00007);

DELIMITER $$
DROP PROCEDURE IF EXISTS usp_deposit_money;
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DOUBLE(19, 4))
BEGIN
	UPDATE accounts
    SET balance = balance + money_amount
    WHERE id = account_id AND money_amount > 0;
END$$
DELIMITER ;

CALL usp_deposit_money(1, 10);

DELIMITER $$
DROP PROCEDURE IF EXISTS usp_withdraw_money;
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DOUBLE(19, 4))
BEGIN
	UPDATE accounts
    SET balance = balance - money_amount
    WHERE id = account_id AND money_amount > 0 AND balance >= money_amount;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS usp_transfer_money;
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19, 4))
BEGIN    
	START TRANSACTION;
    IF (
		from_account_id = to_account_id
		OR amount <= 0
        OR (SELECT balance FROM accounts WHERE id = from_account_id) < amount
        OR (SELECT from_account_id FROM accounts WHERE id = from_account_id) IS NULL
        OR (SELECT to_account_id FROM accounts WHERE id = to_account_id) IS NULL
	) THEN
		ROLLBACK;
	ELSE
		UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
            
        UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
        COMMIT;
	END IF;
END$$
DELIMITER ;

CALL usp_transfer_money(12, 13, 1000000);

DELIMITER $$
DROP PROCEDURE IF EXISTS usp_get_holders_with_balance_higher_than;
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(amount DECIMAL(19, 4))
BEGIN
	SELECT ah.first_name, ah.last_name
    FROM account_holders ah
    JOIN accounts a
		ON a.account_holder_id = ah.id
	GROUP BY ah.id
	HAVING SUM(a.balance) > amount
	ORDER BY ah.id;
END$$
DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);

CREATE TABLE logs(
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    old_sum DECIMAL(19, 4),
    new_sum DECIMAL(19, 4)
);

ALTER TABLE logs
ADD CONSTRAINT fk_logs_accounts
FOREIGN KEY (account_id) REFERENCES accounts(id);

CREATE TRIGGER tr_changed_balance
AFTER UPDATE
ON accounts
FOR EACH ROW
	INSERT INTO logs (account_id, old_sum, new_sum)
    VALUES(OLD.id, OLD.balance, NEW.balance);
    
SELECT * FROM logs;

UPDATE accounts
SET balance = 200
WHERE id = 1;

CREATE TABLE notification_emails(
	id INT AUTO_INCREMENT PRIMARY KEY,
    recipient INT,
    subject VARCHAR(50),
    body VARCHAR(200)
);

ALTER TABLE notification_emails
ADD CONSTRAINT fk_notification_emails_accounts
FOREIGN KEY (recipient) REFERENCES accounts(id);

CREATE TRIGGER tr_notification_emails_for_logs
AFTER INSERT ON logs
FOR EACH ROW
	INSERT INTO notification_emails (recipient, subject, body)
    VALUES(
		NEW.account_id,
        CONCAT('Balance change for account: ', CONVERT(NEW.account_id, CHAR)),
		CONCAT(
			'On ', DATE_FORMAT(NOW(), '%b %d %Y at %I:%i:%S %p'),
            ' your balance was changed from ',
            CONVERT(NEW.old_sum, CHAR),
            ' to ', CONVERT(NEW.new_sum, CHAR), '.'
		)
	);
    
SELECT * FROM logs;
SELECT * FROM notification_emails;

UPDATE accounts
SET balance = 300
WHERE id = 1;