-- Source: DataLemur "Highest-Grossing Items" (Amazon), full dataset, 15 rows
-- Link: https://datalemur.com/questions/sql-highest-grossing

create schema if not exists datalemur;

drop table if exists datalemur.product_spend;

create table datalemur.product_spend (
    category          varchar(50),
    product           varchar(100),
    user_id           integer,
    spend             numeric(10,2),
    transaction_date  timestamp
);



insert into datalemur.product_spend (category, product, user_id, spend, transaction_date) values
('appliance',   'washing machine',      123, 219.80, '2022-03-02 11:00:00'),
('electronics', 'vacuum',               178, 152.00, '2022-04-05 10:00:00'),
('electronics', 'wireless headset',     156, 249.90, '2022-07-08 10:00:00'),
('electronics', 'vacuum',               145, 189.00, '2022-07-15 10:00:00'),
('electronics', 'computer mouse',       195,  45.00, '2022-07-01 11:00:00'),
('appliance',   'refrigerator',         165, 246.00, '2021-12-26 12:00:00'),
('appliance',   'refrigerator',         123, 299.99, '2022-03-02 11:00:00'),
('appliance',   'washing machine',      123, 220.00, '2022-07-27 04:00:00'),
('electronics', 'vacuum',               156, 145.66, '2022-08-10 04:00:00'),
('electronics', 'wireless headset',     145, 198.00, '2022-08-04 04:00:00'),
('electronics', 'wireless headset',     215,  19.99, '2022-09-03 16:00:00'),
('appliance',   'microwave',            169,  49.99, '2022-08-28 16:00:00'),
('appliance',   'microwave',            101,  34.49, '2023-03-01 17:00:00'),
('electronics', '3.5mm headphone jack', 101,   7.99, '2022-10-07 16:00:00'),
('appliance',   'microwave',            101,  64.95, '2023-07-08 16:00:00');


select count(*) from datalemur.product_spend;   -- expect 15
select * from datalemur.product_spend;   