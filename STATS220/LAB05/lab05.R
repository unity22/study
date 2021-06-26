library(lubridate)
library(tidyverse)
step_count_raw <- read_csv("data/step-count/step-count.csv",
                           locale = locale(tz = "Australia/Melbourne"))
location <- read_csv("data/step-count/location.csv")
step_count <- step_count_raw %>% 
  rename_with(~ c("date_time", "date", "count")) %>% 
  left_join(location) %>% 
  mutate(location = replace_na(location, "Melbourne"))
step_count
#QUESTION 1
city_avg_step <- step_count %>%
  group_by(location, date) %>%
  summarise(daily_count = sum(count))%>%
  summarise(avg_count = mean(daily_count))
city_avg_step
#QUESTION 2
p1 <- city_avg_step %>%
  mutate(location = fct_reorder(location,avg_count))%>%
  ggplot(aes(location, avg_count)) +
  geom_point(size = 4, colour = "#dd1c77") +
  geom_segment(aes(xend=location,y=0,yend=avg_count))
p1
#QUESTION 3
step_count_time <- step_count %>% 
  mutate(
    time = as_factor(hour(date_time)),
    country = case_when(location == "Melbourne" ~ "AU", TRUE ~ "US")
  )
step_count_time
levels(step_count_time$time)
step_count_time %>% 
  filter(country == "US")
#QUESTION 4
p2 <- step_count_time %>%
  ggplot(aes(time, count)) +
  geom_boxplot(outlier.size = 1)
p2
#QUESTION 5
p3 <- p2 +
  facet_grid(rows = vars(country))
p3

#QUESTION 4
p4 <- step_count_time %>%
  ggplot(aes(time, count), stat = "identity") +
  geom_jitter(aes(x = time, y = count, position_jitter(0.3, seed = 220), alpha = 0.5))
p4


step_count_time
location

lock_local_time <- function(x, tz) {
  force_tz(with_tz(x, tz = tz), tzone = "Australia/Melbourne")
}

austin <- step_count_time %>% filter(location == "Austin") %>% pull(date)
denver <- step_count_time %>% filter(location == "Denver") %>% pull(date)
sf <- step_count_time %>% filter(location == "San Francisco") %>% pull(date)

local_step_count <- step_count_time %>% 
  mutate(
    date_time = case_when(
      date %in% austin ~ lock_local_time(date_time, tz = "US/Central"),
      date %in% denver ~ lock_local_time(date_time, tz = "US/Mountain"),
      date %in% sf ~ lock_local_time(date_time, tz = "US/Pacific"),
      TRUE ~ date_time
    ),
    time = hour(date_time)
  )

local_step_count %>% 
  ggplot(aes(x = time, y = count)) +
  geom_jitter(position = position_jitter(0.3, seed = 220), alpha = 0.5)

?function
?force_tz
?with_tz
?tz
??function
