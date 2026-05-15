select company, location, industry, total_laid_off
from layoffs_staging2
order by total_laid_off desc
limit 1;

select *
from layoffs_staging2
order by total_laid_off desc
limit 3;

select * 
from layoffs_staging2
where total_laid_off = 12000;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company 
order by 2 desc; -- order by column 2

select min(date), max(date)
from layoffs_staging2;

select industry, sum(total_laid_off), sum(percentage_laid_off)
from layoffs_staging2
group by industry 
order by 2 desc; 

select country, sum(total_laid_off), sum(percentage_laid_off)
from layoffs_staging2
group by country 
order by 2 desc;

select year(date), sum(total_laid_off), sum(percentage_laid_off)
from layoffs_staging2
group by year(date) 
order by 2 desc;

select stage, sum(total_laid_off), sum(percentage_laid_off)
from layoffs_staging2
group by stage 
order by 2 desc;
-- percentage_laid_off is not all that relevant since its calculated
-- based on indidvidual rows/company branch

select month(date) as month, sum(total_laid_off) # or use substring for month
from layoffs_staging2
group by month(date);
-- order by 2 desc;

select substring(date, 1,7) as 'year_month', sum(total_laid_off) as total_off
from layoffs_staging2
where substring(date, 1,7) is not null
group by substring(date, 1,7)
order by 1 asc;

with rolling_total as(
select substring(date, 1,7) ym, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(date, 1,7) is not null
group by ym
order by 1 asc
)

select ym, total_off, sum(total_off) over(order by ym) as rolling_total
from rolling_total;

select company, sum(total_laid_off) as total_off
from layoffs_staging2
group by company
order by 2 desc;

select company, year(date), sum(total_laid_off) as total_off
from layoffs_staging2
group by company, year(date)
order by company asc;

with company_year (company, years, total_off) as (
select company, year(date), sum(total_laid_off) as total_off
from layoffs_staging2
group by company, year(date)
), company_year_rank as (
select *, dense_rank() over (partition by years order by total_off desc) ranks
from company_year
where years is not null
)
select *
from company_year_rank
where ranks <=5
