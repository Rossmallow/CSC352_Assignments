-- Ross Nelson CSC352 Assignment 3
-- February 3rd 2020

-- 1.
--Drop TMEP_EMP if it already exists
DROP TABLE TEMP_EMP;

CREATE TABLE TEMP_EMP
AS SELECT * FROM EMP;

BEGIN
    DELETE FROM TEMP_EMP
    WHERE DEPTNO = 10;
    DBMS_OUTPUT.PUT_LINE ('Number of affected rows: ' || SQL%ROWCOUNT);
END;
/

-- 2.
DECLARE
    CURSOR C1 IS
        SELECT LAST_NAME 
        FROM EMPLOYEES;
    ENAME EMPLOYEES.LAST_NAME%TYPE;

BEGIN
    OPEN C1;
    --Move FETCH statement from line 34 to line 27
    FETCH C1 INTO ENAME;
    IF C1%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Yes, cursor C1 is found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No, cursor C1 is NOT found.');
    END IF;
    --FETCH C1 INTO ENAME;
    CLOSE C1;
END;
/

-- 3.
DECLARE
    CURSOR C2 IS
        SELECT LAST_NAME, SALARY
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 100;
    LNAME EMPLOYEES.LAST_NAME%TYPE;
    SAL EMPLOYEES.SALARY%TYPE;
    I NUMBER (1) := 3;
BEGIN
    OPEN C2;
    FOR I IN 1 .. 3 LOOP
        FETCH C2 INTO LNAME, SAL;
        DBMS_OUTPUT.PUT_LINE(LNAME || ' ' || SAL);
    END LOOP;
    CLOSE C2;
END;
/

-- 4.
/*
DECLARE
    CURSOR cemp  IS
     	SELECT   ename, sal
    	FROM     emp 
	WHERE	   deptno = 10
    	ORDER BY sal DESC;
    Emp_name   	emp.ename%TYPE; 	
    salary   	emp.sal%TYPE;
BEGIN
    OPEN cemp;
    LOOP
     	FETCH cemp INTO Emp_name, salary; 	
EXIT WHEN cemp%NOTFOUND;		
DBMS_OUTPUT.put_line 
 ('current row number is: '|| cemp%ROWCOUNT || 
   ':  ' || RPAD (emp_name, 10) || ': ' ||salary ||'.');
    END LOOP;
    CLOSE cemp;
END;
/
*/

--Output of code below should match the above commented code's output
DECLARE
    CURSOR C3 IS
        SELECT ENAME, SAL
        FROM EMP
        WHERE DEPTNO = 10
        ORDER BY SAL DESC;
BEGIN
    FOR EMPLOYEE IN C3 LOOP
        DBMS_OUTPUT.PUT_LINE
            ('Current row number is: ' || C3%ROWCOUNT ||
             ': ' || RPAD(EMPLOYEE.ENAME, 10) || ': ' || 
             EMPLOYEE.SAL || '.');
    END LOOP;
END;
/

-- 5.
DECLARE
    CURSOR C4 IS
        SELECT SALARY, COMMISSION_PCT
        FROM EMPLOYEES;
        
    EMP_SAL EMPLOYEES.SALARY%TYPE;
    INC EMPLOYEES.SALARY%TYPE;
    BONUS EMPLOYEES.SALARY%TYPE;
    TOTAL_BONUS EMPLOYEES.SALARY%TYPE := 0;
BEGIN
    FOR EMPLOYEE IN C4 LOOP
        EMP_SAL := EMPLOYEE.SALARY;
        INC := EMP_SAL + (NVL(EMPLOYEE.COMMISSION_PCT, 0) * EMP_SAL);
        IF (INC = EMP_SAL) THEN
            IF (INC >= 20000) THEN
                BONUS := 500;
            ELSIF (INC >= 10000) THEN
                BONUS := 600;
            ELSIF (INC > 0) THEN
                BONUS := 700;
            ELSE
                BONUS := 0;
            END IF;
            
        ELSE
            IF (INC >= 15000) THEN
                BONUS := 200;
            ELSIF (INC >= 10000) THEN
                BONUS := 300;
            ELSIF (INC >= 5000) THEN
                BONUS := 400;
            ELSIF (INC > 0) THEN
                BONUS := 500;
            ELSE
                BONUS := 0;
            END IF;
         END IF;
        TOTAL_BONUS := TOTAL_BONUS + BONUS;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('GROSS BOUNUSES: ' || TOTAL_BONUS);
END;
/

-- 6.
DECLARE
    CURSOR C5 (DEP_ID EMPLOYEES.DEPARTMENT_ID%TYPE) IS
        SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = DEP_ID;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Department 20:');
    FOR EMPLOYEE IN C5(20) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || EMPLOYEE.EMPLOYEE_ID || 
                             ' First name: ' || EMPLOYEE.FIRST_NAME || 
                             ' Last name: ' || EMPLOYEE.LAST_NAME);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(chr(10) || 'Department 90:');
    FOR EMPLOYEE IN C5(90) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || EMPLOYEE.EMPLOYEE_ID || 
                             ' First name: ' || EMPLOYEE.FIRST_NAME || 
                             ' Last name: ' || EMPLOYEE.LAST_NAME);
    END LOOP;
END;
/

-- 7.
DECLARE
    CURSOR C6 IS
        SELECT EMPNO, ENAME, SAL, COMM
        FROM TEMP_EMP
        WHERE SAL < 1000 AND NVL(COMM, 0) = 0
        FOR UPDATE OF SAL;
    
    OLD_SAL TEMP_EMP.SAL%TYPE;
    NEW_SAL TEMP_EMP.SAL%TYPE;
BEGIN
    FOR EMPLOYEE IN C6 LOOP
        OLD_SAL := EMPLOYEE.SAL;
        NEW_SAL := OLD_SAL + (OLD_SAL * 0.15);
        
        EMPLOYEE.SAL := NEW_SAL;
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || EMPLOYEE.EMPNO ||
                             ' Name: ' || EMPLOYEE.ENAME ||
                             ' New Salary: ' || EMPLOYEE.SAL ||
                             ' Old Salary: ' || OLD_SAL);
    END LOOP;
END;
/