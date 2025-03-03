{{
    config(
        materialized='view'
    )
}}


with trip_diff as (
    select
        *,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, second) as trip_duration
    from
        {{ ref('dim_fhv_trips') }}
) 
    select
        distinct
        year,
        month, 
        pickup_zone,
        dropoff_zone,
        percentile_cont(trip_duration, 0.9) over (partition by year, month, pickup_locationid, dropoff_locationid) p90
    from 
        trip_diff