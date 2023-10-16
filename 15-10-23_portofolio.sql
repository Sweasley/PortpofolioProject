/* start of portfolio 10-15-23 */

SELECT * 
FROM Portfolio.dbo.CovidDeaths$
WHERE Continent is not null 
order by 3,4

SELECT Location, date, total_cases, new_cases,
total_deaths, population 
FROM Portfolio.dbo.CovidDeaths$
order by 1,2;


--Looking at Total Cases Vs Total Deaths
-- shows likelihood of dying if you got covid in Philippines
SELECT Location, date, total_cases,
total_deaths, 
(total_deaths /total_cases) *.100 AS DeathPercentage
FROM Portfolio.dbo.CovidDeaths$
Where Location LIKE '%philippines%'
order by 1,2


--side notes
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from Portfolio.dbo.CovidDeaths$
order by 1,2




-- Looking at total Cases VS population
SELECT Location, date, total_cases,
population, 
(total_cases /population) *.100 AS PercentPopulationInfected
FROM Portfolio.dbo.CovidDeaths$
Where Location LIKE '%philippines%'
order by 1,2



--Countries highest infection rate compared to population

SELECT Location, MAX(total_cases) AS HighestInfectionCount,
population, 
MAX((total_cases /population)) *.100 AS PercentPopulationInfected
FROM Portfolio.dbo.CovidDeaths$

Group by population, location
order by PercentPopulationInfected DESC 

--Lets break things down by continent

SELECT continent, MAX(cast(total_deaths as INT)) AS HighestInfectionCount
FROM Portfolio.dbo.CovidDeaths$
where continent is not null
Group by  continent
order by HighestInfectionCount DESC 


SELECT location, MAX(cast(total_deaths as INT)) AS HighestInfectionCount
FROM Portfolio.dbo.CovidDeaths$
where location is null
Group by  location
order by HighestInfectionCount DESC 

--Highest Death Cout per Population
SELECT continent, MAX(cast(total_deaths as INT)) AS HighestInfectionCount
FROM Portfolio.dbo.CovidDeaths$
where continent is not null
Group by  location
order by HighestInfectionCount DESC 


--INTERMEDDIATE

--Showing Continents 
SELECT continent, MAX(cast(total_deaths as INT)) AS HighestInfectionCount
FROM Portfolio.dbo.CovidDeaths$
where continent is not null
Group by  continent
order by HighestInfectionCount DESC 

--Global numbers

SELECT date, SUM(new_cases) as total_cases , 
SUM(cast(new_deaths as int )) as total_deaths,
SUM(cast(new_deaths as int )) / SUM(New_cases) * 100 as DeathPercentage
FROM Portfolio.dbo.CovidDeaths$
--Where Location LIKE '%philippines%'
where continent is not null
group by date	
order by 1,2

--without date, only showing the total case for the world
SELECT  SUM(new_cases) as total_cases , 
SUM(cast(new_deaths as int )) as total_deaths,
SUM(cast(new_deaths as int )) / SUM(New_cases) * 100 as DeathPercentage
FROM Portfolio.dbo.CovidDeaths$
--Where Location LIKE '%philippines%'
where continent is not null
order by 1,2


--Looking at Total population vs Vaccination

--Total amount of people that has been vaccinated around the world


SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition By dea.Location ORDER by dea.location, dea.date)  AS RollingpeopleVaccinated
FROM Portfolio..CovidDeaths$ as dea
JOIN  Portfolio..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
order by 2, 3

--with cte
WITH PopvsVac ( Continent, Location, Date, Population, New_Vaccinations, RollingpeopleVaccinated) as(
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition By dea.Location ORDER by dea.location, dea.date)  AS RollingpeopleVaccinated
FROM Portfolio..CovidDeaths$ as dea
JOIN  Portfolio..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--order by 2, 3
)
SELECT*, (RollingpeopleVaccinated / Population) * 100
FROM PopvsVac 

--Temp table
Drop table if exists #PercentPopulationVaccinated
CREATE table #PercentPopulationVaccinated (
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_Vaccinations numeric,
RollingpeopleVaccinated Numeric)

INSERT INTO #PercentPopulationVaccinated 

SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition By dea.Location ORDER by dea.location, dea.date)  AS RollingpeopleVaccinated
FROM Portfolio..CovidDeaths$ as dea
JOIN  Portfolio..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--order by 2, 3

SELECT*, (RollingpeopleVaccinated / Population) * 100
FROM #PercentPopulationVaccinated


-- creating view to store data for later visualations
CREATe View PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition By dea.Location ORDER by dea.location, dea.date)  AS RollingpeopleVaccinated
FROM Portfolio..CovidDeaths$ as dea
JOIN  Portfolio..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--order by 2, 3





SELECT *
FROM Portfolio..CovidDeaths$ as dea
JOIN  Portfolio..CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date








