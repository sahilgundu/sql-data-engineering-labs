# CSV load (DBeaver wizard)

1) Right-click schema (tutorial or benn) → Tools → Import Data…
2) Source: CSV → select file from `datasets/raw/csv/…`
3) Target: existing table (created by `db/ddl/100_create_tables.sql`); pick the exact **Schema** and **Table name** as per db/README.md.
4) Check "First row is header".
5) Review types (year/month -> INTEGER, numeric -> DOUBLE PRECISION, text -> TEXT).
6) Finish.

To reload: TRUNCATE the table, then re-import.
