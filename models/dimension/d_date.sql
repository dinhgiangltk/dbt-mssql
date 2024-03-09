select
    "date",
    "year",
    "month",
    "day"
from {{ source("dimension", "calendar") }}