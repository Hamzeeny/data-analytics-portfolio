# Marketing Data Cleaning & Title Optimization — Technical Documentation

`Excel` `Data Cleaning` `Formulas` `MODE.SNGL` `AVERAGEIF` `Text Functions`

For the business context, see the [main portfolio README](../../README.md#-marketing-data-cleaning--title-optimization).

## Dataset

A raw e-commerce product dataset containing 3,847 rows with product identifiers, titles, descriptions, bullet-point features, and product dimensions (`product_id`, `product_type_id`, `title`, `description`, `bullet_point`, `product_length`).

The workbook contains two sheets:
- **Original** — raw, unmodified source data
- **Cleaned** — cleaned data, with `_new` columns placed alongside each original field so before/after values can be compared directly in the same row

## Data Cleaning Process

### 1. Removing Duplicates
217 duplicate records were identified and removed using Excel's Remove Duplicates tool, ensuring each product entry is unique.

### 2. Handling Missing Values
A different strategy was used per column, based on the type of data it held — rather than one blanket approach for the whole dataset:

**Product Type ID (categorical)** — filled using the mode (most frequent value), to preserve the existing category distribution rather than introducing an arbitrary new category:
```excel
=IF(E2="", MODE.SNGL($E:$E), E2)
```

**Product Length (numeric)** — filled using a group-based average: the mean product length *within the same product category*, rather than a single dataset-wide average, so the imputed value stays realistic for that type of product:
```excel
=IF(I2="", AVERAGEIF($H:$H, H2, $I:$I), I2)
```

**Description (text, ~56% missing)** — given the high proportion of missing values, a conservative placeholder was used rather than attempting to fabricate content:
```excel
=IF(F2="", "No description available", F2)
```

**Bullet Point (text, ~39% missing)** — similarly handled with a standardized placeholder referencing the product title, to preserve usability without generating artificial content:
```excel
=IF(D2="", "Key features not provided - see product", D2)
```

### 3. Standardizing Data
Column names were converted to `snake_case` (e.g. `PRODUCTID` → `product_id`) for consistency.

### 4. Data Validation
The cleaned dataset was reviewed to confirm:
- No remaining duplicates
- No missing critical identifiers
- Proper formatting across numeric and text fields
- Logical consistency in values

## Short Title Creation

**Objective:** generate a concise, SEO-friendly version of each product title without losing essential product information.

**Methodology:**
- Used Excel text functions (`MID`, `LEFT`, `RIGHT`) to extract and reshape key portions of the original title
- Removed redundant words, product codes, and unnecessary symbols
- Limited titles to approximately 30–50 characters
- Retained the product name, product type, and key attributes (e.g. size, quantity, compatibility)
- Combined formula-based transformation with minor manual refinement where automation alone wasn't sufficient

**Examples:**

| Original Title | Short Title |
|---|---|
| ArtzFolio Tulip Flowers Blackout Curtain for Door, Window & Room \| Eyelets & Tie Back \| Canvas Fabric \| Width 4.5feet (54inch) Height 5 feet (60 inch); Set of 2 PCS | Tulip Flowers Blackout Curtain for Door, 2 pcs |
| Pooplu Womens Plain V Neck Half Sleeves Pack of 3 Combo Cotton Pink, Yellow, DarkPink T Shirt. Stylish, Casual Tshirts (_L) | Pooplu Womens Plain V Neck Half Sleeves - 3 color combo |
| Wacoal Women's Body By Wacoal Underwire Bra (38C, Red) | Wacoal Women's red underwire Bra - 38C |

## Key Design Decisions

- Used **different imputation strategies per column type** (mode for categorical, group-based mean for numeric, contextual placeholders for text) rather than a single generic fill method, to keep imputed values as realistic as possible for each field.
- Kept **original and cleaned values side-by-side** (via `_new` columns on the same sheet) rather than overwriting data directly, so every transformation remains auditable and reversible.
- Combined formulas with light manual refinement for short titles, since fully automated text truncation occasionally produced awkward cuts that needed a human pass for readability.

## Files in This Folder
- `marketing-data-cleaning.xlsx` — full workbook (Original and Cleaned sheets)
- `data-cleaning-title-optimization-report.pdf` — full write-up of methodology and findings

⬅️ [Back to main portfolio](../../README.md)
