 select *
 from [TUTORIAL DB]..CovidDeaths
 where continent is not null
 order by 2,3
 

 select * 
 from [TUTORIAL DB]..CovidVaccination
  order by 2,3

 --Data that is being used in this analysis.

 select location,date,total_cases,new_cases,total_deaths,population
 from [TUTORIAL DB]..CovidDeaths
 order by 1,2

 --Total Case vs Total Deaths in World

  select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 from [TUTORIAL DB]..CovidDeaths
 order by 1,2

 -- Talking about Cases in India

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 from [TUTORIAL DB]..CovidDeaths
 where location like '%india%'
 order by 1,2

 --Highest Case Count in India

   select top 5 location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 from [TUTORIAL DB]..CovidDeaths
 where location like '%india%'
 order by 1,2 desc

 --Total Cases vs Population in World
 select location,date,population,total_deaths, (population/total_deaths)*100 as AffectedPopulation
 from [TUTORIAL DB]..CovidDeaths
 order by 1,2
 

 --Total Cases vs Population In India

 select location,date,population,total_cases,(total_cases/population)*100 as AffectedPopulation
 from [TUTORIAL DB]..CovidDeaths
 where location like '%india%'
 order by 1,2

 --Countries with Heighest Infection Rate based on their Population

  select location,population,max(total_cases) as InfectionCount,max((total_cases/population))*100 as AffectedPopulation
 from [TUTORIAL DB].dbo.CovidDeaths
 --where location like '%india%'
 group by location, population
 order by AffectedPopulation desc 


 --Countries with Highest Death Count

 select location,max(cast(total_deaths as int)) as TotalDeathCount
 from [TUTORIAL DB].dbo.CovidDeaths
 --where location like '%india%'
 group by location
 order by TotalDeathCount desc 

 ---we are getting error where world and continent appear in the location section 

  select location,max(cast(total_deaths as int)) as TotalDeathCount
 from [TUTORIAL DB].dbo.CovidDeaths
 where continent is not null
 group by location
 order by TotalDeathCount desc

--Continents with heigest deathcount 
 
  select location,max(cast(total_deaths as int)) as TotalDeathCount
 from [TUTORIAL DB].dbo.CovidDeaths
 where continent is null
 group by location
 order by TotalDeathCount desc


 --another observation on continent-deathcount

  select continent,max(cast(total_deaths as int)) as TotalDeathCount
 from [TUTORIAL DB].dbo.CovidDeaths
 where continent is not null
 group by continent
 order by TotalDeathCount desc


 -- Relation of Total Death count and Total Cases Globally

select sum(new_cases) as totalcases,sum(cast(new_deaths as int))as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as TotalDeathCount
 from [TUTORIAL DB]..CovidDeaths
 where continent is not null
 --group by date
 order by 1,2


 select *
 from [TUTORIAL DB]..CovidDeaths dth
 join[TUTORIAL DB]..CovidVaccination vac
 on dth.location = vac.location
 and dth.date = vac.date

 --Total Population vs Total Vaccination

 select dth.continent,dth.location,dth.date,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) over (partition by dth.location) as TotalVaccinaationCount
 from [TUTORIAL DB]..CovidDeaths dth
 join[TUTORIAL DB]..CovidVaccination vac
 on dth.location = vac.location
 and dth.date = vac.date
 where dth.continent is not null
 order by 2,3

 --problem persist in TotalVaccinationCount with same count


  select dth.continent,dth.location,dth.date,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) over (partition by dth.location order by dth.location,dth.date)
 as TotalVaccinaationCount
 --,(TotalVaccinaationCount/population)*100 named column can't be used in next quering
 from [TUTORIAL DB]..CovidDeaths dth
 join[TUTORIAL DB]..CovidVaccination vac
 on dth.location = vac.location
 and dth.date = vac.date
 where dth.continent is not null
 order by 2,3


 --using CTE

with PopvsVac (continent,location,date,population,new_vaccinations,TotalVaccinaationCount)
as
(

 select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) over (partition by dth.location order by dth.location,dth.date)
 as TotalVaccinaationCount
 from [TUTORIAL DB]..CovidDeaths dth
 join[TUTORIAL DB]..CovidVaccination vac
 on dth.location = vac.location
 and dth.date = vac.date
 where dth.continent is not null
 --order by 2,3 
 )
 
 select*, (TotalVaccinaationCount/population)*100
 from PopvsVac

 ---TEMP TABLE

 drop table if exists #PercentagePeopleVaccinated
 create table #PercentagePeopleVaccinated
 (continent varchar(255),
 location varchar(255),
 date datetime,
 Population numeric,
 NewVaccination numeric,
 TotalVaccinaationCount numeric)


 insert into #PercentagePeopleVaccinated
select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) over (partition by dth.location order by dth.location,dth.date)
 as TotalVaccinaationCount
 from [TUTORIAL DB]..CovidDeaths dth
 join[TUTORIAL DB]..CovidVaccination vac
 on dth.location = vac.location
 and dth.date = vac.date
 --where dth.continent is not null
 --order by 2,3 

 select*, (TotalVaccinaationCount/population)*100 as VaccinatedPopulation
 from #PercentagePeopleVaccinated


 --Creating the	VIEW for the multiple use of the same data


 create view PercentagePeopleVaccinated as
 select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) over (partition by dth.location order by dth.location,dth.date)
 as TotalVaccinaationCount
 from [TUTORIAL DB]..CovidDeaths dth
 join[TUTORIAL DB]..CovidVaccination vac
 on dth.location = vac.location
 and dth.date = vac.date
 where dth.continent is not null
 --order by 2,3 

 --to view the temp table 
 select *
 from PercentagePeopleVaccinated







