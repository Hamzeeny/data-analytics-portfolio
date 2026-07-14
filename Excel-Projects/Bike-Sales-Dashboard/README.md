# Bike Sales Dashboard — Technical Documentation

`Excel` `PivotTables` `PivotCharts` `Slicers`

For the business context and findings, see the [main portfolio README](../../README.md#-bike-sales-dashboard).

## Data Structure

The workbook contains three sheets:
- **Working Sheet** — raw customer data (demographics, income, occupation, commute distance, education, marital status, region, purchase status)
- **PivotTable** — pivot tables built from the working sheet, broken out by gender, age bracket, occupation, and commute distance
- **Dashboard** — the final interactive dashboard, built from the pivot tables and pivot charts

## Methodology

1. **Data cleaning** — reviewed the working sheet for blanks, inconsistent categorical labels (e.g. standardizing occupation and education entries), and verified data types before building pivots.
2. **Pivot tables** — created separate pivot tables for each dimension of analysis: income by gender, purchase count by age bracket, purchase count by commute distance, and purchase count by occupation and gender.
3. **Pivot charts** — built a chart for each pivot table (clustered column and line charts depending on which best showed the comparison).
4. **Slicers** — added slicers for Region, Marital Status, and Education so a user can filter the whole dashboard interactively by these dimensions without touching the underlying pivot tables.
5. **Dashboard layout** — arranged all charts and slicers onto a single sheet, sized and aligned for a clean, single-screen view.

## Key Design Decisions

- Used **PivotCharts directly linked to PivotTables** (rather than static charts) so the dashboard updates live when slicers are applied.
- Grouped age into brackets (Adolescent / Middle age / Old) rather than raw ages, since bracketed groups were more actionable for a marketing audience than a continuous age chart.
- Kept the dashboard to a single sheet to make it scannable — avoided asking users to flip between multiple tabs.

## Files in This Folder
- `bike-sales-dashboard.xlsx` — full workbook (raw data, pivot tables, dashboard)
- `dashboard-overview.png` — dashboard screenshot
- `dashboard-occupation.png` — occupation breakdown chart

⬅️ [Back to main portfolio](../../README.md)
