{{
    config(
        materialized='table'
    )
}}


with dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
),
fhv_trips as (
    select
        *,
        extract(year from pickup_datetime) as year,
        extract(month from pickup_datetime) as month
    from
        {{ ref('stg_fhv_data') }}
)
select 
    dispatching_base_num,
    pickup_datetime,
    dropoff_datetime,
    year,
    month,
    pulocationid as pickup_locationid,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    dolocationid as dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone, 
    sr_flag,
    Affiliated_base_number
from fhv_trips trips
inner join dim_zones as pickup_zone
on trips.pulocationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on trips.dolocationid = dropoff_zone.locationid