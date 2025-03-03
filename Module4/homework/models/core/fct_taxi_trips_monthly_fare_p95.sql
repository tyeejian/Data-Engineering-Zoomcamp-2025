{{
    config(
        materialized='view'
    )
}}


select 
distinct
    service_type,
    year,
    month,
    -- pickup_datetime,
    percentile_cont(fare_amount, 0.97) over (partition by service_type, year, month) as p97,

    percentile_cont(fare_amount, 0.95) over (partition by service_type, year, month) as p95,
    
    percentile_cont(fare_amount, 0.9) over (partition by service_type, year, month) as p90   
from
    {{ ref('fact_trips') }}
where 1=1
    and fare_amount > 0
    and trip_distance > 0
    and payment_type_description in ('Cash', 'Credit card')
    and year = 2020
    and month = 4