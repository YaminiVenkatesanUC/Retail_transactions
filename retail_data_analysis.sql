
USE test_DB 

-- EDA

--select * from dbo.Retail_transactions_data where trans_date is null or tran_amount is null
--select count(DISTINCT(customer_id)) from dbo.Retail_transactions_data -- Row count -> 6889

--select max(trans_date) from dbo.Retail_transactions_data	-- Last purschased date in the table -> 2022-03-14
--select max(tran_amount) from dbo.Retail_transactions_data -- Maximum amount purschased -> 105

-- Query to return the RFM values --
SELECT customer_id, 
       DATEDIFF(DAY,MAX(trans_date),GETDATE()) as recent_trans_date,
       COUNT(*) as trans_count,
       AVG(tran_amount) as avg_amount
INTO temp
FROM dbo.[Retail_transactions_data]
GROUP BY customer_id
--SELECT * FROM temp
-- NTILE window function is used to split the 
-- customer ids into 2 equal buckets namely high and low
-- based on the recent transaction date, transaction count
-- by customer and average amount spent by each customer
SELECT customer_id, 
       NTILE(2) OVER (ORDER BY recent_trans_date ASC) AS R,
       NTILE(2) OVER (ORDER BY trans_count DESC) AS F,
       NTILE(2) OVER (ORDER BY avg_amount DESC) AS M
INTO temp2
FROM temp

SELECT customer_id, R*100 + F*10 + M AS rfm_number, 
CASE WHEN R = 2 and F = 2 and M = 2 THEN 'SUPERFANS'
	 WHEN R = 2 and F = 2 and M = 1 THEN 'LOYAL'
	 WHEN R = 2 and F = 1 and M = 2 THEN 'INFREQUENT SHOPPERS'
	 WHEN R = 2 and F = 1 and M = 1 THEN 'OTHER ACTIVE'
	 WHEN R = 1 and F = 1 and M = 1 THEN 'DEAD'
	 ELSE 'OTHERS'
END AS rfm_category
FROM temp2 
ORDER BY customer_id

-- Commands to drop the temporary table
DROP TABLE temp
DROP TABLE temp2

