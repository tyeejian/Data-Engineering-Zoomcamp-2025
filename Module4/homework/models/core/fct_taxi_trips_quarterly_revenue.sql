{{
    config(
        materialized='view'
    )
}}

with quarterly_revenue as (
    select
        service_type,
        year_quarter,
        year,
        quarter,
        sum(total_amount) as revenue,
    from
        {{ ref('fact_trips') }}
    where 
        year in (2019, 2020)
    group by
        service_type, year_quarter, year, quarter
), 
quarterly_yoy_growth as (
    select
        main.service_type,
        main.year_quarter,
        main.year,
        main.quarter,
        main.revenue,
        ((main.revenue - coalesce(sub.revenue, 0)) / coalesce(sub.revenue, null)) as quarterly_yoy_growth
    from
        quarterly_revenue main
    left join
        quarterly_revenue sub
    on
        main.service_type = sub.service_type
        and main.quarter = sub.quarter
        and main.year - 1= sub.year
    
) select * from quarterly_yoy_growth