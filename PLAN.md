# Plan

When adding a new page, use the following index.html starter:

https://raw.githubusercontent.com/ModelEarth/localsite/refs/heads/main/start/template/index.html

## TradeFlow

### Interstate Pipeline Integration

- Integrate BEA interstate generation into the normal TradeFlow pipeline, accounting for required inputs and API access.
- Validate and publish `interstate.csv` and `interstate_factor.csv` to `ModelEarth/trade-data`.
- Align Rust downloads and column mapping with the approved CSV format.
- Verify successful Azure imports and preserve compatibility with existing datasets where needed.

### Schema and Identifier Alignment

Align Python CSVs, Rust DDL/importer, Azure PostgreSQL, and Rust/JS schema fallbacks.

- Confirm the authoritative interstate format before changing the schema.
- Persist `interstate_id` in Rust/Azure if the current BEA format is adopted.
- Validate replacement keys before removing generic `BIGSERIAL id` columns.
- Remove obsolete generic `BIGSERIAL id` definitions from Rust for `trade`, `trade_factor`, `interstate`, and `interstate_factor`.
- Align Rust `trade_factor` parsing with `trade_id,factor_id,level`.
- Review schema changes with Gary/Loren before implementation.

### Primary Keys

| Table | Current / Candidate Primary Key |
| --- | --- |
| `industry` | `industry_id` — existing |
| `factor` | `factor_id` — existing |
| `trade` | `(trade_id, year, country, flow_type)` — validate duplicates/nulls |
| `trade_factor` | Not yet determined — historical records and nullable `coefficient` require further profiling |
| `interstate` | `interstate_id` or validated composite key — validate uniqueness |
| `interstate_factor` | `(interstate_id, factor_id)` — validate after parent key is finalized |

For `trade_factor`, the primary key remains unresolved. Historical Azure data contains differences across `level` and `coefficient`, while `coefficient` is also `NULL` for some records. Profile these combinations before selecting or enforcing a key.

### Conflict Handling

Use validated primary/unique keys to make repeated imports idempotent.

- Keep `ON CONFLICT ... DO NOTHING` for `industry`, `factor`, and `trade`.
- Determine the `trade_factor` key before defining its conflict behavior.
- Add appropriate conflict handling to `interstate` and `interstate_factor` after their keys/constraints are validated.
- Ensure every `ON CONFLICT` target has a corresponding PostgreSQL primary or unique constraint.

### Data Pipeline Automation

Automate TradeFlow data generation, validation, publication, and Azure PostgreSQL ingestion.

- Validate datasets before importing them.
- Verify imported data against source CSVs.
- Run profiling and change detection after successful imports.
- Record failures and support safe retries.

### Public Read-Only API

Work together to expose selected TradeFlow data from Azure PostgreSQL through a public read-only API.

- Provide read-only endpoints for approved data.
- Limit requests per visitor IP.
- Support data access for the TradeFlow UI and Abundance Engine.
- Keep database credentials and write operations private.

### Dataset Profiling

Generate a profile whenever a dataset is created or refreshed.

- Capture schema, row counts, nulls, duplicates, distinct values, numeric ranges, and candidate-key uniqueness.
- Check relationships between parent and factor tables for missing/orphaned records.
- Store profiles by dataset/year/run so they can be compared over time.
- Use profiling results to validate database constraints and determine forecast readiness.

### Change Detection

Compare each new profile with the previous available profile.

- Detect schema changes, significant row-count changes, new nulls/duplicates, key violations, distribution shifts, and broken relationships.
- Distinguish expected data refreshes from potential data-quality or pipeline regressions.
- Record detected changes with the affected field/metric and previous/current values.

### Forecasting

Evaluate forecast readiness before training models.

- Identify the target, time field, grouping dimensions, historical coverage, frequency, and forecast horizon.
- Require sufficient multi-year observations for chronological training and backtesting.
- Compare a baseline with suitable candidate models using metrics such as MAE/RMSE/MAPE where appropriate.
- Save predictions with model/version, training period, horizon, evaluation metrics, and confidence intervals where supported.
- Compare stored forecasts with future actual values as new data arrives.

The current pipeline processes a configured year per run, so building and validating sufficient multi-year history is a prerequisite for forecasting.

### Migration Safety

Before modifying the live Azure schema:

1. Confirm the intended interstate CSV format and validate representative files.
2. Profile replacement keys for uniqueness, nulls, duplicates, and orphaned records.
3. Add and validate replacement identifiers and constraints.
4. Update Rust import logic and foreign-key relationships.
5. Verify successful imports and data integrity.
6. Remove obsolete surrogate `id` columns only after replacement keys and dependencies work.

Do not delete or rewrite historical data solely to satisfy new constraints without investigating the cause. 