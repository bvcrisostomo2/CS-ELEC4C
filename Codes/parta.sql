CREATE TABLE OSS_TIME_DIM_0(time_id varchar2(4));
CREATE TABLE OSS_TIME_DIM_1(time_id varchar2(4));
CREATE TABLE OSS_TIME_DIM_2(time_id varchar2(4));
CREATE TABLE OSS_TIME_DIM_3(time_id varchar2(4));

--DROP TABLE OSS_TIME_DIM_0;
--DROP TABLE OSS_TIME_DIM_1;
--DROP TABLE OSS_TIME_DIM_2;
--DROP TABLE OSS_TIME_DIM_3;

execute MAPPING_PARTA();

SELECT * FROM OSS_TIME_DIM_0;


DECLARE
    CURSOR HC IS
    SELECT *
    FROM OSS_TIME_DIM;
    
    Dim OSS_TIME_DIM%ROWTYPE;
    InnerJoinStatement varchar2(1000);
    TableMax number;
    TableCounter number := 1;
    TableCounterr number := 2;
    ParentNo number;
    DescNo number;
BEGIN
    FOR i IN 0..3 LOOP
        EXECUTE IMMEDIATE ('DROP TABLE OSS_TIME_DIM_'||i);
    END LOOP;
    FOR I IN 0..3 LOOP
        TableMax := I + 2;
        ParentNo := I + 1;
        DescNo:= I + 2;
        InnerJoinStatement := InnerJoinStatement ||
                            'CREATE TABLE OSS_TIME_DIM_'||I||' AS
                            (
                            SELECT  hc1.time_key,
                                    hc1.time_level,
                                    hc'||ParentNo||'.parent_id,
                                    hc'||DescNo||'.time_desc 
                            FROM OSS_TIME_DIM HC'||TableCounter;
        WHILE (TableCounter < TableMax) LOOP
            TableCounterr := TableCounter + 1;
            InnerJoinStatement := InnerJoinStatement || 
                                ' INNER JOIN OSS_TIME_DIM HC'||TableCounterr||
                                ' ON (hc'||TableCounter||'.parent_id = hc'||TableCounterr||'.time_key)';
            TableCounter := TableCounter + 1;
        END LOOP;
        TableCounter := 1;
        EXECUTE IMMEDIATE (InnerJoinStatement || ')');
        InnerJoinStatement := '';
    END LOOP;
END;
/


  insert into oss_time_dim_0
      select * from oss_time_dim_1;
  insert into oss_time_dim_0
      select * from oss_time_dim_2;
  insert into oss_time_dim_0
      select * from oss_time_dim_3;