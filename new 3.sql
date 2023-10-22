
-- Duvan Camilo Puerto Barajas
-- 041085718


-- create the DATABASE

CREATE DATABASE LAB6

-- To use the DATABASE

USE LAB6

-- to create the table customers

CREATE TABLE customers (

	id int auto_increment,
    name varchar(50) not null,
    email varchar(150) null,
    phone_number varchar(20) null,
    street_address varchar(50) null,
    city Varchar(30) not null,
    province char(2) null,
    postal_code CHAR(6) null,
    
    constraint customersPK primary key(id)
);