-- Ross Nelson CSC352 Final Exam
-- March 16, 2020

-- Part 1
BEGIN
    DBMS_OUTPUT.PUT_LINE('Part 1:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '1) T'); -- 1) T
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '2) T'); -- 2) T
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '3) T'); -- 3) T
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '4) T'); -- 4) T
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '5) T'); -- 5) T
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '6) T'); -- 6) T
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '7) T'); -- 7) T
END;
/

-- Part 2
BEGIN
    DBMS_OUTPUT.PUT_LINE('Part 2:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '1) C'); -- 1) C
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '2) C'); -- 2) C
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '3) E'); -- 3) E
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '4) B'); -- 4) B
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '5) C'); -- 5) C
END;
/

-- Part 3
-- 1)
DECLARE
    TYPE AA_EMP
        IS TABLE OF EMPLOYEES.SALARY%TYPE
        INDEX BY EMPLOYEES.LAST_NAME%TYPE;
    V_EMP AA_EMP;
    
    EMP EMPLOYEES%ROWTYPE;
    
    CURSOR C1 IS
        SELECT * INTO EMP
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 30;
    
    ILNAME EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Part 3:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '1)');
    
    FOR EMP_REC IN C1 LOOP
    
        ILNAME := SUBSTR(EMP_REC.FIRST_NAME, 1, 1) || '.' || EMP_REC.LAST_NAME;
        V_EMP(ILNAME) := EMP_REC.SALARY;
        
        DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || ILNAME || '          ' || CHR(9) || V_EMP(ILNAME));
    END LOOP;
END;
/

-- 2)
DECLARE
    TYPE R_EMP IS RECORD (
        ID      EMP.EMPNO%TYPE,
        NAME    EMP.ENAME%TYPE,
        SALARY  EMP.SAL%TYPE);
    REC R_EMP;
    
    EMPLOYEE EMP%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Part 3:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '2)');
    
    SELECT * INTO EMPLOYEE
    FROM EMP
    WHERE EMPNO = 7839;
    
    REC.ID := EMPLOYEE.EMPNO;
    REC.NAME := EMPLOYEE.ENAME;
    REC.SALARY := EMPLOYEE.SAL;
    
    DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || 'ID: ' || REC.ID || ' Name: ' || REC.NAME || ' Salary: ' || REC.SALARY);
END;
/

-- 3)
DECLARE
    EMPLOYEE EMP%ROWTYPE;

    CURSOR C2 IS
        SELECT * INTO EMPLOYEE
        FROM EMP;
        
    RATE NUMBER(3);  

PROCEDURE RAISE_RATE (SALARY IN EMP.SAL%TYPE,
                 COMMISSION IN EMP.COMM%TYPE,
                 RATE OUT NUMBER) IS
BEGIN
    IF (COMMISSION = 0) THEN
        IF (SALARY < 1000) THEN
            RATE := 3;
        ELSE
            RATE := 2;
        END IF;
    ELSE
        RATE := 1;
    END IF;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Part 3:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '3)');
    
    FOR EMP_REC IN C2 LOOP
        RAISE_RATE(EMP_REC.SAL, NVL(EMP_REC.COMM, 0), RATE);
        
        DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || 'ID: ' || EMP_REC.EMPNO || ' Name: ' || EMP_REC.ENAME ||
                             ' Salary Raise Percentage: ' || RATE || '%');
    END LOOP;
END;
/

-- 4)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Part 3:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '4)');
END;
/

-- Drops table SALGRADE_LOG so the script can be run again without error
DROP TABLE SALGRADE_LOG;

CREATE TABLE SALGRADE_LOG (
    GRADE           NUMBER,
    OLD_LOSAL       NUMBER,
    NEW_LOSAL       NUMBER,
    OLD_HISAL       NUMBER,
    NEW_HISAL       NUMBER,
    UPDATED_DATE    DATE,
    UPDATED_BY      VARCHAR2(15),
    ACTION          VARCHAR2(15));

CREATE OR REPLACE TRIGGER SALGRADE_TR
    AFTER INSERT OR DELETE OR UPDATE OF HISAL ON SALGRADE
    FOR EACH ROW
    
BEGIN
    IF INSERTING THEN
        INSERT INTO SALGRADE_LOG VALUES
            (:NEW.GRADE, :OLD.LOSAL, :NEW.LOSAL, :OLD.HISAL, :NEW.HISAL, SYSDATE, USER, 'INSERT');
    ELSIF DELETING THEN
        INSERT INTO SALGRADE_LOG VALUES
            (:OLD.GRADE, :OLD.LOSAL, :NEW.LOSAL, :OLD.HISAL, :NEW.HISAL, SYSDATE, USER, 'DELETE');
    ELSIF UPDATING('HISAL') THEN
        INSERT INTO SALGRADE_LOG VALUES
            (:NEW.GRADE, :OLD.LOSAL, :NEW.LOSAL, :OLD.HISAL, :NEW.HISAL, SYSDATE, USER, 'UPDATE');
    END IF;
END;
/

INSERT INTO SALGRADE
    VALUES (6, 314, 3141);
    
UPDATE SALGRADE
    SET HISAL = 31415
    WHERE GRADE = 6;
    
DELETE SALGRADE
    WHERE GRADE = 6;

SELECT * FROM SALGRADE_LOG;

--Rollback changes so the script can be run again without error
ROLLBACK;

-- 5)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Part 3:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '5)');
END;
/

CREATE OR REPLACE PACKAGE EMP_CAL AUTHID DEFINER AS
    FUNCTION CAL_BONUS (HIRE_DATE IN DATE) RETURN NUMBER;
    
    PROCEDURE EMP_OFF (EMPLOYEE_ID IN EMP.EMPNO%TYPE);
    PROCEDURE EMP_OFF (EMPLOYEE_NAME IN EMP.ENAME%TYPE);
END EMP_CAL;   
/

CREATE OR REPLACE PACKAGE BODY EMP_CAL AS
    YEARS_WORKED NUMBER;
    
    FUNCTION CAL_BONUS (HIRE_DATE IN DATE) RETURN NUMBER IS BONUS NUMBER;
    BEGIN
            YEARS_WORKED := FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12);
            
            IF YEARS_WORKED > 25 THEN
                BONUS := 0.03;
            ELSIF YEARS_WORKED < 1 THEN
                BONUS := 0;
            ELSE
                BONUS := 0.02;
            END IF;
            
            RETURN BONUS;
    END CAL_BONUS;
    
    PROCEDURE EMP_OFF(EMPLOYEE_ID IN EMP.EMPNO%TYPE) IS
    BEGIN
        DELETE FROM EMP
        WHERE EMPNO = EMPLOYEE_ID;
    END EMP_OFF;
    
    PROCEDURE EMP_OFF(EMPLOYEE_NAME IN EMP.ENAME%TYPE) IS
    BEGIN
        DELETE FROM EMP
        WHERE ENAME = EMPLOYEE_NAME;
    END EMP_OFF;
        
END EMP_CAL;
/

DECLARE
    EMPLOYEE_ID EMP.EMPNO%TYPE := 7839;
    EMPLOYEE EMP%ROWTYPE;
BEGIN
    SELECT * INTO EMPLOYEE
    FROM EMP
    WHERE EMPNO = EMPLOYEE_ID;
    
    DBMS_OUTPUT.PUT_LINE('Employee ' || EMPLOYEE_ID || ' Bonus: $' || EMP_CAL.CAL_BONUS(EMPLOYEE.HIREDATE) * EMPLOYEE.SAL);
    EMP_CAL.EMP_OFF(EMPLOYEE_ID);
    EMP_CAL.EMP_OFF('FORD');
END;
/

SELECT * FROM EMP;

--Rollback changes so the script can be run again without error
ROLLBACK;

-- 6)
DECLARE
    TYPE TB1
        IS TABLE OF EMPLOYEES.LAST_NAME%TYPE;
    VB1 TB1 := TB1();
    
    EMP EMPLOYEES%ROWTYPE;
    
    CURSOR C3 IS
        SELECT * INTO EMP
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 30 OR DEPARTMENT_ID = 60;
        
    I NUMBER(2) := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Part 3:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '6)');
    
    DBMS_OUTPUT.PUT_lINE(CHR(9) || CHR(9) || 'Nested table contents:');
    FOR E IN C3 LOOP
        VB1.EXTEND;
        VB1(I) := E.LAST_NAME;
        DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || CHR(9) || VB1(I));
        I := I + 1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(9) || CHR(9) || 'Total elements: ' || VB1.COUNT);
    VB1.DELETE(5,8);
    DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(9) || CHR(9) || 'The value next to index 4 is: ' || VB1.NEXT(4) || CHR(10));
    
    DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || 'Nested table contents:');
    I := 1;
    WHILE I <= VB1.COUNT LOOP
        IF VB1.EXISTS(I) THEN
            DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || CHR(9) || VB1(I));
        ELSE
            VB1.EXTEND;
        END IF;
        I := I + 1;
    END LOOP;
END;
/