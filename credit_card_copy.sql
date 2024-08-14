
CREATE TABLE credit_card_transaction (
    "Unnamed: 0" INT PRIMARY KEY,
    trans_date_trans_time TIMESTAMP,
    cc_num VARCHAR(255),
    merchant VARCHAR(255),
    category VARCHAR(255),
    amt DECIMAL(10, 2),
    first VARCHAR(255),
    last VARCHAR(255),
    gender VARCHAR(10),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(10),
    zip INT,
    lat DOUBLE PRECISION,
    long DOUBLE PRECISION,
    city_pop INT,
    job VARCHAR(255),
    dob DATE,
    trans_num VARCHAR(255),
    unix_time BIGINT,
    merch_lat DOUBLE PRECISION,
    merch_long DOUBLE PRECISION,
    is_fraud INT,
    merch_zipcode INT
);



COPY credit_card_transaction (
    "Unnamed: 0",
    trans_date_trans_time,
    cc_num,
    merchant,
    category,
    amt,
    first,
    last,
    gender,
    street,
    city,
    state,
    zip,
    lat,
    long,
    city_pop,
    job,
    dob,
    trans_num,
    unix_time,
    merch_lat,
    merch_long,
    is_fraud,
    merch_zipcode
)
FROM 'E:/credit_card_transactions.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE credit_card_copy1 (LIKE credit_card_transaction INCLUDING ALL)
	
INSERT INTO credit_card_copy1
SELECT * FROM credit_card_transaction;


SELECT COUNT(*) FROM credit_card_copy1

SELECT
    SUM(CASE WHEN credit_card_number IS NULL THEN 1 ELSE 0 END) AS credit_card_number_null_count,
    SUM(CASE WHEN merchant IS NULL THEN 1 ELSE 0 END) AS merchant_null_count,
    SUM(CASE WHEN merchant_category IS NULL THEN 1 ELSE 0 END) AS merchant_category_null_count,
    SUM(CASE WHEN transaction_amount IS NULL THEN 1 ELSE 0 END) AS transaction_amount_null_count,
    SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS first_name_null_count,
    SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS last_name_null_count,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_null_count,
    SUM(CASE WHEN street_address IS NULL THEN 1 ELSE 0 END) AS street_address_null_count,
    SUM(CASE WHEN city_name IS NULL THEN 1 ELSE 0 END) AS city_name_null_count,
    SUM(CASE WHEN state_name IS NULL THEN 1 ELSE 0 END) AS state_name_null_count,
    SUM(CASE WHEN zipcode IS NULL THEN 1 ELSE 0 END) AS zipcode_null_count,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) AS latitude_null_count,
    SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS longitude_null_count,
    SUM(CASE WHEN city_population IS NULL THEN 1 ELSE 0 END) AS city_population_null_count,
    SUM(CASE WHEN occupation IS NULL THEN 1 ELSE 0 END) AS occupation_null_count,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_null_count,
    SUM(CASE WHEN transaction_number IS NULL THEN 1 ELSE 0 END) AS transaction_number_null_count,
    SUM(CASE WHEN unix_time IS NULL THEN 1 ELSE 0 END) AS unix_time_null_count,
    SUM(CASE WHEN merchant_latitude IS NULL THEN 1 ELSE 0 END) AS merchant_latitude_null_count,
    SUM(CASE WHEN merchant_longitude IS NULL THEN 1 ELSE 0 END) AS merchant_longitude_null_count,
    SUM(CASE WHEN is_fraud IS NULL THEN 1 ELSE 0 END) AS is_fraud_null_count,
    SUM(CASE WHEN merchant_zipcode IS NULL THEN 1 ELSE 0 END) AS merchant_zipcode_null_count,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS transaction_date_null_count,
    SUM(CASE WHEN transaction_time IS NULL THEN 1 ELSE 0 END) AS transaction_time_null_count
FROM credit_card_copy1;

WITH deleted_rows AS (
    DELETE FROM credit_card_copy1
    WHERE merchant_zipcode IS NULL
    RETURNING *
)
SELECT COUNT(*) AS deleted_count
FROM deleted_rows;

SELECT * FROM credit_card_copy1;


--update gender column 
UPDATE credit_card_copy1
SET gender = CASE
WHEN gender = 'F' THEN 'female'
WHEN gender = 'M' THEN 'male'
ELSE gender
END;

ALTER TABLE credit_card_copy1
ALTER COLUMN transaction_time TYPE VARCHAR;

UPDATE credit_card_copy1
SET transaction_time = TO_CHAR(transaction_time::TIME, 'HH12:MI:SS AM');

 





