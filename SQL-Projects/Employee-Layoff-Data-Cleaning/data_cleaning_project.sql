-- Data cleaning project


select *
from layoffs;

-- 1.remove duplicates
-- 2. Standardize the data
-- 3. Handle null or blank values
-- 4. Remove any columns

create table layoffs_staging
select * from layoffs;

-- REMOVE DUPLICATES
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, date) row_num
from layoffs_staging;

with layoff_duplicate as(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) row_num
from layoffs_staging
)
select *
from layoff_duplicate
where row_num >1;

select *
from layoffs_staging
where company = 'Casper';

-- create a new table and add column row_num since CTEs are temporary
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, 
percentage_laid_off, date, stage, country, funds_raised_millions) row_num
from layoffs_staging;

-- check the duplicates again
select *
from layoffs_staging2
where row_num > 1;

-- delete those duplicates
delete
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2
where row_num > 1;
-- not there again

select *
from layoffs_staging2;

-- STANDARDIZING DATA (finding issues and fixing them)
select distinct trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);
# we found that 3 different ways were used in writing crypto under the industry columnnnn


select distinct industry
from layoffs_staging2
order by 1; 

# checking those rows:
select *
from layoffs_staging2
where industry like 'Crypto%'; 

# updating the rows
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'; 
# DONE!!!!

SELECT distinct country
from layoffs_staging2
order by 1;

SELECT *
from layoffs_staging2
where country = 'united states.';

SELECT distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like '%United States%';

# change the date from text to date format
select date,
str_to_date(date, '%m/%d/%Y') new_date 
from layoffs_staging2;
# always use capital Y for year and small letters for months and days

-- changing the date to the correct format
update layoffs_staging2
set date = str_to_date(date, '%m/%d/%Y') ;

select *
from layoffs_staging2;

-- change dates data type from text to date
alter table layoffs_staging2
modify column date date;

--  checking for null values
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2
where industry is null
or industry = '';


select *
from layoffs_staging2
where company = 'airbnb';
-- we found that airbnb company is a "travel" industry, so, any airbnb company 
-- with missing industry value should be updated with 'travel'

-- self join to see same companies but missing industry
select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- change blank industry to null
update layoffs_staging2
set industry = null
where industry = '';

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

-- REMOVING
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

# we have to delete them because they are important columns and no rows should be  missing both
delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

-- dropping a column
alter table layoffs_staging2
drop column row_num; # we do not need it again



