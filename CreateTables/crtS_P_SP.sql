REMARK   create  smaple tables   S ,  P ,  SP 

/* you can add comments in three different ways.
   as shown in these few lines                  */

set   echo on 
set   term on 

--  if "cascade constraints " is not used,
--   then  the order of dropping is important when foreign key are defined ; 

drop table   SP   ;      
drop table   S   cascade constraints;
drop table   P   cascade constraints;

create table S 
( S#        varchar2   (5) ,
  SNAME     varchar2   (15)   not null ,
  STATUS    number (3)  check ( status <= 50 ),
  CITY      varchar2   (15),
  primary   key   ( S# )    );

INSERT INTO S VALUES ( 'S1', 'Smith', 20,  'London' ) ;
INSERT INTO S VALUES ( 'S2', 'Jones', 10,  'Paris'  ) ;
INSERT INTO S VALUES ( 'S3', 'Blake', 30,  'Paris'  ) ;
INSERT INTO S VALUES ( 'S4', 'Clark', 20,  'London' ) ;
INSERT INTO S VALUES ( 'S5', 'Adams', 30,  'Athens' ) ;

commit ;

select * from S ;

create table P 
( P#        varchar2   (5) ,
  PNAME     varchar2   (15)   not null ,
  COLOR     varchar2   (7) ,            
  WEIGHT    number (6),
  CITY      varchar2   (15),
  primary   key  ( P# )    );

INSERT INTO P VALUES ( 'P1', 'Nut',    'Red',    12,  'London' ) ;
INSERT INTO P VALUES ( 'P2', 'Bolt',   'Green',  17,  'Paris'  ) ;
INSERT INTO P VALUES ( 'P3', 'Screw',  'Blue',   17,  'Rome'   ) ;
INSERT INTO P VALUES ( 'P4', 'Screw',  'Red',    14,  'London' ) ;
INSERT INTO P VALUES ( 'P5', 'Cam',    'Blue',   12,  'Paris'  ) ;
INSERT INTO P VALUES ( 'P6', 'Cog',    'Red',    19,  'London' ) ;

commit ;

select * from P ;

CREATE TABLE SP 
(
  S#     varchar2 (5)  ,
  P#     varchar2 (5)  ,
  QTY    number   (5)   ,
   constraint  pk_sp  primary key  ( S#, P# ) , 
   constraint  fk_sp_s foreign key  ( S# ) references S ,    
   constraint  fk_sp_p foreign key  ( P# ) references P ) ;
        

INSERT INTO SP VALUES  ( 'S1',  'P1',  300 ) ;
INSERT INTO SP VALUES  ( 'S1',  'P2',  200 ) ;
INSERT INTO SP VALUES  ( 'S1',  'P3',  400 ) ;
INSERT INTO SP VALUES  ( 'S1',  'P4',  200 ) ;
INSERT INTO SP VALUES  ( 'S1',  'P5',  100 ) ;
INSERT INTO SP VALUES  ( 'S1',  'P6',  100 ) ;
INSERT INTO SP VALUES  ( 'S2',  'P1',  300 ) ;
INSERT INTO SP VALUES  ( 'S2',  'P2',  400 ) ;
INSERT INTO SP VALUES  ( 'S3',  'P2',  200 ) ;
INSERT INTO SP VALUES  ( 'S4',  'P2',  200 ) ;
INSERT INTO SP VALUES  ( 'S4',  'P4',  300 ) ;
INSERT INTO SP VALUES  ( 'S4',  'P5',  400 ) ;

commit ;

select  * from SP ;



