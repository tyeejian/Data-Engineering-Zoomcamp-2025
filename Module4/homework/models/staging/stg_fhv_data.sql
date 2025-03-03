{{
    config(
        materialized='view'
    )
}}


select
    *
from
    {{ source('staging', 'fhv_new')}}
where 
    dispatching_base_num is not null