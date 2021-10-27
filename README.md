# SQL_Weather
I solved several sql questions. 

Question 1-1
Obtain meteorological data for Tokyo and query (SQL) for the following and the result.

Please download the following information from the Japan Meteorological Agency and store it in the DB.
Location: Tokyo
Items: Hourly values, temperature, precipitation, sunshine hours
Period: 1 January to 28 February 2018

DROP TABLE IF EXISTS test;
CREATE TABLE test (
    date TEXT,
    temperature TEXT,
    rain TEXT,
    sun TEXT
);

LOAD DATA LOCAL INFILE '/Users/HarukiHonda/Downloads/data-1.csv' INTO TABLE weathercast_test.test FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n';

Question 1-2
10 temperature differences (in absolute value) from the same time the day before in descending order, and the date and time of the temperature difference.

select test.date, t2.date,ABS(test.temperature - t2.temperature) as abs
from test inner join test t2
on (t2.date - INTERVAL 12 HOUR) = (test.date + INTERVAL 12 HOUR)
order by abs desc
limit 10;

![image](https://user-images.githubusercontent.com/60038634/139062172-1bfcee73-0a45-4544-9f1a-2a7fdd05a394.png)
