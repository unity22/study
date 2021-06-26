library(tidyverse)
library(lubridate)
cn <- c("Quarter", "Region", "Holiday", "Visiting", "Business", "Other")
states <- c("New South Wales", "Victoria", "Queensland", "South Australia",
            "Western Australia", "Tasmania", "Northern Territory", "ACT")
#QUESTION 1
domestic_trips <- read_csv("data/domestic-trips.csv",
                           skip = 11, col_names = cn, n_max = 6804)
domestic_trips
#QUESTION 2
qtr_full <- domestic_trips %>%
  fill(Quarter, .direction = "down") %>%
  filter(Quarter != "Total")
qtr_full
qtr_full %>% 
  filter(Region %in% states)
#QUESTION 3
states_trips <- qtr_full %>%
  mutate(State = case_when(
    Region %in% states ~ Region, TRUE ~ NA_character_)) %>%
  fill(State, .direction = "up") %>%
  filter(!(Region %in% states))
states_trips
states_trips %>% 
  count(State)
#QUESTION 4
tidy_trips <- states_trips %>%
  pivot_longer(Holiday:Other, names_to = "Purchase", values_to = "Trips")
tidy_trips
#QUESTION 5
qtr_trips <- tidy_trips %>%
  mutate(Quarter = parse_date(Quarter, "%B quarter %Y"))
qtr_trips
mean(qtr_trips$Quarter)

