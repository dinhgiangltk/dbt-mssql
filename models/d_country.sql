select
    country
from {{ source("dimension", "country") }}