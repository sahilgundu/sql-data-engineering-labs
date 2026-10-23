-- db/ddl/000_create_database.sql
-- Run ONCE, connected to database: postgres (not sql_de_lab).
-- CREATE DATABASE cannot run inside a transaction block: keep auto-commit ON.
-- PostgreSQL has no CREATE DATABASE IF NOT EXISTS; a rerun fails with
-- "already exists" - that is expected.
CREATE DATABASE sql_de_lab;