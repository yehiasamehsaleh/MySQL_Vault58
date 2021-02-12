

"""
Name: Yehia Sameh Said Saleh
Faculty n.=273219001
Bookstore MYSQL project v1
"""

SELECT CURDATE();
SELECT TIMEDIFF(NOW(), UTC_TIMESTAMP);  -- It will return 02:00:00 if your timezone is +2:00.
SET time_zone = "+02:00";

-- Bookstore_DB
SET SQL_SAFE_UPDATES = 0;


CREATE DATABASE Bookstore_DB1
  CHARACTER SET utf8
  COLLATE utf8_general_ci;


show collation;
SHOW COLLATION WHERE `Default` = 'Yes';

USE bookstore_db1;
SELECT @@character_set_database, @@collation_database;


USE Bookstore_DB1;
select * from books
drop table books;

CREATE TABLE IF NOT EXISTS books (
   isbn      NUMERIC(13) NOT NULL UNIQUE, 
   author    TEXT(40), 
   title     VARCHAR(200) NOT NULL, 
   edition   VARCHAR(5) DEFAULT '1st', 
   publication_year      INTEGER,
   package_weight    DECIMAL(5,1),
   n_pages   VARCHAR(20),
   price     varchar(20)  NOT NULL,
   image BLOB,
   PRIMARY KEY (isbn));


insert into books (isbn,author,title,edition,publication_year,package_weight,n_pages,price)
VALUES
(9780747532743,'JK. Rowling',"Harry Potter and the Sorcerer's Stone",null,1998,200.0,null,14.99),
(9780545582933,'JK. Rowling','Harry Potter and the Prisoner of Azkaban','3rd',2013,385.5,464,10),
(9780553808049,'George R. R. Martin','Game of thrones:A Song of Ice and Fire','1st',2016,830.0,704,26),
(9780345339737,'Del Rey','The Lord of the Rings:The Return of the King','3rd',1986,240.0,900,22.48),
(9780765378774,'George R. R. Martin','The Ice Dragon',null,2014,250.0,120,11.70),
(9781491939369,'Allen B. Downey','Think Python: How to Think Like a Computer Scientist','2nd',2016,500.0,292,35),
(9780134685991,'Joshua Bloch','Effective Java','3rd',2017,680.0,416,49.50),
(9780321563842,'Bjarne Stroustrup','The C++ Programming Language','4th',2013,1238.0,1376,48.50),
(9781491952023,'David Flanagan',"JavaScript: The Definitive Guide: Master the World's Most-Used Programming Language",'7th',2020,1202.0,706,'22.75 euro'),
(9781524763138,'Michelle Obama','Becoming',null,2018,794.0,448,9.49),
(9780525633761,'Barack Obama','A Promised Land',null,2020,1111.3,1136,25),
(9780553211405, 'Charlotte Bronte','Jane Eyre',null,1983,240.9,492,7.99);

UPDATE books SET n_pages = CONCAT(n_pages,' pages');

UPDATE books SET price = CONCAT(price,' euro') where price NOT LIKE '%euro';

select * from books ORDER BY title;

DELETE FROM books;


select title,price as best_seller from books 
ORDER BY price DESC LIMIT 3;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT COUNT(*) FROM books;

SELECT title,publication_year FROM books WHERE publication_year > 2012 and author ='JK. Rowling';

SELECT COUNT(*) FROM books;

select title,price from books where price > (select avg(price) from books) ORDER BY price DESC;

-- rank the books of each author by price
select author,title,price,dense_rank()
over (partition by author order by price desc)
AS 'Most expensive books by author' FROM books;

SELECT * FROM books
   WHERE title REGEXP 'Harry Potter'
      ORDER BY publication_year; 

SELECT title FROM books WHERE title REGEXP'[r]{2}|[t]{2}';

SELECT * FROM books WHERE isbn = 9780345339737 or 9780345339738;

-- Give a 20 percent discount for books greater than 20 euros
SELECT isbn,title,round(price*0.8)
   AS discounted_price FROM books 
      WHERE price > 20;

UPDATE books SET price = price*1.5 WHERE title = "Harry Potter and the Sorcerer's Stone";

SELECT title FROM books WHERE title REGEXP '^Harry';

SELECT isbn,title,author FROM books WHERE title REGEXP 'fire|Fire|ice|Ice';

SELECT round(avg(price)) FROM books
   WHERE author IN (SELECT author FROM books 
      WHERE author = 'JK. Rowling');

SELECT author,title,publication_year FROM books WHERE publication_year <> 2013 and price not between 25 and 50;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop table customers;

CREATE TABLE IF NOT EXISTS customers (
  id integer  not null AUTO_INCREMENT,
  name char(30) NOT NULL,
  email varchar(30) UNIQUE,
  age numeric(10),
  city varchar(30),
  gender char(1) default null,
  primary key (id),
  check(gender in ('M','F')))
  engine=myisam auto_increment=1000;   
  
SET @@auto_increment_increment= 4;   -- bug why does it start from 1001
SET GLOBAL auto_increment_increment=1;

SHOW TABLE STATUS where name like 'customers'

insert into customers(name,email,age,city,gender)
values
('jack','Jack@email.com',30,'Sofia','M'),
('jacob','jacob@email.com',50,'burgas','M'),
('julia','julia@email.com',20,'plovdiv','F'),
('jake','jake@email.com',20,'plovdiv','F'),
('jessica','jessica@email.com',35,'varna','F'),
('judy','judy@email.com',60,'Sofia','F'),
('john','john@email.com',40,'blagoevgrad','M'),
('jadon','jadon@email.com',45,'pernik','M');

select * from customers;

select id from customers order by id asc;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop table Purchased_Books;

CREATE TABLE Purchased_Books(
	id integer not null AUTO_INCREMENT,  -- must be of the same type or else the error incompatible will appear
	isbn NUMERIC(13) NOT NULL,
	quantity INTEGER NOT NULL default '0',
	PRIMARY KEY (id, isbn),
	Constraint c_id
	   FOREIGN KEY (id)
		   REFERENCES customers(id)
		      ON DELETE CASCADE,
	Constraint b_id
	   FOREIGN KEY (isbn)
		   REFERENCES books(isbn)
		      ON DELETE CASCADE);

 


select * from Purchased_Books;

insert into Purchased_Books(id,isbn,quantity)
values
('1001',9780747532743,2),
('1025',9780747532743,4),
('1001',9780545582933,1),
('1005',9780765378774,1),
('1005',9780553808049,1),
('1009',9781491952023,1),
('1013',9780525633761,3),
('1013',9781524763138,1),
('1013',9780553211405,1),
('1017',9780321563842,1),
('1021',9780345339737,1),
('1021',9780765378774,1),
('1021',9780545582933,2),
('1025',9781491939369,1),
('1029',9780134685991,12);




select max(tot_quantity_sold) from (
select isbn, sum(quantity) as tot_quantity_sold
from Purchased_Books
group by isbn) as a;


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
drop table Book_genres;

create table if not exists Book_genres(
isbn  NUMERIC(13) UNIQUE NOT NULL,
genre char(20) NOT NULL,
primary key(isbn),
foreign key(isbn) references books(isbn)
);

SELECT @@collation_database;


select * from Book_genres;

insert into Book_genres(isbn,genre)
values
(9780545582933,'Fantasy'),
(9780747532743,'Fantasy'),
(9780553808049,'Fantasy'),
(9780345339737,'Fantasy'),
(9780765378774,'Fantasy'),
(9781491939369,'Tech'),
(9780134685991,'Tech'),
(9780321563842,'Tech'),
(9781491952023,'Tech'),
(9781524763138,'Autobiography'),
(9780525633761,'Autobiography'),
(9780553211405,'CLassics');

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

drop table Book_rating;

CREATE TABLE Book_rating(
	id integer not null AUTO_INCREMENT,  -- must be of the same type or else the error incompatible will appear
	isbn NUMERIC(13) NOT NULL,
	c_rating VARCHAR(5),
    image BlOB,
	PRIMARY KEY (id, isbn),
	Constraint d_id
	   FOREIGN KEY (id)
		   REFERENCES customers(id)
		      ON DELETE CASCADE,
	Constraint e_id
	   FOREIGN KEY (isbn)
		   REFERENCES books(isbn)
		      ON DELETE CASCADE);

insert into Book_rating(id,isbn,c_rating)
Values
(1013,9780525633761,'5/5'),
('1009',9781491952023,'4/5'),
('1001',9780747532743,'2/5'),
('1005',9780553808049,'3/5'),
('1005',9780765378774,'3/5'),
('1021',9780545582933,'5/5');

select isbn,c_rating from Book_rating;

create index star on Book_rating(c_rating);

Explain SELECT c_rating from Book_rating where c_rating='5/5';


select name,c_rating,isbn as book_code
from Book_rating,customers
where Book_rating.id=customers.id

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


drop table vip_subscription;


Create table if not exists vip_subscription(
id integer not null AUTO_INCREMENT,
membership_type enum('Pro', 'Advanced' ,'Premium'),
purchase_date date,  -- datetime DEFAULT '0000-00-00 00:00:00'
receipt_code varchar(20),
auto_renew char(1) not null,
billing_type enum('Monthly', 'Yearly'),                             
primary key(id,receipt_code),
foreign key (id) REFERENCES customers(id),
check(auto_renew in ('Y','N')));



-- ALTER TABLE vip_subscription CONVERT TO CHARACTER SET utf8;
-- str_to_date('200120','%d%m%Y')
insert into vip_subscription(id,membership_type,purchase_date,receipt_code,auto_renew,billing_type)
VALUES
(1013,'Advanced',NULL,'as1234','N','Yearly'),
(1021,'Pro','2020-05-02','df5678','Y','Yearly'),
(1009,'Advanced','2020-04-26','qw9100','Y','Monthly');



insert into vip_subscription(id,membership_type,receipt_code,auto_renew,billing_type)
VALUES
(1029,'Premium','erty11','Y','Monthly');

"""
USE `Bookstore_DB1`;
DELIMITER $$
CREATE TRIGGER `default_date` BEFORE INSERT ON `vip_subscription` FOR EACH ROW
if ( isnull(new.purchase_date) ) then
 set new.purchase_date=curdate();
end if;
$$
delimiter ;
"""


select * from vip_subscription;

SELECT * FROM vip_subscription                  
WHERE purchase_date BETWEEN '2020-01-10' AND '2020-04-30';



-- -----------------------------------------------------------------------------------------------------------------------------------------------------

select name,isbn,c_rating,id
from (customers natural join Book_rating) join vip_subscription using (id);


SELECT 'Customer Base' AS TableName, Count(*) AS B FROM customers 
UNION 
SELECT 'vip_subscribers', Count(*) FROM vip_subscription as C





SELECT c.id as c_id, pb.quantity as n_puchases ,v.membership_type as membership
FROM customers c
    INNER JOIN vip_subscription v ON c.id = v.id
    INNER JOIN Purchased_Books pb ON v.id  = pb.id 
ORDER BY n_puchases desc


"""
-- same result:
select c.id "c_id", pb.quantity "n_puchases",v.membership_type "membership"
from customers c, Purchased_Books pb, vip_subscription v
where pb.id = c.id and pb.id = v.id
order by pb.quantity desc;
"""






-- To add the FILE privileges, execute the code below:
GRANT FILE ON *.* TO 'root'@'localhost';
 SET GLOBAL local_infile=1;

-- Move your file to the directory specified by secure-file-priv.
SHOW VARIABLES LIKE "secure_file_priv";


SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result8.txt'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  lines TERMINATED BY '\r\n'
  FROM vip_subscription;

-- alternatively
SELECT 'ID', 'Type of membership', 'Date','Recurring customer' -- used to add headers to each column
UNION
SELECT id,membership_type,IFNULL(purchase_date, 'N/A'),auto_renew INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result91.txt'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  lines TERMINATED BY '\r\n'
  FROM vip_subscription;



select
      subscribers,
      total_base,
      subscribers*1.0/total_base as percentage
from 
      (select count(*) as subscribers from vip_subscription) as a,
      (select count(*) as total_base from customers) as b;



