--ДОМАШНЕЕ ЗАДАНИЕ.
-- Посчитать кол-во очков по всем игрокам за текущий год и за предыдущий.

--Цель:
--Использовать функцию LAG и CTE.

--Описание/Пошаговая инструкция выполнения домашнего задания:
--1. Создайте таблицу и наполните ее данными.
create  table statistic(
player_name varchar(100) not null,
player_id int not null,
year_game smallint not null check (year_game>0),
points decimal(12,2) check (points>=0),
primary key (player_name,year_game)
);

--2. Заполнить данными
insert into statistic(player_name, player_id, year_game, points)
values 
    ('Mike',1,2018,18),
    ('Jack',2,2018,14),
    ('Jackie',3,2018,30),
    ('Jet',4,2018,30),
    ('Luke',1,2019,16),
    ('Mike',2,2019,14),
    ('Jack',3,2019,15),
    ('Jackie',4,2019,28),
    ('Jet',5,2019,25),
    ('Luke',1,2020,19),
    ('Mike',2,2020,17),
    ('Jack',3,2020,18),
    ('Jackie',4,2020,29),
    ('Jet',5,2020,27);

--3. Написать запрос суммы очков с группировкой и сортировкой по годам
select year_game, sum(points) as total_points
from statistic
group by year_game
order by year_game;

--4. Написать cte показывающее тоже самое
with total_points_per_year AS (
    select year_game, SUM(points) AS total_points
    from statistic
    group by year_game
)
select * from total_points_per_year
order by year_game;

--5. Используя функцию LAG вывести кол-во очков по всем игрокам за текущий код и за предыдущий.
with points_per_year AS (
    select 
        player_name,
        year_game,
        points,
        lag(points) over (partition by player_name order by year_game) as previous_points
    from 
        statistic
)
select 
    player_name,
    year_game,
    points,
    previous_points
from 
    points_per_year
order by 
    player_name, year_game;

