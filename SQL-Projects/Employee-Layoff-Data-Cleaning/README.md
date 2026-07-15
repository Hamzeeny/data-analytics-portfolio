# Employee Layoff Data Cleaning — Technical Documentation

`SQL` `MySQL` `Data Cleaning` `Window Functions` `Self-Joins`

For the business context, see the [main portfolio README](../../README.md#-employee-layoff-data-cleaning).

## Dataset

A public dataset of global tech company layoffs, including company, location, industry, total employees laid off, percentage laid off, date, funding stage, country, and total funds raised.

## Approach

Rather than modifying the raw table directly, I worked entirely on staging copies (`layoffs_staging`, `layoffs_staging2`) to keep the original data intact and reversible at every step.

The cleaning followed four stages:
1. Remove duplicates
2. Standardize the data
3. Handle null/blank values
4. Remove unnecessary columns

## 1. Removing Duplicates

Since the table has no unique ID column, duplicates had to be identified using every relevant column together. I used `ROW_NUMBER()` partitioned across all columns (company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) to flag exact duplicate rows — anything with `row_num > 1` was a true duplicate, not just a same-company coincidence.

Since CTEs are temporary and can't be directly deleted from, I created a second staging table (`layoffs_staging2`) with an added `row_num` column, populated it using the same window function, then deleted every row where `row_num > 1`.

## 2. Standardizing the Data

- **Whitespace** — trimmed extra whitespace from the `company` column.
- **Industry naming** — found that "Crypto" was entered three different ways (e.g. "Crypto", "Crypto Currency", "CryptoCurrency"). Standardized all variants to a single `Crypto` value using a `LIKE 'Crypto%'` match.
- **Country naming** — found "United States" and "United States." (with a trailing period) as separate values. Used `TRIM(TRAILING '.' FROM country)` to unify them.
- **Date format** — the `date` column was stored as text in `MM/DD/YYYY` format. Converted it using `STR_TO_DATE(date, '%m/%d/%Y')`, then altered the column type from `TEXT` to `DATE`.

## 3. Handling Null / Blank Values

- Checked for rows missing both `total_laid_off` and `percentage_laid_off` — these are the two core metrics, so a row missing both carries no usable information.
- Checked for blank or null `industry` values. Found cases (e.g. Airbnb) where the same company had industry filled in on some rows but blank on others for the same location.
- Converted blank string industry values to proper `NULL` first, so they could be matched consistently.
- Used a **self-join** on `company` (and `location`) to identify rows where one entry had a null industry and another matching entry had a populated one, then updated the null rows using the matching non-null value from the same company.
- Deleted the remaining rows where both `total_laid_off` and `percentage_laid_off` were null, since these fields are essential and could not be reasonably recovered or inferred.

## 4. Removing Unnecessary Columns

Dropped the `row_num` helper column once deduplication was complete, since it was only needed temporarily to identify duplicates.

## Key Design Decisions

- Worked on staging tables throughout, never on the raw `layoffs` table, to preserve the original data.
- Used a **self-join** to backfill missing industry values rather than manually researching each company, since the answer already existed elsewhere in the same dataset.
- Chose to delete (rather than impute) rows missing both core layoff metrics, since there was no reliable way to estimate them and keeping them would misrepresent the dataset.

## Files in This Folder
- `data_cleaning_project.sql` — full SQL script with all cleaning steps in order

⬅️ [Back to main portfolio](../../README.md)
