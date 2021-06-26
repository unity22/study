library(scales)
library(tidyverse)
selected <- c("Australia", "Brazil", "Canada", "China", "France", "Germany", 
              "India", "Israel", "Italy", "Japan", "Korea, South", "New Zealand",
              "Spain", "Sweden", "United Kingdom", "US")
covid19 <- read_csv("data/covid19-daily-cases.csv") %>% 
filter(country_region %in% selected)
covid19
#QUESTION1
library(dplyr)
covid19_cases <- mutate(covid19, new_cases = case_when(
country_region == lag(country_region, 7, default = NA) ~ confirmed - lag(confirmed, 7, default = NA),),
country_region = case_when(country_region == "Korea, South" ~ "South Korea",TRUE ~ country_region))
covid19_cases
#QUESTION2
covid19_bg <- covid19_cases %>%
rename(country_region_bg = country_region)
covid19_bg
#QUESTION3
library(ggplot2)
p1 <- ggplot(covid19_bg,aes(x=confirmed,y=new_cases,factor=country_region_bg)) + 
  scale_x_log10(labels = label_number_si()) + 
  scale_y_log10(labels = label_number_si()) + 
  geom_line(colour="gray80",size = 0.4)
p1
#QUESTION4
sample <- subset(covid19_cases, date == '2020-05-31')
sample <- sample[order(sample$confirmed, decreasing=T),]
ordered_cases <- 
  transform(covid19_cases, 
            country_region=factor(country_region,levels=sample$country_region))
ordered_cases$country_region_bg <- ordered_cases$country_region
p2 <- 
  ggplot(ordered_cases, aes(x=confirmed,y=new_cases,group=country_region)) +
  scale_x_log10(labels = label_number_si()) +
  scale_y_log10(labels = label_number_si()) +
  geom_line(data=ordered_cases[,2:5], aes(x=confirmed,y=new_cases,group=country_region_bg), colour="gray80",size = 0.4) +
  geom_line(colour = "firebrick", size = 0.8) +
  guides(colour = FALSE) +
  facet_wrap(~ country_region)
p2
#QUESTION5
p3 <- p2 +
  labs(
    x = "Total Confirmed Cases",
    y = "New Confirmed Cases (in the Past Week)",
    title = "Trajectory of World COVID-19 Confirmed Cases",
    subtitle = "Data as of 2020-05-31",
    caption = "Data source: John Hopkins University, CSSE")+
    theme_minimal()+ theme(text = element_text(size=8),plot.title = element_text(face = "bold"))
p3  
