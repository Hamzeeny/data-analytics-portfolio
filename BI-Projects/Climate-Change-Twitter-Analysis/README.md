# Climate Change Twitter Analysis — Technical Documentation

`PostgreSQL` `Power BI` `SQL Views` `Data Cleaning` `Geographic Analysis`

For the business context and full findings, see the [main portfolio README](../../README.md#-climate-change-twitter-analysis).

## Dataset

Over 15.7 million climate-related tweets (2006–2019), each including timestamp, coordinates, topic, sentiment score (-1 to 1), stance (believer/denier/neutral), gender, temperature deviation, and an aggressiveness label. A supporting global disaster dataset was used for year-level contextual comparison (no direct join, since the two datasets share no common key).

## Part 1: Data Ingestion & Quality Checks (PostgreSQL)

### Ingestion
The raw dataset was imported into a table (`climate_tweets_raw`) with **every column typed as `TEXT`** initially — a deliberate choice to avoid import failures from missing values or inconsistent formatting, with proper typing handled later in a cleaned view instead of at import time.

### Quality Checks
- **Row count and preview** confirmed the data loaded correctly (~15.7M rows).
- **Missing coordinates**: found ~10.4M records missing lat/lng, with both fields missing together in the same rows (not independently) — leaving ~5.3M usable rows for location-based analysis specifically, while all rows remained usable for non-geographic analysis.
- **Gender**: found the dataset skewed male, with 500,000+ undefined values.
- **Duplicates**: checked `id` for repeats using `GROUP BY ... HAVING COUNT(*) > 1` — none found.
- **Sentiment range**: verified all sentiment scores fell within the expected -1 to 1 range, and confirmed no missing sentiment values.
- **Stance and aggressiveness distributions**: initial checks showed believers dominate stance, and most tweets are not flagged aggressive — set up the deeper topic-level analysis that followed.

## Part 2: Cleaning & View-Based Transformation

Rather than modifying the raw table directly, a **cleaned view** (`vw_cleaned_tweets`) was created to handle typing and standardization:
- Converted `created_at` to `TIMESTAMP`, `lng`/`lat`/`sentiment`/`temperature_avg` to numeric types
- Standardized blank/null/`'undefined'` gender values to `'Unknown'`
- Extracted `tweet_year` from `created_at` for time-based grouping

This cleaned view became the single foundation for every subsequent analytical view, avoiding repeated type-casting logic across multiple queries.

### Analytical Views Built
| View | Purpose |
|---|---|
| `vw_cleaned_tweets` | Cleaned, typed base view |
| `vw_sentiment_trend` | Yearly tweet count and average sentiment |
| `vw_stance_trend` | Stance distribution by year |
| `vw_topic_aggression` | Topic-level aggression analysis |
| `vw_topic_stance` | Topic-level stance analysis |
| `vw_location_sentiment` | Location-based tweet volume and sentiment (rounded to 1 decimal place to group nearby coordinates and keep the map performant) |
| `vw_topic_stance_year` | Topic, stance, and year combined, for interactive dashboard filtering |

**Performance note:** since views execute against the underlying table each time they're queried, indexes were added directly on the raw table (`created_at`, `stance`, `topic`, `aggressiveness`) — not on the views themselves — to keep query times reasonable against a 15M+ row table.

**A real debugging moment worth documenting:** the first version of `vw_location_sentiment` used `ROUND(lat, 1)` directly and threw a type error, since `lat` was still text-derived at that point in the pipeline. The fix was to cast explicitly before rounding: `ROUND(lat::numeric, 1)`. This kind of cast-then-round pattern matters whenever a column's underlying type isn't guaranteed to already be numeric.

## Part 3: Analysis (Descriptive & Diagnostic)

**Descriptive:**
- Sentiment trend by year: tweet volume grew substantially over time, peaking in 2018; average sentiment stayed only slightly negative overall.
- Stance distribution: believers dominate (71.5%), followed by neutral (20.9%) and denier (7.5%).
- Aggressiveness: most tweets are not aggressive, but aggressive tweets still made up 28.7% of the total — a meaningful minority.

**Diagnostic:**
- Topic + aggression analysis: major topics (global stance, weather extremes, human intervention) dominate volume, but aggression rates vary meaningfully by topic — Politics and "Donald Trump versus Science" carried notably higher aggression shares.
- Topic + stance analysis: belief in climate change dominates across nearly every topic, though denier and neutral voices are present throughout — the conversation isn't fully one-sided even within "believer-majority" topics.
- Geographic analysis: performed only on the ~5.3M rows with valid coordinates, rounded to 1 decimal place to group nearby locations. Top single locations (e.g. Washington D.C., London, New York) each carried well over 100,000 tweets.
- Disaster comparison: tweet volume rose sharply over the period while global disaster occurrence stayed relatively flat year to year — indicating the growth in climate discourse tracks public awareness/media attention more than actual disaster frequency.

## Part 4: Power BI Dashboard (4 pages)

1. **Executive Summary** — KPI cards (15.79M tweets, -0.0047 avg sentiment, 4.53M aggressive tweets, 28.7% aggressive rate), sentiment trend, tweet volume trend, and disaster occurrence trend.
2. **Climate Stance Analysis** — 100% stacked stance-over-time chart, overall stance donut, and tweet volume by stance over time.
3. **Topic Analysis & Aggression Patterns** — stance distribution across top topics, aggressive vs. non-aggressive volume, and aggression rate by topic.
4. **Geographic Analysis** — a bubble map of tweet concentration by location, plus a ranked table of top locations by tweet volume and average sentiment.

## Key Design Decisions

- **Imported everything as `TEXT` first**, deferring type conversion to a cleaned view — a safer ingestion strategy for a large, messy dataset than trying to type-cast during import and risking failures.
- **Verified the task's stated date range against the actual data** (found 2006–2019, not 2008–2022) rather than assuming the brief was correct, and documented the discrepancy transparently in the final report.
- **Used views instead of materialized tables** for all transformations, keeping the pipeline reusable and auditable, while compensating for performance with targeted indexes on the raw table.
- **Rounded coordinates to 1 decimal place** for the location view — a deliberate trade-off sacrificing precise pinpoint location for map rendering performance and meaningful visual clustering.
- **Used the disaster dataset as contextual comparison only**, without forcing a direct join where no real key existed — avoiding a misleading or fabricated relationship between the two datasets.

## Files in This Folder
- `data_prep.sql` — full PostgreSQL script: ingestion, quality checks, cleaned view, and all analytical views
- `climate-change-twitter-dataset-analysis-report.pdf` — full written report and findings
- `dashboard.pdf` — exported Power BI dashboard (all 4 pages)
- `dashboard-executive-summary.png`, `dashboard-stance-analysis.png`, `dashboard-topic-aggression.png`, `dashboard-geographic-analysis.png` — individual dashboard page screenshots

⬅️ [Back to main portfolio](../../README.md)
