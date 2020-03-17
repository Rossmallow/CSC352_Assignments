-- script to create sample tables in Oracle
REM @"path where this file locates in your machine\Oracle_DEPT_EMP_Bonus_Salgrade_crt.txt"
REM you need to physically find out the local path and replace the above "path".

DROP TABLE dept cascade constraints;
DROP TABLE emp  cascade constraints;

CREATE TABLE dept (  
  deptno     NUMBER(2,0),  
  dname      VARCHAR2(14),  
  loc        VARCHAR2(13),  
  CONSTRAINT n_pk_dept PRIMARY KEY (deptno)  
);

REM pay attention, that pk_dept was used in table department;

CREATE TABLE emp(  
  empno    NUMBER(4,0),  
  ename    VARCHAR2(10),  
  job      VARCHAR2(9),  
  mgr      NUMBER(4,0),  
  hiredate DATE,  
  sal      NUMBER(7,2),  
  comm     NUMBER(7,2),  
  deptno   NUMBER(2,0),  
  CONSTRAINT pk_emp PRIMARY KEY (empno),  
  CONSTRAINT fk_deptno FOREIGN KEY (deptno) REFERENCES dept (deptno)  
);

INSERT INTO dept VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept VALUES (40, 'OPERATIONS', 'BOSTON');
 
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'17-DEC-80',800,NULL,20);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'20-FEB-81',1600,300,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'22-FEB-81',1250,500,30);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'2-APR-81',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'28-SEP-81',1250,1400,30);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'1-MAY-81',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'9-JUN-81',2450,NULL,10);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'09-DEC-82',3000,NULL,20);
INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'17-NOV-81',5000,NULL,10);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'8-SEP-81',1500,0,30);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'12-JAN-83',1100,NULL,20);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'3-DEC-81',950,NULL,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'3-DEC-81',3000,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'23-JAN-82',1300,NULL,10);

commit;

/* DROP TABLE bonus;

CREATE TABLE bonus(
  ename VARCHAR2(10),
  job   VARCHAR2(9),
  sal   NUMBER,
  comm  NUMBER );
*/
 
DROP TABLE salgrade CASCADE CONSTRAINTS;
CREATE TABLE salgrade(
  grade NUMBER,
  losal NUMBER,
  hisal NUMBER );

INSERT INTO salgrade VALUES (1, 700,  1200);
INSERT INTO salgrade VALUES (2, 1201, 1400);
INSERT INTO salgrade VALUES (3, 1401, 2000);
INSERT INTO salgrade VALUES (4, 2001, 3000);
INSERT INTO salgrade VALUES (5, 3001, 9999);
 
commit;
