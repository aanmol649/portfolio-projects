
--queries for tableau project !

--1. visualization 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From covidproject..coviddeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--while visualization always double check the date provided

--2. visualization 
--We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From covidproject..coviddeaths$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3.visualization of highest infection count !


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covidproject..coviddeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--4.visualization

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covidproject..coviddeaths$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
