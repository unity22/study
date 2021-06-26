library(knitr)
library(rvest)
library(lubridate)
library(tidyverse)
nycbikes18 <- read_csv("data/2018-citibike-tripdata.csv",
                       locale = locale(tz = "America/New_York"))
#QUESTION1
citiBikePricingLink <- "https://www.citibikenyc.com/pricing"
citiBikePage <- read_html(citiBikePricingLink)
citiBikePage
plan <- citiBikePage %>%
  html_elements("h2.type-alpha--l")%>%
  html_text(trim=TRUE) %>%
  head(3)
plan
price <- citiBikePage %>%
  html_elements("p.type-alpha--m") %>%
  html_text(trim=TRUE) 
price
minutes <- citiBikePage %>%
  html_elements("p.type-alpha--s") %>%
  html_text(trim=TRUE) %>%
  head(3)
minutes
table <- tibble(Plan = plan, Price = price, Minutes = minutes)
table
kable(table)

#QUESTION 3
age_brk <- c(0, 14, 24, 34, 44, 54, 64, Inf)
nycbikes18_age <- nycbikes18 %>% 
  mutate(
    tripduration = tripduration / 60,
    birth_year = case_when(birth_year < 1900 ~ NA_real_, TRUE ~ birth_year),
    age = 2018 - birth_year,
    age_group = cut(age, age_brk, include.lowest = TRUE),
    age_group = fct_recode(age_group, "65+" = "(64,Inf]")
  )
p3 <- nycbikes18_age %>% 
  filter(is.na(age_group) == FALSE) %>%
  ggplot(aes(age_group, tripduration)) +
  geom_boxplot(aes(colour = usertype)) +
  scale_y_log10() +
  scale_color_manual(values=c("blue", "red")) +
  labs(title = "Trips durations per Age groups", x = "Age Group", y = "Trip in minutes (on log10)")
p3

#QUESTION 4
plot <- nycbikes18 %>%
  mutate(start = hour(starttime), end = hour(stoptime)) %>%
  ggplot(aes(start, color = usertype)) +
  geom_freqpoly(binwidth = 1) +
  scale_x_continuous(breaks=seq(0,23,1)) +
  coord_cartesian(xlim = c(1, 22)) +
  labs(title= "Starting hour of users", x= "starting hour", y= "number of users")
plot
