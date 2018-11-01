set serveroutput on 

DECLARE
    CURSOR SS IS
    SELECT *
    FROM SUPER_STORE;
    
    CURSOR HC IS
    SELECT *
    FROM OSS_TIME_DIM
    ORDER BY time_id DESC;
    
    CURSOR HC0 IS
    SELECT *
    FROM OSS_TIME_DIM_0;

    CURSOR HC1 IS
    SELECT *
    FROM OSS_TIME_DIM_1;

    CURSOR HC2 IS
    SELECT *
    FROM OSS_TIME_DIM_2;

    CURSOR HC3 IS
    SELECT *
    FROM OSS_TIME_DIM_3;
    
    
    Dim OSS_TIME_DIM%ROWTYPE;
    Dim0 OSS_TIME_DIM_0%ROWTYPE;
    Dim1 OSS_TIME_DIM_1%ROWTYPE;
    Dim2 OSS_TIME_DIM_2%ROWTYPE;
    Dim3 OSS_TIME_DIM_3%ROWTYPE;
    ssds SUPER_STORE%ROWTYPE;
    
BEGIN
    EXECUTE IMMEDIATE ('DROP TABLE DELIVERIES_FACT');
                        
    EXECUTE IMMEDIATE ('CREATE TABLE DELIVERIES_FACT AS (
                        SELECT *
                        FROM SUPER_STORE)');

    EXECUTE IMMEDIATE ('ALTER TABLE DELIVERIES_FACT
                        ADD Da varchar2(10)');
    
    EXECUTE IMMEDIATE ('ALTER TABLE DELIVERIES_FACT
                        ADD WK varchar2(10)');
                        
    EXECUTE IMMEDIATE ('ALTER TABLE DELIVERIES_FACT
                        ADD BW varchar2(10)');
                         
    EXECUTE IMMEDIATE ('ALTER TABLE DELIVERIES_FACT
                        ADD Mo varchar2(10)');
                         
    EXECUTE IMMEDIATE ('ALTER TABLE DELIVERIES_FACT
                        ADD Qu varchar2(10)');
                         
    EXECUTE IMMEDIATE ('ALTER TABLE DELIVERIES_FACT
                        ADD HY varchar2(10)');
    
    EXECUTE IMMEDIATE ('ALTER TABLE DELIVERIES_FACT
                        ADD Ye varchar2(10)');
                        
    OPEN HC;
    LOOP 
        FETCH HC INTO Dim;
--        EXIT WHEN (Dim.TIME_LEVEL = 2);
        EXIT WHEN HC%NOTFOUND;
--        dbms_output.put_line('UPDATE DELIVERIES_FACT
--                            SET Ye='''||Dim.time_key||'''
--                            WHERE ship_date LIKE ''%'||Dim.time_desc||'''');
        IF (Dim.time_level = 6) THEN                            
            dbms_output.put_line('after LEVEL 6');
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Ye='''||Dim.time_key||'''
                                WHERE ship_date LIKE ''%'||Dim.time_desc||'''');
        ELSIF (Dim.time_level = 5) THEN             
            dbms_output.put_line('after LEVEL 5');
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET HY='''||Dim.time_key||'''
                                WHERE Ye='''||Dim.parent_id||'''');
        ELSIF (Dim.time_level = 4) THEN  
            dbms_output.put_line('after LEVEL 4');
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Qu='''||Dim.time_key||'''
                                WHERE HY='''||Dim.parent_id||'''');
        ELSIF (Dim.time_level = 3) THEN  
            dbms_output.put_line('after LEVEL 3');
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Mo='''||Dim.time_key||'''
                                WHERE Qu='''||Dim.parent_id||'''');         
        ELSIF (Dim.time_level = 0) THEN  
--            dbms_output.put_line('after LEVEL 0');
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Da='''||Dim.time_key||'''
                                WHERE ship_date='''||Dim.time_desc||'''');  
        END IF;
    END LOOP;
    dbms_output.put_line('after exit');
    CLOSE HC;
    
    OPEN HC0;
    LOOP
        FETCH HC0 INTO Dim0;
        EXIT WHEN HC0%NOTFOUND;
        IF (Dim0.parent_id LIKE '%M%') THEN
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Mo='''||Dim0.parent_id||'''
                                WHERE Da='''||Dim0.time_key||'''');
        ELSIF (Dim0.parent_id LIKE '%WK%') THEN
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Wk='''||Dim0.parent_id||'''
                                WHERE Da='''||Dim0.time_key||'''');
        END IF;
    END LOOP;
    CLOSE HC0;
    
    OPEN HC1;
    LOOP
        FETCH HC1 INTO Dim1;
        EXIT WHEN HC1%NOTFOUND;
        IF (Dim1.parent_id LIKE '%BW%') THEN
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Bw='''||Dim1.parent_id||'''
                                WHERE Da='''||Dim1.time_key||'''');
        END IF;
    END LOOP;
    CLOSE HC1;
    
    OPEN HC2;
    LOOP
        FETCH HC2 INTO Dim2;
        EXIT WHEN HC2%NOTFOUND;
        IF (Dim2.parent_id LIKE '%BW%') THEN
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Ho='''||Dim2.parent_id||'''
                                WHERE Da='''||Dim2.time_key||'''');
        END IF;
    END LOOP;
    CLOSE HC2;
    
    OPEN HC3;
    LOOP
        FETCH HC3 INTO Dim3;
        EXIT WHEN HC3%NOTFOUND;
        IF (Dim3.parent_id LIKE '%BW%') THEN
            EXECUTE IMMEDIATE ('UPDATE DELIVERIES_FACT
                                SET Bw='''||Dim3.parent_id||'''
                                WHERE Da='''||Dim3.time_key||'''');
        END IF;
    END LOOP;
    CLOSE HC3;
    
END;
/

SELECT * FROM DELIVERIES_FACT;