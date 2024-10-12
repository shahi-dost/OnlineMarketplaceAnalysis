
-- CREATE table campaign_response ( 
-- camp1_success int,
-- camp2_success int,
-- camp3_success int,
-- camp4_success int,
-- camp5_success int,
-- camp6_success int);

UPDATE campaign_response
SET camp1_success = (SELECT SUM(acceptedcmp1) FROM customer_info);

UPDATE campaign_response
SET camp2_success = (SELECT SUM(acceptedcmp2) FROM customer_info);

UPDATE campaign_response
SET camp3_success = (SELECT SUM(acceptedcmp3) FROM customer_info);

UPDATE campaign_response
SET camp4_success = (SELECT SUM(acceptedcmp4) FROM customer_info);

UPDATE campaign_response
SET camp5_success = (SELECT SUM(acceptedcmp5) FROM customer_info);

UPDATE campaign_response
SET camp6_success = (SELECT SUM(response) FROM customer_info);

select * from campaign_response;