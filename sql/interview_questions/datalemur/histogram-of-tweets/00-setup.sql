-- Source: DataLemur "Histogram of Tweets" (Twitter, Easy), full dataset, 5 rows
select current_database();   -- expect sql_de_lab

create schema if not exists datalemur;

drop table if exists datalemur.tweets;

create table datalemur.tweets (
    tweet_id    integer,
    user_id     integer,
    msg         varchar(280),
    tweet_date  timestamp
);

insert into datalemur.tweets (tweet_id, user_id, msg, tweet_date) values
(241425, 254, 'If the salary is so competitive why won''t you tell me what it is?', '2022-03-01 11:00:00'),
(214252, 111, 'Am considering taking Tesla private at $420. Funding secured.',      '2021-12-30 00:00:00'),
(739252, 111, 'Despite the constant negative press covfefe',                       '2022-01-01 11:00:00'),
(846402, 111, 'Following @NickSinghTech on Twitter changed my life!',              '2022-02-14 11:00:00'),
(231574, 148, 'I no longer have a manager. I can''t be managed',                   '2022-03-23 11:00:00');

select count(*) from datalemur.tweets;   

select * from datalemur.tweets;   