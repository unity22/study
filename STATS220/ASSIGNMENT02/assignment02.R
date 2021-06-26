library(lubridate)
library(tidyverse)
nycbikes18 <- read_csv("data/2018-citibike-tripdata.csv",
                       locale = locale(tz = "America/New_York"))
nycbikes18
#QUESTION 1
p1 <- nycbikes18 %>%
  ggplot() +
  geom_count(aes(start_station_longitude, start_station_latitude),
             alpha = 0.5) +
  geom_count(aes(end_station_longitude, end_station_latitude),
             alpha = 0.5)
p1
#QUESTION 2
most_used_bike <- nycbikes18 %>% 
  count(bikeid, sort = TRUE) %>% 
  pull(bikeid) %>% 
  first()
most_used_bike
top_bike_trips <- nycbikes18 %>% 
  filter(bikeid == most_used_bike)
top_bike_trips

?filter
#QUESTION 3
p2 <- top_bike_trips %>% 
  ggplot(aes(start_station_longitude, start_station_latitude)) +
  geom_segment(
    aes(xend = end_station_longitude, yend = end_station_latitude),
    alpha = 0.5)
p2
#QUESTION 4
age_brk <- c(0, 14, 24, 44, 64, Inf)
nycbikes18_age <- nycbikes18 %>% 
  mutate(
    tripduration = tripduration / 60,
    birth_year = case_when(birth_year < 1900 ~ NA_real_, TRUE ~ birth_year),
    age = 2018 - birth_year,
    age_group = cut(age, age_brk, include.lowest = TRUE),
    age_group = fct_recode(age_group, "65+" = "(64,Inf]")
  )

?fct_recode
glimpse(nycbikes18_age)
sum(is.na(nycbikes18_age$birth_year))
mean(nycbikes18_age$age, na.rm = TRUE)
levels(nycbikes18_age$age_group)
#QUESTION 5
p3 <- nycbikes18_age %>% 
  ggplot(aes(age_group, tripduration)) +
  geom_boxplot(aes(colour = usertype)) +
  scale_y_log10() +
  labs(x = "Age Group", y = "Trip in minutes (on log10)")
p3
#QUESTION 6
p4 <- nycbikes18 %>% 
  group_by(month = month(starttime, label = TRUE), gender) %>% 
  summarise(ntrips = n()) %>% 
  ungroup() %>% 
  mutate(gender = fct_recode(fct_reorder(as_factor(gender), ntrips),
                             "unknown" = "0", "male" = "1", "female" = "2")) %>%
  ggplot(aes(gender, ntrips)) +
  geom_col(aes(fill = month), position = "dodge")
p4

?n
?group_by
?month
?fct_reorder
?as_factor
?geom_col
#QUESTION 7
p5 <- nycbikes18_age %>% 
  group_by(month = month(starttime, label = TRUE), age_group) %>% 
  summarise(qtl_tripd = quantile(tripduration, 0.75)) %>% 
  mutate(age_group = fct_reorder2(age_group, month, qtl_tripd)) %>% 
  ungroup() %>% 
  ggplot(aes(month, qtl_tripd, group = age_group)) +
  geom_line(aes(colour = age_group))
p5
#QUESTION 8
user_behaviours <- nycbikes18_age %>% 
  group_by(age_group) %>% 
  filter(tripduration > quantile(tripduration, 0.9)) %>% 
  group_by(usertype, age_group) %>% 
  summarise(ntrips = n()) %>% 
  rename(`Age Group` = age_group) %>% 
  pivot_wider(names_from = usertype, values_from = ntrips)
user_behaviours
#QUESTION 9
hourly_ntrips <- nycbikes18 %>% 
  mutate(starttime = floor_date(starttime, "1 hour")) %>% 
  group_by(starttime, usertype) %>% 
  summarise(ntrips = n()) %>% 
  ungroup() %>% 
  mutate(
    startdate = as_date(starttime),
    starthour = hour(starttime),
    startwday = wday(starttime, label = TRUE, week_start = 1)
  )
hourly_ntrips
mean(hourly_ntrips$starttime)
mean(hourly_ntrips$ntrips)
levels(hourly_ntrips$startwday)
#QUESTION 10
avg_ntrips <- hourly_ntrips %>% 
  group_by(starthour, startwday, usertype) %>% 
  summarise(ntrips = mean(ntrips))
p6 <- hourly_ntrips %>% 
  ggplot(aes(starthour, ntrips)) +
  geom_line(aes(group = startdate), colour = "#bdbdbd", alpha = 0.5) +
  geom_line(aes(group = startwday, colour = startwday), size = 1,
            data = avg_ntrips) +
  facet_grid(usertype ~ startwday, scales = "free_y") +
  theme_bw()
p6

?quantile
?fct_reorder2
?floor_date
?as_date
?hour
?wday
?facet_grid
?facet_wrap
