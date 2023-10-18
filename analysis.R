---
title: "College Rankings and State Characteristics^[Adapted from Duke University's STA 199 Lab]"
format:
  html: 
    theme: "pulse"
link-citations: true
fig-asp: 0.618
fig-width: 10
embed-resources: true
author: "Felix Omondi"
date: "10/8/2023"
---


# Packages loading 

```{r load-packages}
#| message: false
#| warning: false
library(tidyverse)
library(colorblindr)
library(dplyr)
```


## 

### Loading data 

```{r load-data}
#| label: data_loading
#| eval: true
# load data here using appropriate readr and readxl functions 
presvote_pop <- read_csv("presvote_pop.csv", show_col_types = FALSE)
colleges <- readxl::read_excel("colleges.xlsx")
universities <- readxl::read_excel("universities.xlsx")
```

## Data Wrangling 


### tidying the colleges dataset 
```{r}
#| label: tidy_data_colleges 
#| eval: true
colleges <- pivot_longer(colleges,
                         cols = c("2023", "2022", "2021", "2020", "2019", 
                                  "2018","2017", "2016", "2015", "2014",
                                  "2013", "2012", "2011", "2010", "2009"),
                         names_to = "year",
                         values_to = "ranking")
colleges
```
### tidying the universities dataset 

```{r}
#| label: tidy_data_universities 
#| eval: true
universities <- pivot_longer(universities,
                         cols = c("2023", "2022", "2021", "2020", "2019", 
                                  "2018","2017", "2016", "2015", "2014",
                                  "2013", "2012", "2011", "2010", "2009"),
                         names_to = "year",
                         values_to = "ranking")
universities 
```

### 
```{r}
#| label: add_column_college
#| eval: true

colleges <- colleges |> 
  mutate(type = "college")

universities <- universities |> 
  mutate(type = "universities")
```


#### combining the two data sets using by the type columns created above 
```{r}
#| label: combining_data
#| eval: true
full_data <- bind_rows(colleges, universities)
full_data
```


## Data Analysis

### Top 5 states with the largest number of schools in the top 100

```{r}
#| label: States_with_5_largest_no_of_schools
#| eval: true
full_data |> 
  filter(year == "2023") |> 
  count(state, sort = TRUE) |> 
  slice(1:5)

```

- The states with the five largest number of schools include: CA, NY, PA, MA,
and IL

### 
```{r}
#| label: renaming_abbrev_to_state
#| eval: true
presvote_pop <- presvote_pop |> 
  rename(state = abbrev)
```

### joining the data set containing schools with the elections an population dataset
```{r}
#| label: Joining_data
#| eval: true
full_data |> 
  right_join(presvote_pop,
             by = "state",
             relationship = "many-to-one") |> 
  rename(population = `2020pop`) |> 
  filter(is.na(school)) |> 
  arrange(desc(population)) |> 
  select("state","population")
```
- 15 states do not have a school in full_data.
- The state with the largest population and does not have a school in full_data
is AZ 

### A plot to show the rankings of specific colleges 

```{r}
#| label: line_plot_for_rankings_over_time 
#| eval: true
#| fig-cap: "A line plot to show the rankings of Vassar College, Kenyon College
#| , Boston University, and University of North Carolina-Chapel Hill over time"
#| fig-alt: >
#|            " The line plot is a plot of year vs rankings, of the different 
#|            schools. The plot shows that Vassar College has been ranked the 
#|            highest among the four schools over time. Boston University's 
#|            rankinga has been increasing over time , while University of North
#|            carolina-Chapel Hill has recieved almost steady rankings over 
#|            time.University of North carolina and Kenyon College recieved the 
#|            same rankings in 2015.
#|            "
full_data |> 
  filter(school %in% c("Vassar College", "Kenyon College", "Boston University",
         "University of North Carolina-Chapel Hill")) |> 
  ggplot(mapping = aes(x = year, y = ranking, group = school, color = school)) +
  geom_line() +
  labs(title = "School rankings over time") +
  scale_color_OkabeIto(labels = c("Boston Uni", "Kenyon College", 
                                  "UNC-Chapel Hill", "Vassar College"))
```
- The plot shows that Vassar College has been ranked the highest among the four 
schools over time. Boston Universitys ranking has been increasing over time , 
while University of North Carolina-Chapel Hill has received almost steady 
rankings over time.University of North Carolina and Kenyon College received the 
same rankings in 2015.

### A plot to show the relationship between population of a state and the number of schools 

```{r}
#| label: relationship_btw_pop_and_number_of_schools
#| eval: true 
#| message: false
#| fig-cap: "A scatterplot and a line of best fit of the number of schools per 
#|          state compared to the population of that state"
#| fig-alt: >
#|            " The plot is supposed to check the number of schools in relation 
#|            the population of specific states. The number of schools is in the
#|            y axis while the population is in the x axis. The plot shows that 
#|            with an increase in the population, there is an increase on the 
#|            number of schools ranked 100 and above. 
#|            "
full_data |> 
  filter(year == 2023) |> 
  count(state) |> 
  left_join(presvote_pop, by = "state", relationship = "many-to-one") |> 
  ggplot(mapping = aes(x = `2020pop`, y = n)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Number of schools in relation to population in specific states",
    x = "Population",
    y = "Number of Schools") +
  scale_color_OkabeIto()
```

- There is a positive relation between the number of schools in a state and the 
population of the given state. The more the population, the higher the number of
schools in the state.
- yes, this is what I would expect because the more the population the more the 
number of schools required to sustain the population in a given area. 
- Yes, most points fall near the line of best fit. 

### Showing the results of the previous elections per state in relation to the number of schools and population 
```{r}
#| label: comapring_colleges_to_universities 
#| eval: true

counts <- full_data |> 
  filter(year == 2023) |> 
  count(type, state) |> 
  pivot_wider(names_from = type,
              values_from = n,
              values_fill = 0) |> 
  left_join(presvote_pop, by = "state", relationship = "many-to-one") |> 
  mutate(biden_pct = (bidenvotes / (bidenvotes + trumpvotes))) |> 
  mutate(winner = if_else(biden_pct > 0.5, "Biden", "Trump"))
counts
```

### Showing the distribution of wins per state. Shows who won in which specific state in the past election 
```{r}
#| label: scatterplot_biden_trump_per_state
#| eval: true
#| fig-cap: "A scatterplot of the number of collges and universities in a 
#|           state. colored by who won the elections in that state. "
#| fig-alt: >
#|            "The plot is a plot of colleges in the x axis and number of 
#|            universities in the y axis colored by the wiining candidate in the
#|            elections. It shows that biden won in the states with the highest 
#|            number of colleges, meaning that he won in states with the 
#|            highest number of population. we also see that Biden won in most 
#|            of the states. 
#|            "
counts |> 
  ggplot(mapping = aes(x = college, y = universities, color = winner)) +
  geom_point() +
  scale_color_OkabeIto()
```

- Biden won in many states. Ho mostly also won the states with the highest 
number of colleges, meaning that he won in the states that had the highest 
number of population as we have seen previously. 
