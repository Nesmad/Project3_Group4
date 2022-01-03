create database Bank_deposits;
use Bank_deposits ;

CREATE TABLE bank_deposits.fulltable;

SELECT * FROM bank_deposits.fulltable;

-- Rename columns in accordance with SQL syntax (unique IDs, no space)
ALTER TABLE `bank deposit - before encoding1` 
RENAME COLUMN MyUnknownColumn
TO id;

ALTER TABLE `bank deposit - before encoding1`
RENAME COLUMN `Subscription to deposit (target)`
TO target_subscription;

-- Copy the full dataset table to use with encoded csv and compare both tables
CREATE TABLE fulltable_enc
LIKE fulltable;

-- Split the table into smaller tables to store data in relevant categories (clients, banking profile, campaign)
CREATE TABLE clients
SELECT id, age, job, marital, education 
FROM `bank deposit - before encoding1`;

CREATE TABLE bk_profile
SELECT id, `default`, balance, housing, loan
FROM `bank deposit - before encoding1`;

CREATE TABLE campaign
SELECT id, contact, duration, previous, pdays, poutcome, target_subscription
FROM `bank deposit - before encoding1`;

-- Create temporary tables to test different queries
CREATE TEMPORARY TABLE bank_deposits.campaign_success
SELECT id AS client_id, age, job, marital, education, `default`, balance, housing, loan, contact, duration, pdays, previous
FROM `bank deposit - before encoding1`
WHERE target_subscription='yes'
AND poutcome='success'
ORDER BY previous ASC;

SELECT *
FROM bank_deposits.campaign_success;

DROP TEMPORARY TABLE bank_deposits.campaign_success;

select month, count(month) as monthly_sub 
from `bank deposit - before encoding1` 
where target_subscription like 'yes'
group by month order by monthly_sub desc;

select month, count(month) as monthly_sub, sum(duration) 
from `bank deposit - before encoding1`
where target_subscription like 'yes' 
group by month order by monthly_sub desc;

select age, round(((count(age)*100)/484), 0)  as percentage_sub_by_age ,avg(balance) 
from `bank deposit - before encoding1` 
where target_subscription like 'yes' 
group by age;

-- Client personal and banking profiles reaching target subscription with successful outcome on a previous contact
CREATE TABLE bank_deposits.clients_reached
SELECT id AS client_id, age, job, marital, education, `default`, balance, housing, loan, contact, duration, pdays, previous
FROM `bank deposit - before encoding1`
WHERE target_subscription='yes'
AND poutcome='success'
ORDER BY previous ASC;

SELECT count(client_id)
FROM bank_deposits.clients_reached;
-- 82 clients 

-- Run a few queries to analyze target banking profile (loan y/n, housing y/n) 
SELECT COUNT(id) AS client_count, loan
FROM `bank deposit - before encoding1`
WHERE target_subscription='yes' 
GROUP BY loan
ORDER BY COUNT(*) DESC;




