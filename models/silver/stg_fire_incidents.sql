with source as (
    select * from public.raw_fire_incidents
),

-- Aplica deduplicação com row_number para garantir incident_number único
ranked as (
    select *,
        row_number() over (
            partition by "Incident Number"
            order by "Incident Date" desc
        ) as rn
    from source
),

-- Filtra apenas registros válidos: 1ª ocorrência de cada incidente, e sem nulos
filtered as (
    select *
    from ranked
    where rn = 1
      and "Incident Date" is not null
      and "neighborhood_district" is not null
)

-- Renomeia colunas e extrai novas colunas derivadas
select
    "Incident Number" as incident_number,
    "Incident Date"::date as incident_date,
    "Battalion" as battalion,
    "neighborhood_district" as neighborhood_district,
    extract(year from "Incident Date"::date) as incident_year,
    extract(month from "Incident Date"::date) as incident_month,
    extract(day from "Incident Date"::date) as incident_day
from filtered