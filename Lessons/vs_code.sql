SELECT 42 as answer;

SELECT *
FROM information_schema.tables;

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'data_jobs';

select * from job_postings_fact limit 10;

explain analyse
select 
    cd.name as company_name,
    count(jpf.job_id) as posting_count
from job_postings_fact jpf
left join company_dim cd
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name
having count(jpf.job_id) > 3000
order by posting_count desc
limit 10;

select job_title_short from job_postings_fact;
