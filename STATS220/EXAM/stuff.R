library(tidyverse)
library(lubridate)
aklweather <- read_delim("data/ghcnd/ghcnd-akl.csv",";")
aklweather
aklweather <- aklweather %>%
  select(date, datatype, value) %>%
  mutate(datatype = tolower(datatype), value = value / 10)

aklweather
aklmonth <- aklweather %>%
  pivot_wider(names_from = datatype, values_from = value) %>%
  group_by(yrmth = floor_date(date, "1 month")) %>%
  summarise(
    prcp = sum(prcp, na.rm = TRUE),
    across(starts_with("t"), mean, na.rm = TRUE)
  )
aklmonth
aklmonth <- aklmonth %>%
  select(yrmth, prcp, tavg, tmax, tmin)
aklmonth
p1 <- aklmonth %>%
  ggplot(aes(yrmth, tavg, ymin = tmin, ymax = tmax)) +
  geom_ribbon(fill = "#e6550d", alpha = 0.8) +
  scale_x_date(date_labels = "%Y %b")
p1
p2 <- aklmonth %>%
  ggplot(aes(x = yrmth, y  = prcp)) +
  geom_bar(stat="identity")
p2
#QUES 7
library(tidyverse)
library(rvest)

site <- "https://stats220.earo.me/pages/data/"
stats220 <- read_html(site)
stats220

links <- stats220 %>%??
  html_elements("li") %>%??
  html_elements("a") %>%??
  html_attr("href") %>%??
  filter(str_extract(".*.csv"))

links <- links[!is.na(links)]
links
?str_extract
#AAAAAAAAA
user_review <- read_tsv("data/animal-crossing/user_reviews.tsv")
user_review
grades <- user_review %>%
  group_by(date) %>%
  summarise(average_grade = mean(grade),  count = n())
grades  
p1 <- ggplot(grades) +
  geom_bar(aes(date, average_grade), fill = "cyan", stat = "identity") +
  geom_bar(aes(date, count/60), stat = "identity")
p1
comment_num <- user_review %>%
  group_by(date) %>%
  count()
comment_num
#----------------------------------------------------------------------------
library(readxl)
time_use <- read_xlsx("data/time-use-oecd.xlsx")
time_use
categories <- time_use 
  
 
  
categories
p3 <- ggplot(categories) +
  geom_bar(aes(x = reorder(Country, -`Time (minutes)`), `Time (minutes)`), stat = "identity" ) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.2))
p3  
p4 <- ggplot(categories) +
  geom_bar(aes(x = Country, y = `Time (minutes)`),stat = "identity") +
  geom_col(aes(x = Country, y = `Time (minutes)`, fill = Category)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.2))
p4
p5 <- ggplot(categories) +
  geom_bar(aes(x = Country, y = `Time (minutes)`),stat = "identity") +
  facet_wrap(vars(Category))
p5
#--------------------------------------------------------------
tuberculosis <- read_csv("data/tb.csv")
tuberculosis
tub <- tuberculosis %>%
  group_by(year) %>%
  select(year, m_65) %>%
  summarise (m_65 = sum(m_65, na.rm = TRUE))
tub
p6 <- ggplot(tub) +
  geom_point(aes(year, m_65),stat = "identity")
p6
#----------------------------------------------------------------
library(scales)
library(tidyverse)
selected <- c("Australia", "Brazil", "Canada", "China", "France", "Germany", 
              "India", "Israel", "Italy", "Japan", "Korea, South", "New Zealand",
              "Spain", "Sweden", "United Kingdom", "US")
covid19 <- read_csv("data/covid19-daily-cases.csv") %>% 
  filter(country_region %in% selected)
covid19
#QUESTION 1
covid19_cases <- covid19 %>%
  mutate(country_region = case_when(
    country_region == "Korea, South" ~ "South Korea",
    TRUE ~ country_region)) %>% 
  group_by(country_region) %>%
  mutate(new_cases = case_when(
    country_region == lag(country_region, 7) ~ confirmed - lag(confirmed, 7))
    )
covid19_cases
#QUESTION 2
covid19_bg <- covid19_cases %>%
  rename(country_region_bg = country_region)

covid19_bg
#QUESTION 3
p1 <- covid19_bg %>%
  ggplot(aes(x = confirmed, y = new_cases
             )) +
  geom_line(colour = "gray80", alpha = 0.4)+
  scale_x_log10(labels = label_number_si()) +
  scale_y_log10(labels = label_number_si()) 
p1
#QUESTION 4
p2 <- p1 +
  geom_line(colour = "firebrick", size = 0.8, data = covid19_cases) +
  facet_wrap(~ fct_reorder(country_region, -confirmed, .fun = last))
p2
#QUESTION 5
p3 <- p2 + 
  labs(
    x = "Total Confirmed Cases",
    y = "New Confirmed Cases (in the Past Week)",
    title = "Trajectory of World COVID-19 Confirmed Cases",
    subtitle = "Data as of 2020-05-31",
    caption = "Data: John Hopkins University, CSSE") + 
    theme(plot.title = element_text(face="bold", size = 8), 
    plot.background = element_rect(fill = "#FFF1E0")) +
    theme_minimal()
p3

```{r setup, include = FALSE}
library(knitr)

opts_knit$set(root.dir = here::here())
opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE, fig.retina = 3,
               comment = "#>")
```

```{r prep}
library(tidyverse)
library(lubridate)
daily_aqi <- read_csv("data/akl-aqi19.csv")
aqi_cat <- fct_inorder(c("Good", "Moderate", "Unhealthy for Sensitive",
                         "Unhealthy", "Very Unhealthy", "Hazardous"))
aqi_pal <- setNames(
  c("#00E400", "#FFFF00", "#FF7E00", "#FF0000", "#8F3F97", "#7E0023"),
  aqi_cat)
```
library(tidyverse)
library(lubridate)
daily_aqi <- read_csv("data/akl-aqi19.csv")
aqi_cat <- fct_inorder(c("Good", "Moderate", "Unhealthy for Sensitive",
                         "Unhealthy", "Very Unhealthy", "Hazardous"))
aqi_pal <- setNames(
  c("#00E400", "#FFFF00", "#FF7E00", "#FF0000", "#8F3F97", "#7E0023"),
  aqi_cat)
daily_aqi
library(dplyr)
get_aqi_cat <- function(x) {                       
  case_when(
    x <= 50 ~ "Good",
    x <= 100 ~ "Moderate",
    x <= 150 ~ "Unhealthy for Sensitive",
    x <= 200 ~ "Unhealthy",
    x <= 300 ~ "Very Unhealthy",
    TRUE ~ "Hazardous"
  ) %>% factor(levels=aqi_cat)
}
Sys.setlocale(category = "LC_ALL", locale = "English_United States.1252")
daily_aqi <- mutate(daily_aqi,
                    aqi_cat = get_aqi_cat(max_aqi),
                    month = month(date, label=TRUE, abbr=TRUE),
                    mday = mday(date)
)
aqi_table <- group_by(daily_aqi, month) 
aqi_table
table_data <- summarise(aqi_table, 
                        Good = sum(aqi_cat == "Good"),
                        Moderate = sum(aqi_cat == "Moderate"),
                        'Unhealthy for Sensitive' = sum(aqi_cat == "Unhealthy for Sensitive"),
                        Unhealthy = sum(aqi_cat == "Unhealthy"),
                        'Very Unhealthy' = sum(aqi_cat == "Very Unhealthy"),
                        Hazardous = sum(aqi_cat == "Hazardous"),
)
# install.packages("kableExtra")
library(kableExtra)
kable(table_data) %>%
  kable_styling() %>%
  kable_material("hover") %>%
  column_spec(6, bold = ifelse(table_data$`Very Unhealthy` >= 1, TRUE, FALSE))
daily_aqi %>% 
  ggplot(aes(mday, month, fill = aqi_cat, label = max_aqi)) +
  geom_tile(width = 0.95, height = 0.95) +
  geom_text(size = 3) +
  scale_fill_manual(
    values = aqi_pal, 
    name = 'AQI', 
    drop = FALSE, 
    labels = aqi_cat,
    guide = guide_legend(nrow = 1)
  ) + 
  scale_y_discrete(limits = rev) +
  scale_x_continuous(breaks = c(10, 20, 30), expand = expansion()) +
  labs(y = "Month", x = "Day of the Month") +
  coord_fixed(xlim = c(2,30)) +
  theme(
    panel.background = element_rect(fill = NA),
    panel.grid.major = element_line(colour = "grey90"),
    axis.ticks.length.y = unit(0, 'cm'),
    axis.ticks.length.x = unit(0, 'cm'),
    legend.position = 'top'
  )
staff <- read_csv("data/staff-contacts.csv")
staff
staff2 <- staff %>%
  mutate(phone = str_extract(contact, "\\+[\\d ]*\\n"),
         email1 = str_extract(contact,"\\@\\")
staff2 


#=================================================================
library(fs)
library(lubridate)
library(tidyverse)
csv_files <- dir_ls("data/aklbus2017", glob = "*.csv")
head(csv_files)
aklbus <- map_dfr(csv_files, read_csv, .id = "path")
aklbus
aklbus_time <- aklbus %>%
  mutate(
  route = str_extract(route, "\\d{5}"),
  datetime = str_extract(path, "\\d{4}-.*[^.csv]"),
  datetime = ymd_hm(datetime, tz = "Pacific/Auckland"),
  path = NULL
) %>% 
  relocate(datetime)
aklbus_time


aklbus_ontime <- aklbus_time %>%
  mutate(ontime_prop = delay > 60 * 5) %>%
  select(route, ontime_prop)
  
aklbus_ontime <- aklbus_time %>% 
  mutate(ontime = between(delay, -5 * 60, 5 * 60)) %>% 
  group_by(route) %>% 
  summarise(ontime_prop = sum(ontime) / n()) %>% 
  arrange(ontime_prop)
aklbus_ontime

aklbus_lst <- aklbus_time %>% 
  filter(route %in% (aklbus_ontime %>% 
                       filter(!ontime_prop %in% c(0, 1)) %>% pull(route))) %>% 
  group_by(route) %>% 
  group_split()
aklbus_lst[[220]]

aklbus_size <- aklbus_lst %>% 
  map(dim)
head(aklbus_size)
#============================================================
animal_crossing_items <- read_csv("data/animal-crossing/items.csv")
animal_crossing_items
drop_nas <- drop_na(animal_crossing_items, orderable)
drop_nas
count_categories <- drop_nas %>%
  count(category, sort = TRUE, name = "category_count")
count_categories
p8 <- count_categories %>%
  ggplot(aes(x = reorder(category,-category_count),y = category_count)) +
  geom_bar(stat = "identity") +
  labs(x = "Categories of items", y = "Number of Items in each category") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.1)) 
  
p8

#=============================================================================
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
    count = `Step Count (count)`
  )
step_count
#QUESTION 2
step_count_loc <- step_count %>% 
  left_join(location)
step_count_loc
sum(is.na(step_count_loc$location))
#QUESTION 3
step_count_full <- step_count_loc %>% 
  mutate(location = case_when(
    is.na(location) ~ "Melbourne", 
    TRUE ~ location))

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

p11 <- step_count_daily %>% 
  ggplot(aes(date, daily_count)) +
  geom_hline(yintercept = 10000, colour = "#2b8cbe", linetype = "dashed") +
  geom_col(colour = "white") +
  geom_col(data = step_count_10000, fill = "#e6550d")
p11

