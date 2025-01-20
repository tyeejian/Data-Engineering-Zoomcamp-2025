# This contains the answers to the homeword


## Question 1. Understanding docker first run 

Run docker with the `python:3.12.8` image in an interactive mode, use the entrypoint `bash`.

What's the version of `pip` in the image?

- 24.3.1


## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that **pgadmin** should use to connect to the postgres database?

- db:5432

## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:
1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles 
```sql
select
	'up to 1 mile' as "Desc",
	count(*)
from green_taxi_data
where trip_distance <= 1
union
select
	'1 mile to 3 miles' as "Desc",
	count(*)
from green_taxi_data
where 
trip_distance > 1
and trip_distance <= 3

union
select
	'3 mile to 7 miles' as "Desc",
	count(*)
from green_taxi_data
where 
trip_distance > 3
and trip_distance <= 7


union
select
	'7 mile to 10 miles' as "Desc",
	count(*)
from green_taxi_data
where 
trip_distance > 7
and trip_distance <= 10


union
select
	'more than 10 miles' as "Desc",
	count(*)
from green_taxi_data
where 
trip_distance > 10
```


- 104,838; 199,013; 109,645; 27,688; 35,202


## Question 4. Longest trip for each day


Which was the pick up day with the longest trip distance?
Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance. 

```sql
select
	cast(lpep_pickup_datetime as date) as "pickup_date",
	max(trip_distance) as "highest_distance_of_day"
from 
	green_taxi_data gtd,
	zone pu,
	zone dol
where
	gtd."PULocationID" = pu."LocationID" 
	AND gtd."DOLocationID" = dol."LocationID"
group by 
	"pickup_date"
order by 2 desc
```

- 2019-10-31


## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in
`total_amount` (across all trips) for 2019-10-18?

Consider only `lpep_pickup_datetime` when filtering by date.


```sql

select
	concat(pu."Borough", '/', pu."Zone") as "pickup_loc",
	sum(total_amount) as "total_amount"
from 
	green_taxi_data gtd,
	zone pu,
	zone dol
where
	gtd."PULocationID" = pu."LocationID" 
	AND gtd."DOLocationID" = dol."LocationID"
	AND cast(gtd.lpep_pickup_datetime as date) = '2019-10-18'
group by pickup_loc
having sum(total_amount) > 13000;
```

- East Harlem North, East Harlem South, Morningside Heights


## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone
name "East Harlem North" which was the drop off zone that had
the largest tip?

Note: it's `tip` , not `trip`

We need the name of the zone, not the ID.

```sql

select
	concat(dol."Borough", '/', dol."Zone") as "dropoff_loc",
	tip_amount
from 
	green_taxi_data gtd,
	zone pu,
	zone dol
where
	gtd."PULocationID" = pu."LocationID" 
	AND gtd."DOLocationID" = dol."LocationID"
	AND pu."Zone" = 'East Harlem North'
order by 2 desc
```

- JFK Airport


## Question 7. Terraform Workflow

Which of the following sequences, **respectively**, describes the workflow for: 
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:
- terraform init, terraform apply -auto-approve, terraform destroy