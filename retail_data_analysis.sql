
USE test_DB
-- EDA

--select * from dbo.Retail_transactions_data where trans_date is not null
--select count(DISTINCT(customer_id)) from dbo.Retail_transactions_data -- 6889

--select max(trans_date) from dbo.Retail_transactions_data	-- 14/03
--select max(tran_amount) from dbo.Retail_transactions_data -- 105

-- Query to return the RFM values --
select customer_id, 
       DATEDIFF(DAY,max(trans_date),GETDATE()) as recent_trans_date,
       count(*) as trans_count,
       avg(tran_amount) as avg_amount
into temp
from dbo.Retail_transactions_data
group by customer_id
select * from temp
select customer_id, 
       ntile(2) over (order by recent_trans_date ASC) as R,
       ntile(2) over (order by trans_count DESC) as F,
       ntile(2) over (order by avg_amount DESC) as M
INTO temp2
from temp

select customer_id, R*100 + F*10 + M as RFM_number, 
case when R = 2 and F = 2 and M = 2 THEN 'SUPERFANS'
	 when R = 2 and F = 2 and M = 1 THEN 'LOYAL'
	 when R = 2 and F = 1 and M = 2 THEN 'INFREQUENT SHOPPERS'
	 when R = 2 and F = 1 and M = 1 THEN 'OTHER ACTIVE'
	 when R = 1 and F = 1 and M = 1 THEN 'DEAD'
	 else 'OTHERS'
end as rfm_category
from temp2

-- Commands to drop the temporary table
DROP table temp
DROP table temp2

