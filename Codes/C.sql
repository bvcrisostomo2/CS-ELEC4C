DROP TABLE LETTERC;
create table LETTERC AS
(
	SELECT DEL.ROW_ID, DEL.ORDER_ID, DEL.ORDER_DATE, DEL.SHIP_DATE,  
    DEL.CITY AS LOCATION, 
    DEL.PRODUCT_NAME, 
    DEL.SALES, DEL.QUANTITY, DEL.DISCOUNT,DEL.PROFIT, 
    OTD.TIME_KEY,     
    OTD.PARENT_ID, 
    OTD.TIME_DESC
FROM DELIVERIES DEL 
RIGHT OUTER JOIN OSS_TIME_DIM OTD
ON 
	DEL.SHIP_DATE = OTD.TIME_DESC
);

DROP TABLE LET_C;
CREATE TABLE LET_C AS 
SELECT PARENT_ID AS MON, SUM(PROFIT) AS TOTAL_PROFIT FROM LETTERC WHERE  (SHIP_DATE LIKE '%2015' AND PARENT_ID LIKE 'M%') GROUP BY PARENT_ID ORDER BY TOTAL_PROFIT DESC;

SELECT * FROM LET_C;

SELECT * FROM(
SELECT MON,OTD.TIME_DESC, C1.TOTAL_PROFIT AS TOTAL_PROFIT FROM 
(LET_C C1 LEFT OUTER JOIN OSS_TIME_DIM OTD
ON C1.MON= OTD.TIME_KEY)
ORDER BY TOTAL_PROFIT DESC
)WHERE ROWNUM <=3; 