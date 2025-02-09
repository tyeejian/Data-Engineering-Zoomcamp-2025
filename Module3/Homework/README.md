## Question 1:
Question 1: What is count of records for the 2024 Yellow Taxi Data?

2024-01: 2,964,624
2024-02: 3,007,526
2024-03: 3,582,628
2024-04: 3,514,289
2024-05: 3,723,833
2024-06: 3,539,193

Total: 
- 20,332,093

## Question 2:
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br> 
What is the **estimated amount** of data that will be read when this query is executed on the External Table and the Table?

```sql
SELECT distinct PULocationID
from
(  (SELECT distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024_01_external`)
  UNION ALL
  (SELEct distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024_02_external`)
  UNION ALL
  (SELEct distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024_03_external`)
  UNION ALL
  (SELEct distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024_04_external`)
  UNION ALL
  (SELEct distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024_05_external`)
  UNION ALL
  (SELEct distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024_06_external`)
);

SELECT distinct PULocationID
from
(  (SELECT distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yello_tripdata_2024-01`)
  UNION ALL
  (SELEct distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_trip_2024-02`)
  UNION ALL
  (select distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-03`)
  UNION ALL
  (select distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-04`)
  UNION ALL
  (select distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-05`)
  UNION ALL
  (select distinct PULocationID FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-06`));
```


- 0 MB for the External Table and 155.12 MB for the Materialized Table


## Question 3:
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?

```sql

select PULocationID from `solid-authority-448207-q6.zoomcamp.yello_tripdata_2024-01`;

select PULocationID, DOLocationID from `solid-authority-448207-q6.zoomcamp.yello_tripdata_2024-01`;
```


- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires


## Question 4:
How many records have a fare_amount of 0?

```sql
SELECT sum(`total_count`)
from
(  (SELECT count(*) as `total_count` FROM `solid-authority-448207-q6.zoomcamp.yello_tripdata_2024-01` where fare_amount = 0)
  UNION ALL
  (SELEct count(*) as `total_count` FROM `solid-authority-448207-q6.zoomcamp.yellow_trip_2024-02` where fare_amount = 0)
  UNION ALL
  (select count(*) as `total_count` FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-03` where fare_amount = 0)
  UNION ALL
  (select count(*) as `total_count` FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-04`where fare_amount = 0 )
  UNION ALL
  (select count(*) as `total_count` FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-05` where fare_amount = 0)
  UNION ALL
  (select count(*) as `total_count` FROM `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-06` where fare_amount = 0)
  )
  ```
  - 8,333
  
## Question 5:
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)


```sql
create or replace table `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024_01_partition`
partition by date(tpep_dropoff_datetime)
cluster by VendorID as 
select * from `solid-authority-448207-q6.zoomcamp.yello_tripdata_2024-01`
```

- Partition by tpep_dropoff_datetime and Cluster on VendorID


## Question 6:
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime
2024-03-01 and 2024-03-15 (inclusive)</br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? </br>

Choose the answer which most closely matches.</br> 


```sql
-- 54.67MB
select distinct VendorID
from `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024-03`
where tpep_dropoff_datetime > '2024-03-01' 
  and tpep_dropoff_datetime <= '2024-03-15';

--26.83MB


select distinct VendorID
from `solid-authority-448207-q6.zoomcamp.yellow_tripdata_2024_03_partition`
where tpep_dropoff_datetime > '2024-03-01'
  and tpep_dropoff_datetime <= '2024-03-15';
```

- 310.31 MB for non-partitioned table and 285.64 MB for the partitioned table


## Question 7: 
Where is the data stored in the External Table you created?

- GCP Bucket

## Question 8:
It is best practice in Big Query to always cluster your data:

- False


## (Bonus: Not worth points) Question 9:
No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

- 0B estimated to read. BigQuery stores the metadata of the table, hence it already has the result of the number of rows of the table and doesn't require to scan the table again.