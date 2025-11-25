
----------------------------------------------------------------------------------------------------------------------
SELECT * FROM BRIGHT_MOTORS.SALES_DATA.NEW LIMIT 10;
DESC TABLE BRIGHT_MOTORS.SALES_DATA.NEW;
-----------------------------------------------------------------------------------------------------------------------
--Revenue calculation
--SELLINGPRICE = revenue per car
-----------------------------------------------------------------------------------------------------------------------
USE DATABASE BRIGHT_MOTORS;
USE SCHEMA SALES_DATA;
-----------------------------------------------------------------------------------------------------------------------
--CLEANED TABLE
--We convert price + date fields

CREATE OR REPLACE TABLE BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES AS
SELECT
    YEAR::NUMBER AS YEAR,
    MAKE,
    MODEL,
    TRIM,
    BODY,
    TRANSMISSION,
    VIN,
    STATE,
    CONDITION,
    ODOMETER::NUMBER AS ODOMETER,
    COLOR,
    INTERIOR,
    SELLER,
    MMR::NUMBER AS MMR,
    SELLINGPRICE::NUMBER AS SELLINGPRICE,

    -- FIX SALEDATE: If numeric → NULL. If text → convert.
    CASE 
        WHEN REGEXP_LIKE(SALEDATE, '^[0-9]+$') THEN NULL
        ELSE TO_TIMESTAMP(SALEDATE, 'DY MON DD YYYY HH24:MI:SS')::DATE
    END AS SALEDATE

FROM BRIGHT_MOTORS.SALES_DATA.NEW;

-----------------------------------------------------------------------------------------------------------------------
--Creating Calculated Columns
--Mileage Category

ALTER TABLE BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES ADD COLUMN mileage_category STRING;

UPDATE BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES
SET mileage_category =
    CASE
        WHEN ODOMETER < 50000 THEN 'Low Mileage'
        WHEN ODOMETER BETWEEN 50000 AND 120000 THEN 'Medium Mileage'
        ELSE 'High Mileage'
    END;

-----------------------------------------------------------------------------------------------------------------------
--Price Difference from MMR (Market Price)

ALTER TABLE BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES ADD COLUMN price_vs_mmr NUMBER;

UPDATE BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES
SET price_vs_mmr = SELLINGPRICE - MMR;

-----------------------------------------------------------------------------------------------------------------------
--Profit Indicator (This shows if the sale was above market)

ALTER TABLE BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES ADD COLUMN sale_rating STRING;

UPDATE BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES
SET sale_rating =
    CASE
        WHEN price_vs_mmr > 0 THEN 'Above Market (Good Sale)'
        WHEN price_vs_mmr = 0 THEN 'At Market Value'
        ELSE 'Below Market (Undervalued)'
    END;

-----------------------------------------------------------------------------------------------------------------------
--Aggregated Tables
-----------------------------------------------------------------------------------------------------------------------
--Sales by Make

CREATE OR REPLACE TABLE AGG_SALES_BY_MAKE AS
SELECT
    MAKE,
    COUNT(*) AS total_cars_sold,
    AVG(SELLINGPRICE) AS avg_price,
    AVG(CONDITION) AS avg_condition
FROM BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES
GROUP BY MAKE;

-----------------------------------------------------------------------------------------------------------------------
--Sales by State

CREATE OR REPLACE TABLE AGG_SALES_BY_STATE AS
SELECT
    STATE,
    COUNT(*) AS total_sales,
    AVG(SELLINGPRICE) AS avg_price,
    AVG(MMR) AS avg_mmr
FROM BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES
GROUP BY STATE;

-----------------------------------------------------------------------------------------------------------------------
--Yearly Trend
CREATE OR REPLACE TABLE AGG_YEARLY_TRENDS AS
SELECT
    YEAR,
    COUNT(*) AS cars_sold,
    AVG(SELLINGPRICE) AS avg_selling_price
FROM BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES
GROUP BY YEAR
ORDER BY YEAR;

-----------------------------------------------------------------------------------------------------------------------
--Price vs Mileage

CREATE OR REPLACE TABLE AGG_MILEAGE_PRICE AS
SELECT
    mileage_category,
    AVG(SELLINGPRICE) AS avg_price,
    COUNT(*) AS total_cars
FROM BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES
GROUP BY mileage_category;

-----------------------------------------------------------------------------------------------------------------------
--FULL COMBINED CLEANING QUERY

USE DATABASE BRIGHT_MOTORS;
USE SCHEMA SALES_DATA;

CREATE OR REPLACE TABLE BRIGHT_MOTORS.SALES_DATA.CLEANED_CAR_SALES AS
SELECT
    YEAR::NUMBER AS YEAR,
    MAKE,
    MODEL,
    TRIM,
    BODY,
    TRANSMISSION,
    VIN,
    STATE,
    CONDITION::FLOAT AS CONDITION,
    ODOMETER::FLOAT AS ODOMETER,
    COLOR,
    INTERIOR,
    SELLER,
    MMR::FLOAT AS MMR,
    SELLINGPRICE::FLOAT AS SELLINGPRICE,

    /* Fix SALEDATE:
       - If numeric → NULL
       - If text → convert safely using TRY_TO_TIMESTAMP_NTZ
    */
    CASE 
        WHEN TRY_TO_NUMBER(SALEDATE) IS NOT NULL THEN NULL
        ELSE TRY_TO_TIMESTAMP_NTZ(SALEDATE)::DATE
    END AS SALEDATE,

    /* Mileage Category */
    CASE
        WHEN ODOMETER < 50000 THEN 'Low Mileage'
        WHEN ODOMETER BETWEEN 50000 AND 120000 THEN 'Medium Mileage'
        ELSE 'High Mileage'
    END AS MILEAGE_CATEGORY,

    /* Price difference from market value (MMR) */
    (SELLINGPRICE::FLOAT - MMR::FLOAT) AS PRICE_VS_MMR,

    /* Sale rating */
    CASE
        WHEN (SELLINGPRICE - MMR) > 0 THEN 'Above Market'
        WHEN (SELLINGPRICE - MMR) = 0 THEN 'At Market'
        ELSE 'Below Market'
    END AS SALE_RATING

FROM BRIGHT_MOTORS.SALES_DATA.NEW;


-----------------------------------------------------------------------------------------------------------------------


