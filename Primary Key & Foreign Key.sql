-- Lets learn how primary key and foreign key works in MYsql.

create database key_prim;

use key_prim;

-- Creating table ineuron with Primary Key Constraint.

create table ineuron(
course_id int NOT NULL,
course_name varchar(60),
course_status varchar(40),
number_of_enro int ,
primary key(course_id));

insert into ineuron values(01 , 'FSDA','active',100);
insert into ineuron values(02 , 'FSDS','Not-Active',150);
select * from ineuron;

-- Creating table students_ineuron with Foreign Key constraint.
-- With the help of Foreign Key we can associate tables with Primary Key

create table students_ineuron(
student_id int ,
course_name varchar(60),
student_mail varchar(60),
student_status varchar(40),
course_id1 int,
foreign key(course_id1) references ineuron(course_id)); -- This query helps us to associate table with Primary Key table.

insert into students_ineuron values(101 , 'FSDA','siri@gmail.com','active',02),
(102 , 'FSDA','alexa@gmail.com','active',01),
(103 , 'FSDA','elon@gmail.com','active',02),
(104 , 'FSDA','john@gmail.com','active',01); 

-- IMP Note if Primary Key and Foreign Key values doesn't match then it will throw foreign key constraint error.
-- You should make sure that the values you are inseritng in Primary key and Foreign Key is same with associate columns.

select * from students_ineuron;

-- Let's create another table with Foreign Key Constraint.

create table payment(
course_name varchar(60),
course_id int ,
course_live_status varchar(60),
course_launch_date varchar(60),
foreign key(course_id) references ineuron(course_id));

insert into payment values ('FSDA',01,'Not-Active','7th aug'),
('FSBC',02,'Not-Active','11th aug'),
('FSDS',01,'Active','1st july');

insert into payment values ('FSDA',05,'Not-Active','7th aug'); 
-- Again if we are trying to insert different values than Primmary Key column in column which is holding
-- Foreign Key constraint then it's thowing an error. The values should be same as per Primary Key Column.

select * from payment;

-- We can create multiple Primary Key and multiple Foreign Key with Multiple tables.
-- A table can have multiple foreign keys in single table based on the requirement.
-- But a table cannot have multiple Primary Key in single table. 

create table class(
course_id int ,
class_name varchar(60),
class_topic varchar(60),
class_duration int ,
primary key(course_id),
foreign key(course_id) references ineuron(course_id));

Insert into class values(01,'ineuron','Data Analytics', 120);

select * from class;

alter table ineuron drop primary key; -- We Cannot drop primary key directly because of association of tables.

alter table class drop primary key;

alter table ineuron add constraint test_prim primary key(course_id,course_name);
-- A table cannot have multiple Primary Key in single table.


drop table ineuron; -- We cannot drop Parent table which is associate with Primary Key and Foreign Key.

drop table class; -- But we can drop Child table which is holding Foreign Key constraint.

create table test(
id int not null , 
name varchar(60),
email_id varchar(60),
mobile_no varchar(9),
address varchar(50));

-- Let's add Primary Key in existing table with the help of alter tabel statement.
alter table test add primary key(id);

alter table test drop primary key; -- Droping Primary Key constraint with the help of alter tabel statement.
								    -- This operation happen becuase there is no association of test table with any table.

alter table test add constraint test_prim primary key(id , email_id);

-- Let's explore Parent table and Child table relation.
-- Creating Parent table.
create table parent(
id int not null ,
primary key(id));

insert into parent values(1);
select * from parent;

-- Creating Child table.
create table child (
id int ,
parent_id int ,
foreign key (parent_id) references parent(id));

insert into child values(1,1);
insert into child values(2,1);

insert into child values(2,2); -- This Query will throw an error as we mention above due to different values in associate columns in tables.

select * from child;

insert into child values(2,2);

delete from parent where id =1; -- Parent table values cannot be deleted due to foreign key constraint.

delete from child where id =1; -- But Child table values would be deleted.

drop table child;

-- Let's create child table again but now with the help of cascade cause it will helps to perform various activities with parent table.

create table child (
id int ,
parent_id int ,
foreign key (parent_id) references parent(id) on delete cascade );

insert into child values(1,1),(1,2),(3,2),(2,2);
select * from child;

select * from parent;

delete from parent where id  = 1;
update parent set id = 3 where id = 2;

drop table child;

-- Let's create child table with the help of cascade operation.
-- With the help of cascade we can perform various queries with parent table.
-- Cascade helps to perform updation on parent table and it's also reflect to child table.

create table child (
id int ,
parent_id int ,
foreign key (parent_id) references parent(id) on update cascade ); -- we can also use on delete cascade for perform delete operation.
-- We can also perform on update cascade and on delete cascade operation together.

insert into child values(1,1),(1,1),(3,1),(2,1);

select * from child ; 

select * from parent;
insert into parent values(3);

update parent set id = 3 where id = 2; -- Updating Parent table values  with the  help of update statement.
insert into child values (2,3);