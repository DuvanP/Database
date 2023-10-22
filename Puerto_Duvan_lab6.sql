

-- Duvan Camilo Puerto Barajas
-- 041085718


-- create the DATABASE

CREATE DATABASE LAB6

-- To use the DATABASE

USE LAB6

-- To create the table customers
CREATE TABLE customers (

	id int auto_increment,
    name varchar(50) not null,
    email varchar(150) null,
    phone_number varchar(20) null,
    street_address varchar(50) null,
    city Varchar(30) null,
    province char(2) null,
    postal_code CHAR(6) null,
    
    constraint customersPK primary key(id)
);

-- To create the table orders
CREATE TABLE orders (

	id int auto_increment not null,
	order_date DATETIME null, 
	customers_id int not null,
	
	constraint ordersPK primary key (id),
	
	constraint ordersFK FOREIGN KEY (customers_id) REFERENCES customers(id)
	
	
);

-- To create the table product_types
CREATE TABLE product_types (
	id INT NOT NULL auto_increment,
  	name VARCHAR(50) NOT NULL,
	
	constraint product_typesPK primary key (id)
);

-- To create the table products
CREATE TABLE products (

	id int auto_increment not NULL,
	description VARCHAR(75) not NULL,
	price DECIMAL(6,2) NULL,
    product_types_id INT NOT NULL,
	
	constraint productsPK primary key (id),
	constraint productsFK FOREIGN KEY (product_types_id) REFERENCES product_types(id)


);
 -- To create the table order_lines
CREATE TABLE order_lines(
  orders_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NULL,
  price DECIMAL(6,2) NULL,
  line_total DECIMAL(8,2) NULL,
  
  
  constraint ordersPK primary key (orders_id,product_id),
  constraint ordersFK1 
	FOREIGN KEY (orders_id) 
	REFERENCES orders(id),
  
  
  constraint ordersFK2 FOREIGN KEY (product_id) REFERENCES products(id)
  
  );
  
  
  -- ---------------INSERT INTO customers
 
 INSERT INTO customers
 (name, email, phone_number,street_address,city,province,postal_code)
 values 
 ( 'Marge' , 'marge@gmail.com' ,'3005760000', '123 AV siempre viva' , 'springfield' , 'OH' , '123456'),	
 ( 'Bart' , 'bart@gmail.com' ,'3005761111', '123 AV siempre viva' , 'springfield' , 'OH' , '123456'),
 ( 'Lisa' , 'lisa@gmail.com' ,'3005762222', '123 AV siempre viva' , 'springfield' , 'OH' , '123456'),
 ( 'Homer' , 'homer@gmail.com' ,'3005763333', '123 AV siempre viva' , 'springfield' , 'OH' , '123456'),
 ( 'Magy' , 'magy@gmail.com' ,'3005764444', '123 AV siempre viva' , 'springfield' , 'OH' , '123456');
 
 
 
 -- --------------- INSERT INTO product_types
 
 INSERT INTO product_types
 (name)
 values 
 ( 'Software'),
 ( 'Hardware'),
 ( 'Service');
 
 
 
 -- ---- INSERT INTO products
 
 INSERT INTO products
 (description,price,product_types_id)
 values 
 ( 'Windows',125, 1),
 ( 'Visual Studio',200, 1),
 ( 'Mouse',25, 2),
 ( 'Phone repair',150, 3),
 ( 'Keyboard',20, 2),
 ( 'Windows Installation',60, 3)
 ;
 
 
 
 -------------- UPDATE PHONE NUMBER
 
 UPDATE customers
set phone_number = '222222222'
where id = 1;


--------------- UPDATABLE postal code
UPDATE customers
set postal_code = '987654'
where id = 4;


--------- Delete "software"

ALTER TABLE products
	drop constraint productsFK;

DELETE from product_types
where id  =1;