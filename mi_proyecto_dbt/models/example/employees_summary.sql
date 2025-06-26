select
    department,
    count(*) as total_employees
from {{ ref('employees')}}
group by department