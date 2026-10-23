# dml/

Hand-written SQL that changes rows AFTER the seed load:
`INSERT ... SELECT`, `UPDATE`, `DELETE`, `MERGE` (data fixes, derived tables, cleanup).

Rule: loading CSV files into tables = `db/seed/`.
SQL run on data already loaded = `db/dml/`.

Files are numbered and run in order: `001_<what>.sql`, `002_<what>.sql`, ...