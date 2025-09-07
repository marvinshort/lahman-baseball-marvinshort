
--Q1 What range of years for baseball games played does the provided database cover?

-- SELECT MIN(year) as earliest_year, max(year) as latest_year
-- FROM homegames

--ANSWER Games range from 1871 to 2016



--Q2a. Find the name and height of the shortest player in the database.

-- SELECT playerid, namefirst, namelast, height
-- FROM people
-- WHERE height = (SELECT MIN(height)
-- FROM people)

--ANSWER The shortest player in the database is Eddie Gaedel.



--Q2b. How many games did he play in?

-- SELECT playerid, namefirst, namelast, height, batting.G
-- FROM people
-- LEFT JOIN batting
-- USING (playerid)
--  WHERE height = (SELECT MIN(height)
-- FROM people)

--ANSWER Based on the batting table, Eddie Gaedel played in 1 game.



--Q2c. What is the name of the team for which he played?

-- SELECT playerid, namefirst, namelast, height, teams.name, batting.G
-- FROM people
-- LEFT JOIN batting
-- USING (playerid)
-- LEFT JOIN teams
-- ON batting.teamid = teams.teamid
-- WHERE height = (SELECT MIN(height)
-- FROM people)
-- LIMIT 1

--ANSWER Eddie Gaedel played for the St. Louis Browns.



--3a. Find all players in the database who played at Vanderbilt University.

-- SELECT DISTINCT(playerid)
-- FROM collegeplaying
-- WHERE schoolid = 'vandy'

--ANSWER 24 players played at Vanderbilt.



--3b. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. 

-- WITH ts AS (SELECT DISTINCT(playerid), SUM(salary)::float8::numeric::money as total_salary_earned
-- FROM salaries
-- GROUP BY playerid)

-- SELECT DISTINCT(cp.playerid), p.namefirst, p.namelast, ts.total_salary_earned
-- FROM collegeplaying as cp
-- INNER JOIN people as p
-- ON cp.playerid = p.playerid
-- INNER JOIN ts
-- ON ts.playerid = p.playerid
-- WHERE cp.schoolid = 'vandy'
-- ORDER BY total_salary_earned DESC




--3c. Which Vanderbilt player earned the most money in the majors?

-- WITH ts AS (SELECT DISTINCT(playerid), SUM(salary)::float8::numeric::money as total_salary_earned
-- FROM salaries
-- GROUP BY playerid)

-- SELECT DISTINCT(cp.playerid), p.namefirst, p.namelast, ts.total_salary_earned
-- FROM collegeplaying as cp
-- INNER JOIN people as p
-- ON cp.playerid = p.playerid
-- INNER JOIN ts
-- ON ts.playerid = p.playerid
-- WHERE cp.schoolid = 'vandy'
-- ORDER BY total_salary_earned DESC
-- LIMIT 1

--ANSWER David Price earned the most money in the majors of all the Vanderbilt players with a salary of $81,851,296.



-------------ALTERATE SOLUTION FROM KRITHIKA KUPPUSAMY-------------------

-- SELECT
--     salaries.playerid,
-- 	people.namefirst,
-- 	people.namelast,
-- 	(CAST(SUM(DISTINCT salaries.salary)AS NUMERIC)::MONEY) AS total_salary         --CAST is used to change salary to NUMERIC datatype and MONEY to add $
-- FROM schools
-- JOIN collegeplaying ON collegeplaying.schoolid=schools.schoolid
-- 					AND  schools.schoolname = 'Vanderbilt University'     --JOINED schools and collegeplaying tables to get playerid
-- JOIN people ON (collegeplaying.playerid=people.playerid)                  --JOINED  collegeplaying and people tables to get first and last name
-- JOIN salaries ON(collegeplaying.playerid=salaries.playerid)               --JOINED  collegeplaying and salaries tables to get salary
-- --where schools.schoolname = 'Vanderbilt University'
-- GROUP BY  salaries.playerid, schools.schoolid,people.namefirst,people.namelast
-- ORDER BY total_salary DESC
-- LIMIT 1



--4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

-- SELECT 
-- (CASE WHEN pos = 'OF' THEN 'Outfielder'
-- 	WHEN pos IN ('SS', '1B', '2B', '3B') THEN 'Infielder'
-- 	WHEN pos IN ('P', 'C') THEN 'Battery'
-- 	ELSE '' END) as position_label,
-- SUM(PO)
-- FROM fielding
-- WHERE yearID = '2016'
-- GROUP BY position_label

--ANSWER --- Outfielder = 29560
--ANSWER --- Infielder = 58934
--ANSWER --- Battery = 41424



--5a. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places.

-- b = batting table

-- SELECT
-- (SELECT CASE
-- 		WHEN b.yearid between 1870 and 1879 THEN '1870s'
-- 		WHEN b.yearid between 1880 and 1889 THEN '1880s'
-- 		WHEN b.yearid between 1890 and 1899 THEN '1890s'
-- 		WHEN b.yearid between 1900 and 1909 THEN '1900s'
-- 		WHEN b.yearid between 1910 and 1919 THEN '1910s'
-- 		WHEN b.yearid between 1920 and 1929 THEN '1920s'
-- 		WHEN b.yearid between 1930 and 1939 THEN '1930s'
-- 		WHEN b.yearid between 1940 and 1949 THEN '1940s'
-- 		WHEN b.yearid between 1950 and 1959 THEN '1950s'
-- 		WHEN b.yearid between 1960 and 1969 THEN '1960s'
-- 		WHEN b.yearid between 1970 and 1979 THEN '1970s'
-- 		WHEN b.yearid between 1980 and 1989 THEN '1980s'
-- 		WHEN b.yearid between 1990 and 1999 THEN '1990s'
-- 		WHEN b.yearid between 2000 and 2009 THEN '2000s'
-- 		WHEN b.yearid between 2010 and 2019 THEN '2010s'
-- 		END) AS decade,
-- SUM(b.G) as batting_games,
-- SUM(b.SO) as batting_strikeout,
-- ROUND((SUM(b.SO)::NUMERIC/SUM(b.G)::NUMERIC),2) as avg_strikeouts_per_game
-- FROM batting as b
-- GROUP BY decade
-- ORDER BY decade ASC

--OBSERVATION -- Strikeouts increased by a factor of 3.3X through the decades.




--5b. Do the same for home runs per game. Do you see any trends?

-- SELECT
-- (SELECT CASE
-- 		WHEN b.yearid between 1870 and 1879 THEN '1870s'
-- 		WHEN b.yearid between 1880 and 1889 THEN '1880s'
-- 		WHEN b.yearid between 1890 and 1899 THEN '1890s'
-- 		WHEN b.yearid between 1900 and 1909 THEN '1900s'
-- 		WHEN b.yearid between 1910 and 1919 THEN '1910s'
-- 		WHEN b.yearid between 1920 and 1929 THEN '1920s'
-- 		WHEN b.yearid between 1930 and 1939 THEN '1930s'
-- 		WHEN b.yearid between 1940 and 1949 THEN '1940s'
-- 		WHEN b.yearid between 1950 and 1959 THEN '1950s'
-- 		WHEN b.yearid between 1960 and 1969 THEN '1960s'
-- 		WHEN b.yearid between 1970 and 1979 THEN '1970s'
-- 		WHEN b.yearid between 1980 and 1989 THEN '1980s'
-- 		WHEN b.yearid between 1990 and 1999 THEN '1990s'
-- 		WHEN b.yearid between 2000 and 2009 THEN '2000s'
-- 		WHEN b.yearid between 2010 and 2019 THEN '2010s'
-- 		END) AS decade,
-- SUM(b.G) as batting_games,
-- SUM(b.HR) as batting_homeruns,
-- ROUND((SUM(b.HR)::NUMERIC/SUM(b.G)::NUMERIC),2) as avg_homeruns_per_game
-- FROM batting as b
-- GROUP BY decade
-- ORDER BY decade ASC

--OBSERVATION -- Homeruns increased by a factor 7X through the decades.



--6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.

--b = batting table
--p = people table

-- SELECT p.namefirst, p.namelast, b.yearid, sb::NUMERIC, cs, (sb + cs) as stolen_base_attempts, ROUND(sb::NUMERIC/(sb + cs::NUMERIC)*100,2) as stolen_base_success_rate
-- FROM batting as b
-- LEFT JOIN people as p
-- USING(playerid)
-- where yearid = '2016'
-- AND (sb + cs) >=20
-- ORDER BY stolen_base_success_rate DESC
-- LIMIT 1

--ANSWER Chris Owings had the highest success rate (91.3%) with stealing bases in 2016




--7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?

-- SELECT yearid, franchname,  W as wins, WSwin
-- FROM teams
-- INNER JOIN teamsfranchises as f
-- USING (franchid)
-- where yearid between '1970' and '2016'
-- and WSwin = 'N'
-- ORDER BY W DESC
--LIMIT 1

--ANSWER The largest # of wins by a team that did not win the World Series is 116 wins by the Seattle Mariners.



--7b. What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 

-- SELECT yearid, teamid, name,  W as wins, WSwin
-- FROM teams
-- where yearid between '1970' and '2016'
-- and WSwin = 'Y'
-- ORDER BY wins ASC
--LIMIT 1

--ANSWER The smallest # of wins by a World Series Champion is 63 wins by the LA Dodgers in 1981. There was a player's strike in 1981 that cut the season short.



--7c. Then redo your query, excluding the problem year.

-- SELECT yearid, teamid, name,  W as wins, WSwin
-- FROM teams
-- where yearid between '1970' and '1980' and WSwin = 'Y'
-- OR yearid between '1982' and '2016' and WSwin = 'Y'
-- ORDER BY wins ASC
-- --LIMIT 1

--ANSWER Excluding the year 1981, the St. Louis Cardinals have the smallest # of wins by a World Series Champion with 83 wins.




--7c. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 

-- WITH highest_wins_by_season AS ( ---CTE to create table with year, max # of wins, max win season flag
-- SELECT yearid,
-- MAX(W) as W, 
-- 'max win season' as max_win_season
-- FROM teams as t2
-- where yearid >= 1970
-- GROUP BY yearid
-- ORDER BY yearid)

-- SELECT yearid, t1.teamid, t1.name, W as wins, t1.WSwin, max_win_season --- Query to return all World Series Winners by year >=1970
-- FROM teams t1
-- LEFT JOIN highest_wins_by_season
-- USING (yearid, W)
-- WHERE t1.WSwin = 'Y'
-- and yearid >= 1970
-- ORDER BY yearid ASC

---ANSWER - The team with the most wins has won the World Series on 12/46 times betweem 1970 and 2016.


--7d. What percentage of the time?

-- WITH temp_table AS ( ---CTE to create temporary table containing all results
-- WITH highest_wins_by_season AS ( ---CTE to create table with year, max # of wins, max win season flag
-- SELECT yearid,
-- MAX(W) as W,
-- 'max win season' as max_win_season
-- FROM teams as t2
-- where yearid >= 1970
-- AND yearid != 1981
-- GROUP BY yearid
-- ORDER BY yearid)

-- SELECT yearid, t1.name, W as wins, t1.WSwin, max_win_season --- Query to return all World Series Winners by year >=1970
-- FROM teams t1
-- LEFT JOIN highest_wins_by_season
-- USING (yearid, W)
-- WHERE t1.WSwin = 'Y'
-- AND yearid >= 1970
-- AND yearid != 1981
-- ORDER BY yearid ASC)
-- --Calculate Percentage outside of CTE
-- SELECT ROUND(COUNT(max_win_season)*1.0/COUNT(*)*100,6)
-- FROM temp_table

--ANSWER 26.086957% of the time the team that has the max wins for the season wins the World Series (when 1981 is included).

--ALTERNATE ANSWER 26.666667% of the time the team that has the max wins for the season wins the World Series (when 1981 is excluded because of player strike that resulted in less games played).



-- 8a. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. 

-- SELECT DISTINCT t.name, p.park_name, (h.attendance/games) as avg_attendance_per_game
-- FROM homegames as h
-- INNER JOIN parks as p
-- USING (park)
-- INNER JOIN teams as t
-- ON h.team = t.teamid
-- AND h.year = t.yearid
-- WHERE year = 2016
-- AND games >= 10
-- ORDER BY avg_attendance_per_game DESC
-- LIMIT 5



--8b.Repeat for the lowest 5 average attendance.

-- SELECT DISTINCT t.name, p.park_name, (h.attendance/games) as avg_attendance_per_game
-- FROM homegames as h
-- INNER JOIN parks as p
-- USING (park)
-- INNER JOIN teams as t
-- ON h.team = t.teamid
-- AND h.year = t.yearid
-- WHERE year = 2016
-- AND games >= 10
-- ORDER BY avg_attendance_per_game ASC
-- LIMIT 5

------------------ALTERNATIVE SOULTION FROM YILLE BAYEH--------------------

-- WITH cte_avg_attendance AS
-- (
-- 	SELECT 
-- 		team
-- 	,	park
-- 	,	ROUND(attendance/games) AS avg_attendance_per_game
-- 	FROM homegames
-- 	WHERE year = 2016
-- 	AND games >= 10
-- )
-- SELECT 
-- 		parks.park_name
-- 	,	teams.name
-- 	,	cte_avg.avg_attendance_per_game
-- FROM cte_avg_attendance AS cte_avg
-- 	LEFT JOIN parks
-- 	ON cte_avg.park = parks.park
-- 		LEFT JOIN teams
-- 		ON cte_avg.team = teams.teamid
-- WHERE yearid = 2016
-- ORDER BY avg_attendance_per_game DESC
-- LIMIT 5;




--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

-- WITH nl_awards AS (--CTE#1 NL Award Recepients
-- SELECT DISTINCT playerid, yearid, awardid, lgid
-- FROM awardsmanagers
-- WHERE awardid = 'TSN Manager of the Year' AND lgid = 'NL'
-- ORDER BY playerid),

-- al_awards AS (--CTE#2 AL Award Recepients
-- SELECT DISTINCT playerid, yearid, awardid, lgid
-- FROM awardsmanagers
-- WHERE awardid = 'TSN Manager of the Year' AND lgid = 'AL')

-- SELECT people.namefirst, people.namelast, nl_awards.yearid, nl_awards.lgid, m1.teamid, al_awards.yearid, Al_awards.lgid, m2.teamid
-- FROM nl_awards
-- JOIN al_awards
-- ON nl_awards.playerid = Al_awards.playerid
-- JOIN people
-- ON nl_awards.playerid = people.playerid
-- JOIN managers as m1
-- ON m1.playerid = nl_awards.playerid
-- AND m1.yearid = nl_awards.yearid
-- AND m1.lgid = nl_awards.lgid
-- JOIN managers as m2
-- ON m2.playerid = Al_awards.playerid
-- AND m2.yearid = Al_awards.yearid
-- AND m2.lgid = Al_awards.lgid


-- ANSWER = Johnson, Leland
-- After further research, I discovered that the TSN award was given only to 1 manager from 1936 to 1985. in 1986, it was expanded to 1 award per league.


--10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

-- ANSWER = 9 Records Total

-- WITH max_home_run AS (--CTE #1 Max number of homeruns for every player
-- SELECT DISTINCT playerid, MAX (hr) as max_career_hr, 'Player Max Home Run' as max_hr_flag
-- FROM batting
-- WHERE hr > 0
-- GROUP BY playerid
-- ORDER BY playerid),

-- years_played AS (--CTE #2 All players with a career of atleast 10 years - DEDUPLICATED
-- SELECT DISTINCT playerid, COUNT (yearid) as num_of_years
-- FROM batting
-- GROUP BY playerid HAVING COUNT (DISTINCT(yearid)) >=10
-- ORDER BY playerid),

-- season_2016 AS (--CTE #3 All players who played in the 2016 season with atleast 1 HR - DEDUPLICATED
-- SELECT DISTINCT (playerid), yearid, SUM(hr) as hr_season_2016
-- FROM batting
-- WHERE yearid = 2016
-- AND hr > 0
-- GROUP BY playerid, yearid
-- ORDER BY playerid)

-- SELECT season_2016.playerid, p.namefirst, p.namelast, season_2016.hr_season_2016 
-- FROM season_2016
-- JOIN years_played as yp
-- USING (playerid)
-- JOIN max_home_run as mhr
-- ON mhr.playerid = season_2016.playerid AND mhr.max_career_hr = season_2016.hr_season_2016
-- JOIN people as p
-- ON season_2016.playerid = p.playerid
-- ORDER BY p.namelast
