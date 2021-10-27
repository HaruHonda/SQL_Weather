DROP TABLE IF EXISTS test;
CREATE TABLE test (
    date TEXT,
    temperature TEXT,
    rain TEXT,
    sun TEXT
);

LOAD DATA LOCAL INFILE '/Users/HarukiHonda/Downloads/data-1.csv' INTO TABLE weathercast_test.test FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n';

select test.date, t2.date,ABS(test.temperature - t2.temperature) as abs
from test inner join test t2
on (t2.date - INTERVAL 12 HOUR) = (test.date + INTERVAL 12 HOUR)
order by abs desc
limit 10;

select test.date, t2.date, t3.date,t4.date, t2.temperature, t3.temperature,t4.temperature, ABS(test.temperature - t2.temperature) as abs, avg(t2.temperature + t3.temperature + t4.temperature) 
from (test inner join test t2 on (t2.date - INTERVAL 12 HOUR) = (test.date + INTERVAL 12 HOUR))
inner join test t3 on (t2.date - INTERVAL 1 HOUR) = (t3.date + INTERVAL 1 HOUR)
inner join test t4 on (t4.date - INTERVAL 1 HOUR) = (t3.date + INTERVAL 3 HOUR)
group by t2.date,t3.date,t4.date
order by abs desc
limit 10;

select test.date as dateA, t2.date as dateB, t3.date as dateC,test.rain as rainA,t2.rain as rainB,t3.rain as rainC, avg(test.rain + t2.rain + t3.rain)/3 as avePre
from (test inner join test t2 on (t2.date - INTERVAL 0.2 HOUR) = (test.date + INTERVAL 1 HOUR))
inner join test t3 on (t2.date + INTERVAL 1 HOUR) = (t3.date + INTERVAL 0.3 HOUR)
group by test.date,t2.date,t3.date
order by avePre desc
limit 10;

select test.date as dateA, t2.date as dateB, t3.date as dateC,t4.date as dateD,test.rain as rainA,t2.rain as rainB,t3.rain as rainC,t4.sun as sunD,avg(test.rain + t2.rain + t3.rain)/3 as aveRain,min(ABS(DATEDIFF(t2.date,t4.date))) as absSun
from (test inner join test t2 on (t2.date - INTERVAL 0.2 HOUR) = (test.date + INTERVAL 1 HOUR))
inner join test t3 on (t2.date + INTERVAL 1 HOUR) = (t3.date + INTERVAL 0.3 HOUR)
inner join test t4 on ABS(DATEDIFF(t2.date,t4.date)) and t4.sun > 0 
group by test.date,t2.date,t3.date
order by aveRain desc, absRain
limit 10;

