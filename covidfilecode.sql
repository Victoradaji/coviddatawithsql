--select * 
--from covidportfolioproject..CovidDeaths
--order by 3,4


--select * 
--from covidportfolioproject..CovidVaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from covidportfolioproject..CovidDeaths 
where continent is not null
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as percentageofdeaths
from covidportfolioproject..CovidDeaths 
where continent is not null
and location= 'united states' 
order by 1,2 

select location,date,total_cases,population,(total_cases/population)*100 as percentageofinfection
from covidportfolioproject..CovidDeaths 
where location= 'united states'
and continent is not null
order by 1,2


select location,population, max(total_cases) as maxcase,max((total_cases/population)) *100 as maxinfectionbypopulation
from covidportfolioproject..CovidDeaths 
--where location= 'united states' 
where continent is not null
group by location,population
order by maxinfectionbypopulation desc 



select continent, max(cast(total_deaths as int )) as maxdeaths
from covidportfolioproject..CovidDeaths 
--where location= 'united states' 
where continent is not  null
group by continent
order by maxdeaths desc


select date, sum(new_cases)as globalnewcases, sum(cast(new_deaths as int )) as globalnewdeaths, sum(cast(new_deaths as int ))/sum(new_cases)*100 as newdeathpercentage
from covidportfolioproject..CovidDeaths 
--where location= 'united states' 
where continent is not null
group by date
order by 1,2 desc 



select  sum(new_cases)as globalnewcases, sum(cast(new_deaths as int )) as globalnewdeaths, sum(cast(new_deaths as int ))/sum(new_cases)*100 as newdeathpercentage
from covidportfolioproject..CovidDeaths 
--where location= 'united states' 
where continent is not null
--group by date
order by 1,2 desc  





select * 
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date  


select death.continent,death.location,death.date,death.population, vaccines.new_vaccinations
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 

where death.continent is not null 
order by 2,3  


select death.continent,death.location,death.date,death.population, vaccines.new_vaccinations, sum(convert(bigint,vaccines.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rollingsumofnewvaccines
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 

where death.continent is  null 
order by 2,3  



with populationvaccinated ( continent, location,date,population,new_vaccines,rollingsumofnewvaccines)
as (
select death.continent,death.location,death.date,death.population, vaccines.new_vaccinations, sum(convert(bigint,vaccines.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rollingsumofnewvaccines
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 

where death.continent is  null) 
select *, (rollingsumofnewvaccines/population)*100 as percentageofrollingsumofnewvaccinationvspopulation
from populationvaccinated
 

create view rollingsumofpeoplevaccinated  as 
 
select death.continent,death.location,death.date,death.population, vaccines.new_vaccinations, sum(convert(bigint,vaccines.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rollingsumofnewvaccines
from covidportfolioproject..CovidDeaths death
join covidportfolioproject..CovidVaccinations vaccines 
on death.location= vaccines.location 
and death.date= vaccines.date 

where death.continent is  null

select * 
from rollingsumofpeoplevaccinated