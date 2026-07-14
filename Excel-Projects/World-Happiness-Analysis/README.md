# World Happiness Analysis — Technical Documentation

`Excel` `Data Cleaning` `VLOOKUP` `Pivot Tables` `Data Consolidation`

For the business context and findings, see the [main portfolio README](../../README.md#-world-happiness-analysis).

## Dataset

World Happiness Report data spanning 2015–2019, originally provided across multiple separate sheets (one per year), with inconsistent structure year to year. Key indicators used: GDP per Capita, Social Support, Life Expectancy (Health), and Freedom.

## Data Cleaning & Consolidation

The raw data required significant cleanup before analysis:

- **Consolidation** — merged five separate yearly sheets into a single unified dataset to enable cross-year analysis.
- **Inconsistent naming** — standardized country names that varied across years (e.g. "Taiwan" vs. "Taiwan Province of China").
- **Missing values** — UAE's 2018 corruption score was missing; it was estimated using the average of the 2017 and 2019 values for that country.
- **Missing region column** — the 2017–2019 sheets did not include a region column at all. Regions were re-attached using a lookup against country names from years that did include region data.
- **Unmatched entry** — Gambia appeared only in the 2019 data and had no prior-year record to look up a region from, so its region was sourced externally and added manually.

## Methodology

1. Cleaned and consolidated all five years into one working dataset (`Data` sheet).
2. Built pivot tables to calculate average happiness score by region and by year.
3. Built pivot tables comparing GDP per Capita, Social Support, Life Expectancy, and Freedom across regions.
4. Created visualizations (line chart for happiness trends 2015–2019, bar charts for regional comparisons and factor comparisons) to answer the three guiding questions:
   - How has global happiness changed 2015–2019?
   - Which regions are the happiest?
   - What factors influence happiness?
5. Assembled key charts onto a summary dashboard sheet.

## Key Findings

- Global happiness levels remained relatively stable across the five-year period, with minimal fluctuation.
- Australia & New Zealand and North America consistently recorded the highest happiness scores; Sub-Saharan Africa consistently recorded the lowest.
- GDP per capita, social support, and life expectancy all showed positive associations with happiness scores.

## Limitations

- Dataset limited to 2015–2019; more recent trends aren't reflected.
- Region classifications were manually standardized where data was inconsistent or missing, introducing a small amount of subjectivity.
- Some missing values required estimation (e.g. UAE's 2018 corruption score) or external sourcing (e.g. Gambia's region), which could introduce minor inaccuracy.

## Files in This Folder
- `world-happiness-analysis.xlsx` — full workbook (raw/cleaned data, pivot tables, dashboard)
- `regional-trends.png` — regional happiness trend chart
- `regional-comparison.png` — average happiness score by region
- `factors-comparison.png` — comparison of happiness factors across regions

⬅️ [Back to main portfolio](../../README.md)
