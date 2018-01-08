DROP USER if exists 'USER_RO'@'localhost';
DROP USER if exists 'USER_RW_PROJEKT'@'localhost';

CREATE USER if not exists 'USER_RO'@'localhost' IDENTIFIED BY 'user';
GRANT SELECT ON car_rental.* TO 'USER_RO'@'localhost';

CREATE USER if not exists 'USER_RW_PROJECT'@'localhost' IDENTIFIED BY 'user';
GRANT SELECT, UPDATE, INSERT, DELETE, DROP ON car_rental.car TO 'USER_RW_PROJECT'@'localhost';

