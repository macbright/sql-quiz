SELECT population FROM world
  WHERE name = 'Germany';

SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark');

SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000;


-- exercise two 
SELECT name, continent, population FROM world 

-- Show the name for the countries that have a population of at least 200 million. 200 million is 200000000, there are eight zeros.
SELECT name FROM world
WHERE population >= 200000000

-- Give the name and the per capita GDP for those countries with a population of at least 200 million.
SELECT name, gdp/population FROM world
WHERE population >= 200000000

-- Show the name and population in millions for the countries of the continent 'South America'. Divide the population by 1000000 to get population in millions.
SELECT name, population/1000000 FROM world
where continent = 'South America'

-- Show the name and population for France, Germany, Italy
SELECT name, population FROM world 
WHERE name IN ('France', 'Germany', 'Italy')

-- Show the countries which have a name that includes the word 'United'
SELECT name FROM world 
WHERE name LIKE 'United%'

-- Show the countries that are big by area or big by population. Show name, population and area.
SELECT name, population, area  FROM world 
WHERE area > 3000000 OR population > 250000000

-- Exclusive OR (XOR). Show the countries that are big by area or big by population but not both. Show name, population and area.
SELECT name, population, area  FROM world 
WHERE (area > 3000000 AND population < 250000000 ) OR (area < 3000000 AND population > 250000000 )

-- For South America show population in millions and GDP in billions both to 2 decimal places.
SELECT name, ROUND(population/1000000, 2), ROUND(gdp/1000000000, 2) FROM world
WHERE continent = 'South America'

-- Show per-capita GDP for the trillion dollar countries to the nearest $1000.
SELECT name, ROUND(gdp/population, -3) FROM world
WHERE gdp >= 1000000000000

-- Show the name and capital where the name and the capital have the same number of characters.
SELECT name,   capital
  FROM world
 WHERE LENGTH(name) = LENGTH(capital) 

--  Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
SELECT name,  capital
FROM world
WHERE LEFT(name,1) = LEFT(capital,1) AND name <> capital

-- Find the country that has all the vowels and no spaces in its name.
SELECT name
   FROM world
WHERE name LIKE '%A%'
           AND name LIKE '%E%'
           AND name LIKE '%I%'
           AND name LIKE '%O%'
           AND name LIKE '%U%'
       AND name NOT LIKE '% %';

-- THE THIRD EXERCISE
-- Change the query shown so that it displays Nobel prizes for 1950.
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

--  Show who won the 1962 prize for Literature.
SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'Literature'

-- Show the year and subject that won 'Albert Einstein' his prize.
SELECT yr, subject
  FROM nobel
 WHERE winner = 'Albert Einstein'

--  Give the name of the 'Peace' winners since the year 2000, including 2000.
SELECT winner 
  FROM nobel
 WHERE yr >= 2000
AND subject = 'Peace'

-- Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive.
SELECT * FROM nobel
WHERE yr >= 1980
AND yr <= 1989
AND subject = 'Literature'

-- Show all details of the presidential winners:
-- Theodore Roosevelt
-- Woodrow Wilson
-- Jimmy Carter
-- Barack Obama
SELECT * FROM nobel
  WHERE winner IN ('Theodore Roosevelt',
                  'Woodrow Wilson',
                  'Jimmy Carter',
                   'Barack Obama')

-- Show the winners with first name John
SELECT winner FROM nobel
WHERE winner LIKE 'John%'

-- Show the year, subject, and name of Physics winners for 1980 together with the Chemistry winners for 1984.
SELECT * FROM nobel 
WHERE yr = 1980
AND subject = 'Physics' OR
 yr = 1984
AND subject = 'Chemistry'

-- Show the year, subject, and name of winners for 1980 excluding Chemistry and Medicine
SELECT * FROM nobel
WHERE yr = 1980
AND subject NOT IN ('Chemistry', 'Medicine')

-- Show year, subject, and name of people who won a 'Medicine' prize in an early year (before 1910, not including 1910) together with winners of a 'Literature' prize in a later year (after 2004, including 2004)
SELECT * FROM nobel 
WHERE yr < 1910
AND subject = 'Medicine' OR
 yr  >= 2004
AND subject = 'Literature'

-- Find all details of the prize won by PETER GRÜNBERG
SELECT * FROM nobel
WHERE winner = 'PETER GRÜNBERG'

-- Find all details of the prize won by EUGENE O'NEILL

-- Escaping single quotes
SELECT * FROM nobel
WHERE winner = 'EUGENE O''NEILL'

-- List the winners, year and subject where the winner starts with Sir. Show the the most recent first, then by name order.
SELECT winner, yr, subject FROM nobel
WHERE winner LIKE 'Sir%' ORDER BY yr DESC

-- The expression subject IN ('Chemistry','Physics') can be used as a value - it will be 0 or 1.
-- Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.
SELECT winner, subject  FROM nobel
 WHERE yr=1984
 ORDER BY ( case subject
           when 'Chemistry' then 0
           when 'Physics'   then 1
           end),subject,winner



-- THE FOURTH EXERCISE STARTS HERE

-- List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name FROM world
  WHERE continent = 'Europe'
  AND gdp/population > 38555.0739

-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent FROM world
  WHERE continent IN ( 'Oceania', 'South America')
ORDER BY name
 

-- Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population FROM world
WHERE population > 35427524 AND
population < 38496000;

-- Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
-- Decimal places
-- Percent symbol %
SELECT name, CONCAT(ROUND((100 * population/ (SELECT population FROM world WHERE name = 'Germany') ),-0),'%') FROM world
WHERE continent = 'Europe' 

-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name FROM world
WHERE gdp > (SELECT MAX(gdp) FROM world 
WHERE continent = 'Europe')

-- Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

-- List each continent and the name of the country that comes first alphabetically.
SELECT continent, MIN(name) AS name
FROM world 
GROUP BY continent
ORDER BY continent

-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population FROM world x
WHERE  25000000 >= ALL (SELECT population FROM world y
WHERE x.continent = y.continent)

-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent 
FROM world x WHERE population/3 > ALL (SELECT population  
                                       FROM world y 
                                       WHERE x.continent = y.continent 
                                             AND x.name != y.name 
                                             AND population > 0)




-- THE FIFTH EXERCISE STARTS HERE
-- Show the total population of the world.
SELECT SUM(population)
FROM world

-- List all the continents - just once each.
SELECT continent FROM world
GROUP BY continent

-- Give the total GDP of Africa
SELECT SUM(gdp) FROM world
WHERE continent = 'Africa'

-- How many countries have an area of at least 1000000
SELECT COUNT(name) FROM world
WHERE area >= 1000000

-- What is the total population of ('Estonia', 'Latvia', 'Lithuania')
SELECT SUM(population) FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

-- For each continent show the continent and number of countries.
SELECT continent, COUNT(name) FROM world 
GROUP BY continent

-- For each continent show the continent and number of countries with populations of at least 10 million.
SELECT continent, COUNT(name) FROM world
WHERE population >= 10000000
GROUP BY continent

-- List the continents that have a total population of at least 100 million.
SELECT continent FROM world x
WHERE 100000000 <= (SELECT SUM(population) FROM world y
WHERE x.continent = y.continent
)
GROUP BY continent



-- THE SIXTH EXERCISE STARTS HERE
-- The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime
-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT matchid, player FROM goal 
  WHERE teamid  = 'Ger'

-- From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
-- Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
-- Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game
WHERE id = 1012

-- The FROM clause says to merge data from the goal table with that from the game table. The ON says how to figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. (If we wanted to be more clear/specific we could say 
-- ON (game.id=goal.matchid)
-- The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.
-- Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid,stadium, mdate
  FROM game JOIN goal 
ON (id=matchid)
WHERE teamid = 'GER'


-- Use the same JOIN as in the previous question.
-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
FROM game JOIN goal
ON (id = matchid)
WHERE player LIKE 'mario%'

-- The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id
-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam ON 
(teamid=id)
 WHERE gtime<=10


--  To JOIN game with eteam you could use either
-- game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)
-- Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id
-- List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach
SELECT mdate, teamname
  FROM game JOIN eteam ON 
(team1=eteam.id)
 WHERE coach = 'Fernando Santos'

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player FROM goal
JOIN game ON (matchid = id)
WHERE stadium = 'National Stadium, Warsaw'

--  show the name of all players who scored a goal against Germany.
SELECT DISTINCT player 
FROM game JOIN goal ON matchid = id
 WHERE (teamid!='GER' AND (team1='GER' OR team2='GER'))

--  Show teamname and the total number of goals scored.
SELECT teamname, COUNT(teamname)
FROM eteam JOIN goal ON id = teamid
GROUP BY teamname

-- Show the stadium and the number of goals scored in 
SELECT stadium, COUNT(stadium)
FROM game JOIN goal ON id=matchid
GROUP BY stadium

-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid,mdate, COUNT(matchid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid, mdate

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid,mdate, COUNT(matchid)
  FROM game JOIN goal ON matchid = id 
 WHERE teamid = 'GER' AND (team1 = 'GER' OR team2 = 'GER')
GROUP BY matchid, mdate

-- List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END ) AS score1,
team2,
SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
FROM game LEFT JOIN goal ON matchid = id
GROUP BY  mdate, team1, team2
ORDER BY mdate, matchid, team1, team2
