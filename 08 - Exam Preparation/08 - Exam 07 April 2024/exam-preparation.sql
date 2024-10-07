CREATE DATABASE go_roadie;
USE go_roadie;

CREATE TABLE cities(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cars(
	id INT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE instructors(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    has_a_license_from DATE NOT NULL
);

CREATE TABLE driving_schools(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    night_time_driving TINYINT(1) NOT NULL,
    average_lesson_price DECIMAL(10, 2),
    car_id INT NOT NULL,
    city_id INT NOT NULL,
    CONSTRAINT fk_driving_schools_cars
		FOREIGN KEY (car_id) REFERENCES cars(id),
	CONSTRAINT fk_driving_schools_cities
		FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE students(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    age INT,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE instructors_driving_schools(
	instructor_id INT,
	driving_school_id INT NOT NULL,
    CONSTRAINT fk_instructors_driving_schools_instructors
		FOREIGN KEY (instructor_id) REFERENCES instructors(id),
	CONSTRAINT fk_instructors_driving_schools_driving_schools
		FOREIGN KEY (driving_school_id) REFERENCES driving_schools(id)
);

CREATE TABLE instructors_students(
	instructor_id INT NOT NULL,
	student_id INT NOT NULL,
    CONSTRAINT fk_instructors_students_instructors
		FOREIGN KEY (instructor_id) REFERENCES instructors(id),
	CONSTRAINT fk_instructors_students_students
		FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO students(first_name, last_name, age, phone_number)
SELECT
	REVERSE(LOWER(first_name)),
	REVERSE(LOWER(last_name)),
	age + LEFT(phone_number, 1),
	CONCAT('1+', phone_number)
FROM students
WHERE age < 20;

UPDATE driving_schools
SET average_lesson_price = average_lesson_price + 30
WHERE city_id = (SELECT id FROM cities WHERE name = 'London')
	AND night_time_driving = 1;
    
DELETE FROM driving_schools
WHERE night_time_driving = 0;

SELECT CONCAT(first_name, ' ', last_name) AS full_name, age
FROM students
WHERE first_name LIKE '%a%'
ORDER BY age, id
LIMIT 3;

SELECT ds.id, ds.name, c.brand
FROM driving_schools ds
JOIN cars c ON c.id = ds.car_id
LEFT JOIN instructors_driving_schools ids
	ON ds.id = ids.driving_school_id
WHERE ids.instructor_id IS NULL
ORDER BY c.brand, ds.id
LIMIT 5;

SELECT i.first_name, i.last_name, COUNT(ist.student_id) AS students_count, c.name
FROM instructors AS i
JOIN instructors_students AS ist
	ON i.id = ist.instructor_id
JOIN instructors_driving_schools AS ids
	ON i.id = ids.instructor_id
JOIN driving_schools AS ds
	ON ds.id = ids.driving_school_id
JOIN cities AS c
	ON c.id = ds.city_id
GROUP BY i.first_name, i.last_name, c.name
HAVING students_count > 1
ORDER BY students_count DESC, i.first_name;

SELECT c.name, COUNT(ids.instructor_id) AS instructors_count
FROM cities AS c
JOIN driving_schools AS ds
	ON ds.city_id = c.id
JOIN instructors_driving_schools AS ids
	ON ids.driving_school_id = ds.id
GROUP BY c.name
HAVING instructors_count > 0
ORDER BY instructors_count DESC;

SELECT
	CONCAT(first_name, ' ', last_name) AS full_name,
    IF(
		YEAR(has_a_license_from) >= 1980 AND YEAR(has_a_license_from) < 1990, 'Specialist',
        IF(
			YEAR(has_a_license_from) >= 1990 AND YEAR(has_a_license_from) < 2000, 'Advanced',
            IF(
				YEAR(has_a_license_from) >= 2000 AND YEAR(has_a_license_from) < 2008, 'Experienced',
                IF(
					YEAR(has_a_license_from) >= 2008 AND YEAR(has_a_license_from) < 2015, 'Qualified',
					IF(
						YEAR(has_a_license_from) >= 2015 AND YEAR(has_a_license_from) < 2020, 'Provisional',
                        IF(YEAR(has_a_license_from) >= 2020, 'Trainee', '')
                    )
                )
			)
		)
	) AS level
FROM instructors
ORDER BY YEAR(has_a_license_from), first_name;

DELIMITER $$
DROP FUNCTION IF EXISTS udf_average_lesson_price_by_city;
CREATE FUNCTION udf_average_lesson_price_by_city(name VARCHAR(40))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
	RETURN (
		SELECT AVG(ds.average_lesson_price)
		FROM cities c
		JOIN driving_schools ds
			ON ds.city_id = c.id
		GROUP BY c.name
		HAVING c.name = name
	);
END$$
DELIMITER ;

SELECT udf_average_lesson_price_by_city('London');

DELIMITER $$
DROP PROCEDURE IF EXISTS udp_find_school_by_car;
CREATE PROCEDURE udp_find_school_by_car(brand VARCHAR(20))
BEGIN
	SELECT ds.name, ds.average_lesson_price
    FROM driving_schools ds
    JOIN cars c
		ON c.id = ds.car_id AND c.brand = brand
	ORDER BY ds.average_lesson_price DESC;
END$$
DELIMITER ;

CALL udp_find_school_by_car('Mercedes-Benz');