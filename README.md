# SQL_Weather
I solved several sql questions. 

---
### Question 1-1.
#### Obtain meteorological data for Tokyo and query (SQL) for the following and the result.

```
Please download the following information from the Japan Meteorological Agency and store it in the DB.
Location: Tokyo
Items: Hourly values, temperature, precipitation, sunshine hours
Period: 1 January to 28 February 2018
```

```
DROP TABLE IF EXISTS test;
  CREATE TABLE test (
  date TEXT,
  temperature TEXT,
  rain TEXT,
  sun TEXT
);
```
```
LOAD DATA LOCAL INFILE '/Users/HarukiHonda/Downloads/data-1.csv' INTO TABLE weathercast_test.test FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n';
```
---
### Question 1-2.
#### 10 temperature differences (in absolute value) from the same time the day before in descending order, and the date and time of the temperature difference.

```
select test.date, t2.date,ABS(test.temperature - t2.temperature) as abs
from test inner join test t2
on (t2.date - INTERVAL 12 HOUR) = (test.date + INTERVAL 12 HOUR)
order by abs desc
limit 10;
```
<img width="290" alt="スクリーンショット 2021-10-27 14 06 01" src="https://user-images.githubusercontent.com/60038634/139062394-b70aad9c-a06d-40e1-929c-a9a817e5ff85.png">

#### All combinations of one-hour differences were created in Inner join, and the temperature differences were obtained in absolute values and sorted in order of increasing absolute value.
---
### Question 1-3. 
#### Average temperature over ±2 hours from time of Question 1-2. 

```
select test.date, t2.date, t3.date,t4.date, t2.temperature, t3.temperature,t4.temperature, ABS(test.temperature - t2.temperature) as abs, avg(t2.temperature + t3.temperature + t4.temperature) 
from (test inner join test t2 on (t2.date - INTERVAL 12 HOUR) = (test.date + INTERVAL 12 HOUR))
inner join test t3 on (t2.date - INTERVAL 1 HOUR) = (t3.date + INTERVAL 1 HOUR)
inner join test t4 on (t4.date - INTERVAL 1 HOUR) = (t3.date + INTERVAL 3 HOUR)
group by t2.date,t3.date,t4.date
order by abs desc
limit 10;
```
<img width="544" alt="スクリーンショット 2021-10-27 14 15 39" src="https://user-images.githubusercontent.com/60038634/139063630-d665e8ca-23ba-4a90-b0c2-fdfd7debe0af.png">

To the table obtained in questions 1-2, the date and its weather for ±2 hours were added by inner join and the average was taken.
---
### Question 1-4
#### Ten 3-hour total precipitation data (in descending order) and the date and time of the data.

```
select test.date as dateA, t2.date as dateB, t3.date as dateC,test.rain as rainA,t2.rain as rainB,t3.rain as rainC, avg(test.rain + t2.rain + t3.rain)/3 as avePre
from (test inner join test t2 on (t2.date - INTERVAL 0.2 HOUR) = (test.date + INTERVAL 1 HOUR))
inner join test t3 on (t2.date + INTERVAL 1 HOUR) = (t3.date + INTERVAL 0.3 HOUR)
group by test.date,t2.date,t3.date
order by avePre desc
limit 10;
```
<img width="547" alt="スクリーンショット 2021-10-27 14 22 58" src="https://user-images.githubusercontent.com/60038634/139064597-c732654a-a3d1-4642-b445-6fd8e51596ab.png">

#### Inner join was used to create combinations of three hours from date a to date c, and the average precipitation for each was obtained.
---
### Question 1-5.
#### Average time from the time of the Question 1-4. until the onset of daylight (onset of daylight = daylight hours > 0)

```
select test.date as dateA, t2.date as dateB, t3.date as dateC,t4.date as dateD,test.rain as rainA,t2.rain as rainB,t3.rain as rainC,t4.sun as sunD,avg(test.rain + t2.rain + t3.rain)/3 as aveRain,min(ABS(DATEDIFF(t2.date,t4.date))) as absSun
from (test inner join test t2 on (t2.date - INTERVAL 0.2 HOUR) = (test.date + INTERVAL 1 HOUR))
inner join test t3 on (t2.date + INTERVAL 1 HOUR) = (t3.date + INTERVAL 0.3 HOUR)
inner join test t4 on ABS(DATEDIFF(t2.date,t4.date)) and t4.sun > 0 
group by test.date,t2.date,t3.date
order by aveRain desc, absRain
limit 10;
```
<img width="547" alt="スクリーンショット 2021-10-27 14 25 52" src="https://user-images.githubusercontent.com/60038634/139065022-0bb72224-186f-48ce-b1ec-1aad5356e32f.png">

