/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

select *, 
row_number() over(order by median_salary desc) as ms_rnk,
row_number() over(order by demand_count desc) as dc_rnk,
row_number() over(order by median_salary desc) + row_number() over(order by demand_count desc) as rnk
from (
select 
    sd.skills,
    round(median(jpf.salary_year_avg)) as median_salary,
    count(jpf.job_id) as demand_count
from job_postings_fact jpf
inner join skills_job_dim sjd 
    on jpf.job_id = sjd.job_id
inner join skills_dim sd
    on sjd.skill_id = sd.skill_id
where jpf.job_title_short = 'Data Engineer' 
        and jpf.job_work_from_home = True
group by sd.skills
) t
order by rnk asc
limit 25;



select 
    sd.skills,
    round(median(jpf.salary_year_avg)) as median_salary,
    count(jpf.salary_year_avg) as demand_count,
    round(ln(count(jpf.salary_year_avg)),1) as ln_demand_count,
    round((median(jpf.salary_year_avg) * ln(count(jpf.salary_year_avg)))/1000000,2) as optimal_score
from job_postings_fact jpf
inner join skills_job_dim sjd 
    on jpf.job_id = sjd.job_id
inner join skills_dim sd
    on sjd.skill_id = sd.skill_id
where jpf.job_title_short = 'Data Engineer' 
        and jpf.job_work_from_home = True
        and jpf.salary_year_avg is not null
group by sd.skills
having count(jpf.job_id) > 100
order by optimal_score desc
limit 25;
