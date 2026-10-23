# Local DB bootstrap

## Layout (run in this order)
- `db/ddl/`  - structure: database, schemas, search_path, tables. Numbered; run in order.
- `db/seed/` - initial bulk load: CSV files from `datasets/raw/csv/` into the existing tables.
- `db/dml/`  - hand-written SQL that changes rows after the seed load. Numbered; run in order.

## Prereqs
- PostgreSQL running locally

## 1. Apply DDL (in order)
1. Connected to `postgres`: run `db/ddl/000_create_database.sql` (once).
2. Connect to `sql_de_lab`.
3. Run `db/ddl/001_create_schemas.sql`.
4. Run `db/ddl/002_set_search_path.sql`.
5. Run `db/ddl/100_create_tables.sql`.

## 2. Seed data
Follow `db/seed/README.md`: DBeaver Import from `datasets/raw/csv/`
into the EXISTING tables created in step 1, mapped exactly as below:

tutorial schema:
- us_housing_units
- billboard_top_100_year_end
- aapl_historical_stock_price
- crunchbase_acquisitions
- crunchbase_companies
- crunchbase_investments
- crunchbase_investments_part1
- crunchbase_investments_part2

benn schema:
- college_football_players
- college_football_teams

**Note:** Table names must match exactly the list above; your SQL will then run unchanged.

## 3. DML (optional)
Run `db/dml/*.sql` in numeric order, if any.

## Roadmap (later)
- Scripted loader in `utils/` (`psql \copy`) for one-command rebuild.
- Add indexes/constraints once queries are validated for speed.