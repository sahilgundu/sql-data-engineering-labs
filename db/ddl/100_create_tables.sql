-- db/ddl/100_create_tables.sql 

CREATE TABLE IF NOT EXISTS tutorial.us_housing_units (
  year        SMALLINT,
  month       SMALLINT,
  month_name  TEXT,
  south       INTEGER,
  west        INTEGER,
  midwest     INTEGER,
  northeast   INTEGER
);


CREATE TABLE IF NOT exists tutorial.billboard_top_100_year_end (
    year       SMALLINT      NOT NULL,
    year_rank  SMALLINT      NOT NULL,   -- 1..100
    group_name TEXT,
    artist     TEXT,
    song_name  TEXT,
    id         INTEGER
);


CREATE TABLE if not exists tutorial.aapl_historical_stock_price (
  date    DATE,
  year    SMALLINT,
  month   SMALLINT,
  open    DOUBLE PRECISION,
  high    DOUBLE PRECISION,
  low     DOUBLE PRECISION,
  close   DOUBLE PRECISION,
  volume  BIGINT,
  id      INTEGER
);


CREATE TABLE IF NOT EXISTS tutorial.crunchbase_companies (
  permalink           TEXT,
  name                TEXT,
  homepage_url        TEXT,
  category_code       TEXT,
  funding_total_usd   BIGINT,          -- e.g., 7,000,000 fits; BIGINT is safer
  status              TEXT,            -- operating, closed, …
  country_code        TEXT,            -- ISO like 'USA'
  state_code          TEXT,            -- e.g., 'CA'
  region              TEXT,            -- e.g., 'SF Bay'
  city                TEXT,
  funding_rounds      INTEGER,
  founded_at          DATE,            -- CSV like 1/1/13 → map to DATE
  founded_month       TEXT,            -- e.g., '2013-01'
  founded_quarter     TEXT,            -- e.g., '2013-Q1'
  founded_year        SMALLINT,
  first_funding_at    DATE,
  last_funding_at     DATE,
  last_milestone_at   DATE,
  id                  INTEGER
);



CREATE TABLE IF NOT EXISTS tutorial.crunchbase_acquisitions (
  company_permalink        TEXT,
  company_name             TEXT,
  company_category_code    TEXT,
  company_country_code     TEXT,
  company_state_code       TEXT,
  company_region           TEXT,
  company_city             TEXT,

  acquirer_permalink       TEXT,
  acquirer_name            TEXT,
  acquirer_category_code   TEXT,
  acquirer_country_code    TEXT,
  acquirer_state_code      TEXT,
  acquirer_region          TEXT,
  acquirer_city            TEXT,

  acquired_at              TEXT,      -- keep as text; cast later if needed
  acquired_month           TEXT,      -- e.g. '2013-10'
  acquired_quarter         TEXT,      -- e.g. '2013-Q4'
  acquired_year            INTEGER,

  price_amount             BIGINT,
  price_currency_code      TEXT,
  id                       INTEGER
);


CREATE TABLE IF NOT EXISTS tutorial.crunchbase_investments (
  company_permalink        TEXT,
  company_name             TEXT,
  company_category_code    TEXT,
  company_country_code     TEXT,
  company_state_code       TEXT,
  company_region           TEXT,
  company_city             TEXT,

  investor_permalink       TEXT,
  investor_name            TEXT,
  investor_category_code   TEXT,
  investor_country_code    TEXT,
  investor_state_code      TEXT,
  investor_region          TEXT,
  investor_city            TEXT,

  funding_round_type       TEXT,
  funded_at                TEXT,              -- keep raw (e.g., 9/26/13)
  funded_month             TEXT,              -- e.g., 2013-09
  funded_quarter           TEXT,              -- e.g., 2013-Q3
  funded_year              SMALLINT,
  raised_amount_usd        DOUBLE PRECISION,
  id                       INTEGER
);


CREATE TABLE IF NOT EXISTS tutorial.crunchbase_investments_part1 (
  company_permalink        TEXT,
  company_name             TEXT,
  company_category_code    TEXT,
  company_country_code     TEXT,
  company_state_code       TEXT,
  company_region           TEXT,
  company_city             TEXT,
  investor_permalink       TEXT,
  investor_name            TEXT,
  investor_category_code   TEXT,
  investor_country_code    TEXT,
  investor_state_code      TEXT,
  investor_region          TEXT,
  investor_city            TEXT,
  funding_round_type       TEXT,
  funded_at                TEXT,              -- raw date string (e.g., 9/26/13)
  funded_month             TEXT,              -- e.g., 2013-09
  funded_quarter           TEXT,              -- e.g., 2013-Q3
  funded_year              SMALLINT,
  raised_amount_usd        DOUBLE PRECISION,
  id                       INTEGER
);



CREATE TABLE IF NOT EXISTS tutorial.crunchbase_investments_part2 (
  company_permalink        TEXT,
  company_name             TEXT,
  company_category_code    TEXT,
  company_country_code     TEXT,
  company_state_code       TEXT,
  company_region           TEXT,
  company_city             TEXT,
  investor_permalink       TEXT,
  investor_name            TEXT,
  investor_category_code   TEXT,
  investor_country_code    TEXT,
  investor_state_code      TEXT,
  investor_region          TEXT,
  investor_city            TEXT,
  funding_round_type       TEXT,
  funded_at                TEXT,              -- raw date string
  funded_month             TEXT,              -- e.g., 2013-09
  funded_quarter           TEXT,              -- e.g., 2013-Q3
  funded_year              SMALLINT,
  raised_amount_usd        DOUBLE PRECISION,
  id                       INTEGER
);



CREATE TABLE IF NOT EXISTS benn.college_football_players (
  full_school_name TEXT,
  school_name      TEXT,
  player_name      TEXT,
  position         TEXT,
  height           INTEGER,
  weight           INTEGER,
  year             INTEGER,
  hometown         TEXT,
  state            TEXT,      -- keep TEXT to avoid case/length surprises
  id               INTEGER
);


--ALTER TABLE benn.college_football_players
--  ALTER COLUMN year TYPE TEXT;



CREATE TABLE IF NOT EXISTS benn.college_football_teams (
  division     TEXT,
  conference   TEXT,
  school_name  TEXT,
  roster_url   TEXT,
  id           INTEGER  -- add PRIMARY KEY(id) if it's unique
);


-- Verification of tables - 

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema='benn' AND table_name='college_football_teams'
ORDER BY ordinal_position;

select COUNT(*)
from benn.college_football_teams;

select *
from benn.college_football_teams;

SELECT COUNT(*) AS column_count
FROM information_schema.columns
WHERE table_schema = 'benn'
  AND table_name   = 'college_football_teams';


create table IF NOT EXISTS employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

-- 24 rows

--insert into employee values(101, 'Mohan', 'Admin', 4000);
--insert into employee values(102, 'Rajkumar', 'HR', 3000);
--insert into employee values(103, 'Akbar', 'IT', 4000);
--insert into employee values(104, 'Dorvin', 'Finance', 6500);
--insert into employee values(105, 'Rohit', 'HR', 3000);
--insert into employee values(106, 'Rajesh',  'Finance', 5000);
--insert into employee values(107, 'Preet', 'HR', 7000);
--insert into employee values(108, 'Maryam', 'Admin', 4000);
--insert into employee values(109, 'Sanjay', 'IT', 6500);
--insert into employee values(110, 'Vasudha', 'IT', 7000);
--insert into employee values(111, 'Melinda', 'IT', 8000);
--insert into employee values(112, 'Komal', 'IT', 10000);
--insert into employee values(113, 'Gautham', 'Admin', 2000);
--insert into employee values(114, 'Manisha', 'HR', 3000);
--insert into employee values(115, 'Chandni', 'IT', 4500);
--insert into employee values(116, 'Satya', 'Finance', 6500);
--insert into employee values(117, 'Adarsh', 'HR', 3500);
--insert into employee values(118, 'Tejaswi', 'Finance', 5500);
--insert into employee values(119, 'Cory', 'HR', 8000);
--insert into employee values(120, 'Monica', 'Admin', 5000);
--insert into employee values(121, 'Rosalin', 'IT', 6000);
--insert into employee values(122, 'Ibrahim', 'IT', 8000);
--insert into employee values(123, 'Vikram', 'IT', 8000);
--insert into employee values(124, 'Dheeraj', 'IT', 11000);


create table IF NOT EXISTS emp
( emp_ID int
, emp_NAME varchar(50)
, SALARY int);


--insert into emp values(101, 'Mohan', 40000);
--insert into emp values(102, 'James', 50000);
--insert into emp values(103, 'Robin', 60000);
--insert into emp values(104, 'Carol', 70000);
--insert into emp values(105, 'Alice', 80000);
--insert into emp values(106, 'Jimmy', 90000);

COMMIT;

create table IF NOT EXISTS customer.sales
(
	store_id  		int,
	store_name  	varchar(50),
	product			varchar(50),
	quantity		int,
	cost			int
);


--insert into customer.sales values
--(1, 'Apple Originals 1','iPhone 12 Pro', 1, 1000),
--(1, 'Apple Originals 1','MacBook pro 13', 3, 2000),
--(1, 'Apple Originals 1','AirPods Pro', 2, 280),
--(2, 'Apple Originals 2','iPhone 12 Pro', 2, 1000),
--(3, 'Apple Originals 3','iPhone 12 Pro', 1, 1000),
--(3, 'Apple Originals 3','MacBook pro 13', 1, 2000),
--(3, 'Apple Originals 3','MacBook Air', 4, 1100),
--(3, 'Apple Originals 3','iPhone 12', 2, 1000),
--(3, 'Apple Originals 3','AirPods Pro', 3, 280),
--(4, 'Apple Originals 4','iPhone 12 Pro', 2, 1000),
--(4, 'Apple Originals 4','MacBook pro 13', 1, 2500);


SELECT * FROM customer.sales;

COMMIT;