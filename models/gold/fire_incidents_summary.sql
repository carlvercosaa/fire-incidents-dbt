with fire_data as (
    select * from {{ ref('stg_fire_incidents') }}
)

select
    incident_year,
    incident_month,
    battalion,
    neighborhood_district,
    count(*) as total_incidents
from fire_data
group by 1, 2, 3, 4
order by incident_year, incident_month