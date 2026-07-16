-- ============================================
-- Employee Layoff Exploratory Data Analysis
-- Builds on the cleaned dataset from the
-- Data Cleaning project (layoffs_staging2)
-- ============================================

-- 1. BASIC EXPLORATION
-- ------------------------------------------------

-- Find the single largest layoff event in the dataset
select company, location, industry, total_laid_off, year(date) year
from layoffs_staging2
order by total_laid_off desc
limit 1;

-- Look at the top 3 largest layoff events in full detail
select *
from layoffs_staging2
order by total_laid_off desc
limit 3;


-- Find the overall minimum and maximum values for total laid off and percentage laid off,
-- to understand the range/scale of the data
select min(total_laid_off), max(total_laid_off),
       min(percentage_laid_off), max(percentage_laid_off)
from layoffs_staging2;

-- Find companies that laid off 100% of staff (percentage_laid_off = 1),
-- i.e. companies that shut down entirely, ordered by how much funding they'd raised
-- (interesting to see well-funded companies that still failed completely)
select * 
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- Total layoffs per company, ranked highest first
select company, sum(total_laid_off)
from layoffs_staging2
group by company 
order by 2 desc; -- order by column 2 (sum of total_laid_off)

-- Find the earliest and latest dates in the dataset,
-- to know the full time range this data covers
select min(date), max(date)
from layoffs_staging2;


-- 2. AGGREGATED BREAKDOWNS BY CATEGORY
-- ------------------------------------------------

-- Total layoffs by industry, to see which sectors were hit hardest
select industry, sum(total_laid_off), sum(percentage_laid_off)
from layoffs_staging2
group by industry 
order by 2 desc; 

-- Total layoffs by country
select country, sum(total_laid_off), sum(percentage_laid_off)
from layoffs_staging2
group by country 
order by 2 desc;

-- Total layoffs by year, to see which year was worst overall
select year(date), sum(total_laid_off), sum(percentage_laid_off)
from layoffs_staging2
group by year(date) 
order by 2 desc;

-- Total layoffs by company funding stage (e.g. Series A, Post-IPO, etc.)
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage 
order by 2 desc;
-- Note: summing percentage_laid_off isn't fully meaningful here, since it's
-- a ratio calculated per row/company branch, not something that adds up cleanly


-- 3. TIME-BASED TRENDS
-- ------------------------------------------------

-- Total layoffs broken down by month (across all years combined)
select month(date) as month, sum(total_laid_off) # or use substring for month
from layoffs_staging2
group by month(date);
-- order by 2 desc;

-- Total layoffs broken down by year-month (e.g. '2022-06'),
-- giving a cleaner month-by-month trend line across the full time range
select substring(date, 1,7) as 'year_month', sum(total_laid_off) as total_off
from layoffs_staging2
where substring(date, 1,7) is not null
group by substring(date, 1,7)
order by 1 asc;

-- Build a rolling (cumulative) monthly total using a CTE and a window function,
-- so we can see how total layoffs built up over time rather than just
-- looking at isolated monthly figures
with rolling_total as(
select substring(date, 1,7) ym, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(date, 1,7) is not null
group by ym
order by 1 asc
)

select ym, total_off, sum(total_off) over(order by ym) as rolling_total
from rolling_total;


-- 4. COMPANY-LEVEL TRENDS OVER TIME
-- ------------------------------------------------

-- Total layoffs per company (same as earlier, reconfirming before the next step)
select company, sum(total_laid_off) as total_off
from layoffs_staging2
group by company
order by 2 desc;


-- Find the top 5 companies with the most layoffs, for each year individually
-- Step 1: aggregate total layoffs per company per year
-- Step 2: rank companies within each year using DENSE_RANK (so ties don't skip ranks)
-- Step 3: keep only the top 5 ranked companies per year
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
where ranks <=5;


-- 5. ADDITIONAL EXPLORATION
-- ------------------------------------------------

-- Total layoffs per industry, broken down by year,
-- to see whether different sectors peaked in different years
-- (e.g. did tech spike in 2022 while retail spiked in 2023?)
select industry, year(date) as years, sum(total_laid_off) as total_off
from layoffs_staging2
where industry is not null and year(date) is not null
group by industry, year(date)
order by years asc, total_off desc;

-- Average percentage laid off per funding stage (rather than sum, which is dominated by how many companies are in each stage) -
-- this shows whether, for example, early-stage startups tend to cut a much
-- larger share of their workforce than late-stage/post-IPO companies when they do lay off
select stage, avg(percentage_laid_off) as avg_percentage_laid_off
from layoffs_staging2
where stage is not null and percentage_laid_off is not null
group by stage
order by avg_percentage_laid_off desc;

-- Find the hardest-hit industry per country
-- Step 1: aggregate total layoffs per industry per country
-- Step 2: rank industries within each country using DENSE_RANK
-- Step 3: keep only the #1 ranked industry per country
with country_industry (country, industry, total_off) as (
select country, industry, sum(total_laid_off) as total_off
from layoffs_staging2
where country is not null and industry is not null
group by country, industry
), country_industry_rank as (
select *, dense_rank() over (partition by country order by total_off desc) ranks
from country_industry
)
select *
from country_industry_rank
where ranks = 1 and total_off IS NOT NULL
order by total_off desc;
 