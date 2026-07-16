# Employee Layoff EDA — Technical Documentation

`SQL` `MySQL` `Exploratory Data Analysis` `Window Functions` `CTEs`

For the business context and full findings, see the [main portfolio README](../../README.md#-employee-layoff-eda).

## Dataset

This analysis builds directly on the cleaned dataset produced in the [Employee Layoff Data Cleaning](../Employee-Layoff-Data-Cleaning/README.md) project (`layoffs_staging2`). It spans March 2020–March 2023, covering 1,628 companies across 51 countries and 31 industries.

## Approach

The exploratory analysis moved from simple to more advanced queries, answering progressively deeper questions about the data.

### 1. Basic Exploration
- Identified the single largest layoff event by `total_laid_off` — Google's 2023 layoff of 12,000 people.
- Looked at the top 3 largest events in full detail to compare severity, not just headcount.
- Found the min/max range for both `total_laid_off` (3 to 12,000) and `percentage_laid_off` (0 to 1), to understand the full scale of the data.
- Filtered for companies with `percentage_laid_off = 1` (100% — full shutdown), ordered by funds raised, revealing 116 companies that failed entirely — several after raising significant funding (e.g. Britishvolt, Quibi, Katerra).
- Aggregated total layoffs per company across the whole dataset — Amazon led with 18,150 cumulative layoffs across multiple rounds, more than any single-event company.
- Found the earliest and latest dates in the dataset to establish the time range covered.

### 2. Aggregated Breakdowns
Used `GROUP BY` to summarize total layoffs across different dimensions: company, industry, country, year, and funding stage.

Note: `percentage_laid_off` was summed in some of these queries for reference, but flagged as not fully meaningful when aggregated this way, since it's a per-row/per-company-branch calculated ratio rather than an additive figure. This is corrected properly in the additional exploration queries below, using `AVG()` instead.

### 3. Time-Based Trends
- Broke down total layoffs by **month** using `MONTH(date)` — revealed January as the heaviest month overall.
- Grouped by **year-month** (`SUBSTRING(date, 1, 7)`) to get a cleaner monthly trend line, which showed that January's dominance was driven almost entirely by a single spike: January 2023 (84,714 layoffs).
- Built a **rolling monthly total** using a CTE and a window function:
  ```sql
  SUM(total_off) OVER (ORDER BY ym)
  ```
  This revealed two distinct waves: a sharp early spike in April–May 2020 (the initial pandemic shock), followed by a much larger, sustained climb from mid-2022 through early 2023 — the cumulative total closing at 383,159.

### 4. Company-Level Trends Over Time
Used a two-step CTE:
1. First CTE aggregates total layoffs per company per year.
2. Second CTE ranks companies within each year using `DENSE_RANK() OVER (PARTITION BY years ORDER BY total_off DESC)`.
3. Final query filters to `ranks <= 5`, producing a clean **top 5 companies by layoffs, per year**.

This showed the "worst" company changed every year: Uber (2020), Bytedance (2021), Meta (2022), Google (2023) — the crisis moved through different companies rather than being dominated by the same few giants throughout.

### 5. Additional Exploration
- **Industry by year** — grouped by `industry, YEAR(date)` to see whether different sectors peaked at different times. Confirmed: Transportation and Travel were hit hardest in 2020 (direct pandemic impact), while Consumer/Retail/Tech-adjacent sectors dominated by 2022–2023.
- **Average severity by stage** — used `AVG(percentage_laid_off)` grouped by `stage`, rather than `SUM`, since sum is dominated by how many companies exist at each stage. This revealed Seed-stage companies cut ~70% of staff on average when they had layoffs, versus ~14% for Post-IPO companies — a much sharper proportional impact on early-stage companies despite Post-IPO companies accounting for more total layoffs by volume.
- **Top industry per country** — same ranking pattern as the top-5-companies query, but partitioned by `country` and filtered to `ranks = 1 AND total_off IS NOT NULL` (the null filter removes ties where every row in that country/industry group had a missing `total_laid_off` value, which would otherwise produce a meaningless "top" result). This revealed that the hardest-hit industry varies significantly by country — India (Education), Netherlands (Healthcare), Brazil (Finance), Singapore (Crypto) — rather than following the global Consumer/Retail pattern uniformly.

## Key Design Decisions

- Used **`DENSE_RANK()` rather than `RANK()`** for both ranking queries so tied totals don't skip rank numbers or cause an incomplete top 5 / missing country entries.
- Used a **rolling sum window function** instead of just monthly totals, since a cumulative view better communicates the scale of the overall layoff trend over time than isolated monthly figures would.
- Switched from `SUM` to `AVG` for the stage-based percentage analysis, since summing a ratio across companies of very different sizes would have been misleading.
- Added an explicit `IS NOT NULL` filter on the final ranked query to exclude meaningless ties caused by missing underlying data, rather than presenting a "top industry" with no real number behind it.
- Removed exploratory/scratch queries (e.g. an intermediate company-per-year listing, and a one-off check for companies with exactly 12,000 laid off) once they were superseded by more useful ranked versions, to keep the final script focused on queries that produce real insight.

## Files in This Folder
- `mysql_data_exploratory_analysis.sql` — full SQL script with all exploratory queries in order

⬅️ [Back to main portfolio](../../README.md)
