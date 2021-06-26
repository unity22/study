library(tidyverse)
step_count_raw <- read_csv("data/step-count/step-count.csv",
                           locale = locale(tz = "Australia/Melbourne"))
location <- read_csv("data/step-count/location.csv")
step_count_raw
#QUESTION 1
step_count <- step_count_raw %>%
  rename(
    date_time = `Date/Time`,
    date = Date,
    count = `Step Count (count)`)
step_count
#QUESTION 2
location
step_count_loc <- step_count %>%
  left_join(location)
step_count_loc
sum(is.na(step_count_loc$location))
#QUESTION 3
step_count_full <- step_count_loc %>%
  mutate(location = case_when(
    is.na(location) ~ "Melbourne",
    TRUE ~ location))
)

step_count_full
step_count_full %>% 
  slice(90:95)
#QUESTION 4
step_count_daily <- step_count_full %>%
  group_by(date) %>%
  summarise(daily_count = sum(count))
step_count_daily
#QUESTION 5
step_count_10000 <- step_count_daily %>%
  filter(daily_count >= 10000)
step_count_10000

#QUESTION 4 FUN
p11 <- step_count_daily %>% 
  ggplot(aes(date, daily_count)) +
  geom_hline(yintercept = 10000, colour = "#2b8cbe", linetype = "dashed") +
  geom_col(colour = "white") +
  geom_col(data = step_count_10000, fill = "#e6550d", colour = "white")
p11
