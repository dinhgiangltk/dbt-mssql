{% set query %}

select 
    [name] as col_name, 
    object_name([object_id]) as tbl_name
from sys.columns 
where 
    object_name([object_id]) in ('daily_cases','daily_deaths','daily_vaccinations','daily_hospital_admissions','daily_excess_mortality') and 
    [name] not in ('date', 'country')

{% endset %}

{% set dd_results = column_dictionary(query) %}

select
    daily_cases.date,
    daily_cases.country
    {% for k, v in dd_results.items() %}
    ,isnull({{ v }}.{{ k }}, 0) as {{ k }} {% endfor %}
from {{ source("fact", "daily_cases")}}
left join {{ source("fact", "daily_deaths") }}
on daily_cases.date = daily_deaths.date and daily_cases.country = daily_deaths.country
left join {{ source("fact", "daily_vaccinations") }}
on daily_cases.date = daily_vaccinations.date and daily_cases.country = daily_vaccinations.country
left join {{ source("fact", "daily_hospital_admissions") }}
on daily_cases.date = daily_hospital_admissions.date and daily_cases.country = daily_hospital_admissions.country
left join {{ source("fact", "daily_excess_mortality") }}
on daily_cases.date = daily_excess_mortality.date and daily_cases.country = daily_excess_mortality.country