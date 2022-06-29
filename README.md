# RFM analysis using the retail transactions data 

## Data exploration
The given retail data is available for the period May 2018 upto March 2022. The number of unique customer ids is 6889. The minimum and maximun amount purchased by a customer is 10 and 105.

## RFM analysis
The data is loaded into the SQL table using import flat file feature in SQL server management studio version 18.
The RFM analysis is done in SQL using the NTILE window function which splits the data into 2 equal buckets namely high and low values based on the recent transaction date, frequency of transactions and average amount spent by a customer. 
Based on the R, F, M value, SQL case clause is used to seggregate the customer into five segments as given in the data question below. 

![image](https://user-images.githubusercontent.com/53064369/176373432-bcbd1d8b-c6a1-4991-b9cd-6faf4fb00d1b.png)

