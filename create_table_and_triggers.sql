CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE `address`(
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `street` VARCHAR(20) NOT NULL,
  `post_code` VARCHAR(10) NOT NULL,
  `city` VARCHAR(20) NOT NULL,
  `region` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `client` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `surname` VARCHAR(100) NOT NULL,
  `phone_number` VARCHAR(20) NOT NULL,
  `card_number` VARCHAR(22) NOT NULL,
  `address_id` int(10) unsigned NOT NULL,
  `date_birth` DATE,
  `email` VARCHAR(45) NOT NULL,
  FOREIGN KEY addressFK(address_id) REFERENCES address(id),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `car` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20)  NOT NULL,
  `make` VARCHAR(20) NOT NULL,
  `production_year` int(4)  NOT NULL,
  `color` VARCHAR(20) NOT NULL,
  `engine` DOUBLE(3,1)  NOT NULL,
  `power` int(15) NOT NULL,
  `mileage` DOUBLE(8,1),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `agency` (
 `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
 `phone_number` VARCHAR(20) NOT NULL,
 `email` VARCHAR(45) NOT NULL,
 `address_id` int(10) unsigned NOT NULL,
  FOREIGN KEY addressFK(address_id) REFERENCES address(id),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `worker_position` (
 `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
 `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `worker` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
`name` VARCHAR(15) NOT NULL,
`surname` VARCHAR(25) NOT NULL,
`date_birth` DATE,
`address_id` int(10) unsigned NOT NULL,
`position_id` int(10) unsigned NOT NULL,
`agency_id` int(10) unsigned NOT NULL,
FOREIGN KEY addressFK(address_id) REFERENCES address(id),
FOREIGN KEY positionFK(position_id) REFERENCES worker_position(id),
FOREIGN KEY agencyFK(agency_id) REFERENCES agency(id),
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `rent` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
`client_id` int(10) unsigned NOT NULL,
`car_id` int(10) unsigned NOT NULL,
`agency_from_id` int(10) unsigned NOT NULL,
`agency_to_id` int(10) unsigned NOT NULL,
`date_rent` DATE,
`date_return` DATE,
`cost` FLOAT,
INDEX indeks_client (client_id),
INDEX indeks_car (car_id),
FOREIGN KEY clientFK(client_id) REFERENCES client(id),
FOREIGN KEY carFK(car_id) REFERENCES car(id),
FOREIGN KEY agency_fromFK(agency_from_id) REFERENCES agency(id),
FOREIGN KEY agency_toFK(agency_to_id) REFERENCES agency(id),
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `carer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `car_id` int(10) unsigned NOT NULL,
  `worker_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY carFK(car_id) REFERENCES car(id),
  FOREIGN KEY workerFK(worker_id) REFERENCES worker(id)
  );
  
DELIMITER $$
CREATE TRIGGER update_controller
BEFORE UPDATE ON car_rental.rent
FOR EACH ROW BEGIN
 
IF
NEW.cost < 100 THEN
SET NEW.cost = 100;
END IF;
END;$$

DELIMITER $$
CREATE TRIGGER insert_controller
BEFORE INSERT ON car_rental.rent
FOR EACH ROW BEGIN
 
IF
NEW.cost < 100 THEN
SET NEW.cost = 100;
END IF;
END;$$