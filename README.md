# Relationship between college rankings, state charancteristics and Voting in the USA 
<b>**Data**</b> </br>
</br>

The universities.xlsx data contains all schools in the National Universities category ranked 100 or above in the current (2023) rankings, and their rating history since 2009. Data on school rankings comes from Andy Reiter, with several blank values filled in by the professor. Observations are uniquely identified by school.

The variables in this data set are:

school: The name of the college or university.
state: The state in which the college or university is located.
2023 - 2009: the ranking of the school in that year
The colleges.xlsx data contains contains all schools in the National Liberal Arts Colleges category ranked 100 or above in the current (2023) rankings and their ranking history since 2009.

Data on school rankings comes from Andy Reiter. Observations are uniquely identified by school.

The variables in this data set are:

school: The name of the college or university.
state: The state in which the college or university is located.
2023 - 2009: the ranking of the school in that year
The presvote_pop.csv data contains four variables related to the characteristics of a state:

abbrev: The state’s abbreviation.
trump_votes: The number of votes received by Donald Trump in 2020.
biden_votes: The number of votes received by Joe Biden in 2020.
2020_pop: The state’s population in the 2020 census.
The Trump and Biden votes variables come from the CQ Voting and Elections Collection, which was accessed through the Duke Library. The 2020 population data comes from the US Census.

**Data Analysis**</br>
**Number of Schools and Rankings** </br>
</br>
Filter full_data down to just the year 2023 and count the number of schools per state in this year. Which states have the five largest number of schools?

How many states do not have a school in full_data?  Return a data set with two variables, state abbreviations and state population, in order from greatest population to least. What is the state with the largest population that does not have a school in the full_data data set?
Filter full_data down to just the year 2023 and count the number of schools per state in this year. Which states have the five largest number of schools?

How many states do not have a school in full_data? You can use the presvote_pop dataset and an appropriate join to help answer this question. Return a data set with two variables, state abbreviations and state population, in order from greatest population to least. What is the state with the largest population that does not have a school in the full_data data set?

**Number of Colleges vs Number of Universities per State** </br>
</br>
Next, we will look at how the number of colleges in the top 100 in 2023 compares to the number of universities in the top 100 in 2023 per state. We will also incorporate information on which 2020 presidential candidate won each state. With this we can analyze the election results based on each state and how many schools were in that states in relation to the population. 
