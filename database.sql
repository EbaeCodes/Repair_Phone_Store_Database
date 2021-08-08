DROP SCHEMA IF EXISTS CELLPHONE_SYSTEM;

CREATE SCHEMA IF NOT EXISTS CELLPHONE_SYSTEM ;
USE CELLPHONE_SYSTEM;

DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS request;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS repairOrder;
DROP TABLE IF EXISTS phone;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS repairChecklist;

  CREATE TABLE address
  (
	postCode int NOT NULL ,
	city varchar(20)NOT NULL ,
    state varchar(20)NOT NULL,
	PRIMARY KEY(postCode)
	)
  CREATE TABLE customer
 (
   ID int NOT NULL, 
   fname varchar(15) NOT NULL,
   lname varchar(15) NOT NULL,
   email_address varchar(30) NOT NULL,
   streetname varchar(15) NOT NULL,
   streetno int  NOT NULL, 
   postcode varchar(20) NOT NULL,
   phonenumber int NOT NULL,
   sex char,
   PRIMARY KEY (ID)
   );
   
  CREATE TABLE department
 (
   DName varchar(15) NOT NULL,
   DNumber int(20) NOT NULL, 
   service varchar(20) NOT NULL, 
   PRIMARY KEY (DNumber)
   );
 CREATE TABLE employee
 (
   eID int(9) NOT NULL, 
   fname varchar(15) NOT NULL,
   lname varchar(15) NOT NULL,
   phonenumber int NOT NULL,
   streetname varchar(15) NOT NULL,
   streetno int NOT NULL, 
   postcode int NOT NULL,
   salary int NOT NULL,
   Mgr_id int(9) NOT NULL,
   sex char,
   dno int not null,
   PRIMARY KEY (eID),
   FOREIGN KEY (Mgr_id) REFERENCES employee(eID),
   FOREIGN KEY (postcode) REFERENCES address(postcode),
   FOREIGN KEY (dno) REFERENCES department(DNumber)
   );
   
CREATE TABLE phone
 (
   IMEi int(10) NOT NULL, 
   model varchar(15) NOT NULL,
   brand varchar(15) NOT NULL,
   color varchar(10),
   duration varchar(20) NOT NULL,
   empID int NOT NULL,
   cusID int NOT NULL,
   PRIMARY KEY (IMEi),
   FOREIGN  KEY (cusID) REFERENCES customer (ID),
   FOREIGN  KEY (empID) REFERENCES employee (eID)
   );
   
  CREATE TABLE repairOrder
  (
	Orderid int NOT NULL ,
	repairStatus varchar(20)NOT NULL ,
    repairDueDate DATE,
    dateRegister Date NOT NULL ,
    Dnumber int ,
    ProblemDescription varchar(20),
	PRIMARY KEY(Orderid),
	FOREIGN KEY (Dnumber) REFERENCES department (DNumber) ON DELETE SET NULL
	);
 
   CREATE TABLE invoice
 (
   invoiceID  int NOT NULL,
   repairOrderID int NOT NULL,
   dateDelivery DATE NOT NULL,
   amount int NOT NULL,
   methodofPayment varchar(20) NOT NULL,
   CONSTRAINT amount_fk CHECK(amount > 0),
   PRIMARY KEY (invoiceID),
   FOREIGN KEY (repairOrderID) REFERENCES repairOrder (Orderid) 
   );
   
   CREATE TABLE repairChecklist
   (
   Orderid int NOT NULL,
   parts varchar(20) ,
   PRIMARY KEY (parts, orderid),
   FOREIGN  KEY (Orderid) REFERENCES repairOrder (Orderid) 
   );
     
  CREATE TABLE request
 (
   orderID int  NOT NULL,
   cID int  NOT NULL,
   IMEi int  NOT NULL,
   PRIMARY KEY (orderID,cID,IMEi),
   FOREIGN KEY (orderID) REFERENCES repairOrder(Orderid),
   FOREIGN KEY (IMEi) REFERENCES phone (IMEi) ,
   FOREIGN KEY (cID) REFERENCES customer (ID)
   );

#To ensure the manager has higher salary
delimiter |
CREATE TRIGGER salary_update
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
IF NEW.salary > (SELECT salary
FROM EMPLOYEE
WHERE eID = NEW.Mgr_id )
THEN SET NEW.salary = (SELECT salary
FROM EMPLOYEE
WHERE eID = NEW.Mgr_id )-1;
END IF;
END;
|
delimiter ; 

#To update the time by 2 weeks
delimiter |
Create Trigger time_update  
BEFORE INSERT ON repairorder 
FOR EACH ROW  
BEGIN  
IF NEW.repairDueDate is null 
THEN 
SET NEW.repairDueDate = DATE_ADD(new.dateRegister, INTERVAL 2 WEEK); 
END IF;
END;
|
delimiter ;  

INSERT INTO address 
VALUES (20134,'Hamburg','Hamburg'),
	   (50612,'Harburg','Berlin'),
       (40812,'Achim','Munich'),
	   (40334,'Alsdorf','Saxony'),
	   (50912,'Arnis','Thuringia');

INSERT INTO customer 
VALUES (1,'Ebere', 'Mike', 'ebere@yahoo.com','damtorstraße',2,20134, 0076945258 ,'M'),
(2,'Chinyere', 'Ngozi','chinyere@gmail.com','bieberstraße',3, 50612,0563452584 ,'F'),
(3,'Marc', 'Anthony', 'marc@yahoo.com','drosselstraße',2,40812,0896945254 , 'M'),
(4,'Chioma', 'Eric', 'chioma@gmail.uk','Steinstraße',7,50912,0576794525, 'F');

INSERT INTO department 
VALUES ('IT hardware',1, 'hardware repair'),
('IT software',2, 'software repair'),
('network',3, 'data recovery');

INSERT INTO employee 
VALUES (1,'Chinedu', 'Mike',0769452584,'damtorstraße',2,50912,45000,1,'M',1),
(2,'Chinedu',' Amara',0478452584,'Holenstraße',3,40334,60000,1,'F',2),
(3,'Michael', 'Eric', 0897694525,'Reepbahn',7,20134,30000,1,'M',3),
(4,'Blessing', 'Uche',0779492588,'lübeckerstraße',9,50612,70000,3,'M',1);

INSERT INTO phone 
VALUES (1234,'note5','infinix', 'Black','2weeks', 2,3),
(5678,'iphone12', 'Apple','white','2weeks',3,2),
(9114,'samsungA5', 'Samsung','blue','1weeks',1,1),
(5589,'camon17Pro', 'Tecno','blue','2weeks',1,4),
(4231,'pova2', 'Tecno','ash','1weeks',2,2);


INSERT INTO repairOrder 
VALUES (1, 'done', null,'2020-1-20',1,'Screen broken'),
(3,'in progress' ,null,'2020-6-27',1,'password not working'),
(2, 'pending',null ,'2020-3-10',2,'lost contact'),
(4, 'done',null ,'2020-3-10',2,'Phone is hanging'),
(5, 'in progress',null ,'2020-3-10',1,'phone not charging'),
(6, 'done', null,'2020-1-25',2,'screen blind'),
(7, 'done', null,'2020-1-25',1,'Screen dead'),
(8, 'done', '2020-5-30','2020-1-25',1,'phone overheating');


INSERT INTO invoice 
VALUES (1,2,'2020-6-27', 3400, 'cash'),
(2,3,'2020-4-27', 200, 'card'),
(3,1,'2020-1-2', 400, 'paypal'),
(4,5,'2020-10-2', 1000, 'cash'),
(5,4,'2020-06-20', 1500, 'card');

INSERT INTO repairChecklist 
VALUES (1,'screen'),(1,'batttery'),(1,'speaker'),(2,'charing mouth');

 INSERT INTO request
 VALUES (1,3,9114),(2,1,5678),(3,4,1234),(4,2,5589),(5,1,4231);
 
 #To view the name of customer and who is working on the phone
CREATE VIEW WORKS_ON AS
SELECT c.fname,c.lname, p.IMEi, p.model,p.brand,p.color, e.fname as emp_name,e.lname as emp_lname,e.dno as department_no,r.orderiD,i.amount
FROM phone as p,customer as c, employee as e,request r, invoice as i
WHERE p.cusID = c.ID AND e.eID = p.empID AND r.CID = c.ID AND i.invoiceID = r.orderID;
select * from WORKS_ON;
#To view all repaired phone
CREATE VIEW repaired_phone AS
SELECT p.IMEi, p.model,p.brand,p.color, o.repairStatus,r.orderiD
FROM phone as p, repairorder as o, request as r
WHERE p.IMEi = r.IMEi AND r.Orderid = o.Orderid AND o.repairStatus= 'done';
select *  from repaired_phone;

#To view all phone in working phase
CREATE VIEW phone_in_progress AS
SELECT p.IMEi, p.model,p.brand,p.color, o.repairStatus,d.DName,r.orderiD
FROM phone as p, repairorder as o, request as r,department as d
WHERE p.IMEi = r.IMEi AND r.Orderid = o.Orderid AND o.repairStatus= 'in progress'AND d.DNumber = o.DNumber;
select *  from phone_in_progress;

#To view all phone and there problems
CREATE VIEW phone_problem AS
SELECT p.IMEi, p.model,p.brand,p.color, o.repairStatus,r.orderiD,o.ProblemDescription
FROM phone as p, repairorder as o, request as r
WHERE p.IMEi = r.IMEi AND r.Orderid = o.Orderid;
SELECT * FROM phone_problem;
 
 #To generate invoice.
 SELECT c.fname,c.lname,c.phonenumber, i.amount,i.methodofPayment,i.dateDelivery FROM invoice as i
 JOIN customer as c
 WHERE c.id = i.invoiceID;
 
#To receive new order
 SELECT *,p.IMEi,p.model,p.brand,p.color FROM customer as c
 JOIN phone as p
 WHERE p.cusID = c.ID;
 
 #To view all phone in the store and their owners
 select c.fname,c.lname, p.IMEi, p.model,p.brand,p.color from phone as p
 JOIN customer as c on  p.cusID = c.ID
 WHERE p.cusID = c.ID;
 
 #To view phones and their date of collect
 select p.IMEi, p.model,p.brand,p.color from phone as p
 JOIN customer as c on  p.cusID = c.ID
 WHERE p.cusID = c.ID;
 
 #To view all request 
 select * from request;
 
 #To delete orders that are done
 #DELETE FROM phone WHERE    = ( select repairStatus from repairorder where  repairStatus = 'done');
 
 #To update table
UPDATE customer
SET fname= 'Zubby'
WHERE fname= 'Ebere';

select fname from customer; 

SELECT * FROM works_on;

#Updating view
UPDATE works_on
SET fname= 'Ebere'
WHERE fname= 'Zubby';

SELECT * FROM  repaired_phone;
SELECT * FROM  phone_in_progress;

#To determine number of order assigned to department
Select DName,count(orderid) as numberOfOrder From department as d
Join repairorder as r on r.DNumber = d.DNumber
group by d.DNumber;

#To determine the average cost to repair a phone
select AVG(amount) as avgCostForPhoneRepair from invoice;

SELECT * FROM employee;   

#To view minimum and maximum price used to repair a phone in the store
Select w.model, i.amount from invoice as i
join works_on as w on w.orderiD = i.repairOrderID
where i.amount = (select min(amount) from works_on)
union
Select w.model, i.amount from invoice as i
Right join works_on as w on w.orderiD = i.repairOrderID
where i.amount = (select max(amount) from works_on);

#TRANSACTION
START TRANSACTION;  
SELECT * FROM customer;  
INSERT INTO address  
VALUES (80902,'Bremen','Hessen');
INSERT INTO customer  
VALUES (5,'Frank', 'Mike', 'Omar@yahoo.com','sadenstraße',2,80902, 0566794972 ,'M');
SAVEPOINT save;  
INSERT INTO repairorder  
VALUES (9, 'open',null ,'2020-3-10',1,'phone is overheating');   
INSERT INTO invoice 
VALUES (6,5,'2020-07-30', 6000, 'paypal');
COMMIT; 
#ROLLBACK TO SAVEPOINT save;

select * from invoice;

START TRANSACTION;  
INSERT INTO employee 
VALUES (5,'Chidi', 'Emmauel',0812347834,'Messberg',2,50912,95000,2,'F',2); 
SAVEPOINT my_savepoint; 
INSERT INTO phone 
VALUES (1087,'Google pixel5','Google', 'green','2weeks', 4,4);
UPDATE phone SET color='Red' WHERE IMEi=5589;  
rollback;
#COMMIT;
select * from phone;

 #To delete orders that are done
 #DELETE FROM phone WHERE    = ( select repairStatus from repairorder where  repairStatus = 'done');

