-- Ross Nelson CSC352 Assignment 4
-- February 24th 2020

-- 1.
DECLARE
    TYPE TP1
        IS TABLE OF CHAR(1)
        INDEX BY BINARY_INTEGER;
    VP1 TP1;
    LETTER CHAR(1) := CHR(ASCII('A'));
    I NUMBER(2) := 0;
    
    --This variable determines the last letter to be included.
    STOP_LETTER CHAR(1) := CHR(ASCII('F'));
BEGIN
    WHILE CHR(ASCII(LETTER) - 1) != STOP_LETTER LOOP
        VP1(I) := LETTER;
        DBMS_OUTPUT.PUT_LINE(VP1(I));
        LETTER := CHR(ASCII(LETTER) + 1);
        I := I + 1;
    END LOOP;
END;
/

-- 2.
DECLARE
    TYPE ENAME_INCOME
        IS TABLE OF EMP.SAL%TYPE
        INDEX BY EMP.ENAME%TYPE;
    V_INCOME ENAME_INCOME;
    
    CURSOR C_INCOME IS
        SELECT ENAME, SAL, COMM
        FROM EMP;
    
    TOTAL_INCOME EMP.SAL%TYPE;
    
    I EMP.ENAME%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('This printout is in order of populating:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || 'Name' || CHR(9) || 'Income');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '----' || CHR(9) || '------');
    FOR EMP_REC IN C_INCOME LOOP
        TOTAL_INCOME := EMP_REC.SAL + NVL(EMP_REC.COMM, 0);
        
        V_INCOME(EMP_REC.ENAME) := TOTAL_INCOME;
        DBMS_OUTPUT.PUT_LINE(CHR(9) || EMP_REC.ENAME || CHR(9) || V_INCOME(EMP_REC.ENAME));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('This printout is in order of ENAME:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || 'Name' || CHR(9) || 'Income');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '----' || CHR(9) || '------');
    I := V_INCOME.FIRST;
    WHILE I IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(CHR(9) || TO_CHAR(I) || CHR(9) || V_INCOME(I));
        I := V_INCOME.NEXT(I);
    END LOOP;
END;
/

-- 3.
DECLARE
    TYPE TP2
        IS TABLE OF CHAR(1);
    VP2 TP2;
    
    I NUMBER (2);
    LEN NUMBER(2);
BEGIN
    VP2 := TP2('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');
    LEN := VP2.COUNT;
    
    --1. Print out the contents of this nested table
    DBMS_OUTPUT.PUT_LINE('Nested table contents:');
    I := 1;
    WHILE I <= LEN LOOP
        IF VP2.EXISTS(I) THEN
            DBMS_OUTPUT.PUT_LINE(CHR(9) || VP2(I));
        END IF;
        I := I + 1;
    END LOOP;
    
    --2. Display the count of this nested table
    DBMS_OUTPUT.PUT_LINE('Nested table count: ' || LEN);
    
    --3. Delete the elements from 3 to 4
    VP2.DELETE(3,4); 
    
    --4. Display the contents of the nested table after step 3
    DBMS_OUTPUT.PUT_LINE('Nested table contents (after delete):');
    I := 1;
    WHILE I <= LEN LOOP
        IF VP2.EXISTS(I) THEN
            DBMS_OUTPUT.PUT_LINE(CHR(9) || VP2(I));
        END IF;
        I := I + 1;
    END LOOP;
    
    --5. Based on completing step 3,
    --   display the value of the index that is next to index 2
    DBMS_OUTPUT.PUT_LINE('The value of the index next to index 2 is: ' ||
                         VP2.NEXT(2));
    
    --6. Print out how many elements are in this nested table now
    LEN := VP2.COUNT;
    DBMS_OUTPUT.PUT_LINE('Nested table count: ' || LEN);
END;
/

--4.
DECLARE
    TYPE VA_EMP_ENAME IS VARRAY(15)
        OF EMP.ENAME%TYPE;
    EMPS VA_EMP_ENAME := VA_EMP_ENAME();
    
    CURSOR C_EMP_ENAME IS
        SELECT ENAME
        FROM EMP
        WHERE DEPTNO = 20;
    
    LEN NUMBER(2);
    I NUMBER(2);
BEGIN
    -- Print out the contents of this Varray while populating
    DBMS_OUTPUT.PUT_LINE('This printout is in order of populating:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || 'Name');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '----');
    I := 1;
    FOR E IN C_EMP_ENAME LOOP
        EMPS.EXTEND;
        EMPS(I) := E.ENAME;
        DBMS_OUTPUT.PUT_LINE(CHR(9) || EMPS(I));
        I := I + 1;
    END LOOP;
    
    -- Display the maximum size of thisi Varray
    LEN := EMPS.LIMIT;
    DBMS_OUTPUT.PUT_LINE('Max size of Varray: ' || LEN);
    
    --Display the total number of the elements with populated values (value is not null)
    DBMS_OUTPUT.PUT_LINE('Total elements: ' || EMPS.COUNT);
    
    --Display the value of the last index
    DBMS_OUTPUT.PUT_LINE('Last index value: ' || EMPS(EMPS.LAST));
    
    --Print out all of the contents of this Varray (including null elements)
    DBMS_OUTPUT.PUT_LINE('This printout is all of the contents of this Varray:');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || 'Name');
    DBMS_OUTPUT.PUT_LINE(CHR(9) || '----');
    FOR I IN 1 .. LEN LOOP
        IF EMPS.EXISTS(I) THEN
            DBMS_OUTPUT.PUT_LINE(CHR(9) || EMPS(I));
        ELSE
            EMPS.EXTEND;
            DBMS_OUTPUT.PUT_LINE(CHR(9) || EMPS(I));
        END IF;
    END LOOP;
END;
/