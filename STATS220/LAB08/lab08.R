---
  title: "STATS220 R Markdown demo"
author: "Earo Wang"
date: "`r lubridate::today()`"
output: html_document
---
```{r setup, include = FALSE}
# Setup default locale to en_US in Windows 10
Sys.setlocale(category = "LC_ALL", locale = "English_United States.1252")
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


library(dplyr)
daily_aqi <- mutate(daily_aqi,
                    aqi_cat = case_when(
                      max_aqi <= 50 ~ "Good",
                      max_aqi <= 100 ~ "Moderate",
                      max_aqi <= 150 ~ "Unhealthy for Sensitive",
                      max_aqi <= 200 ~ "Unhealthy",
                      max_aqi <= 300 ~ "Very Unhealthy",
                      TRUE ~ "Hazardous"
                    ),
                    month = month(date, label=TRUE, abbr=TRUE),
                    mday = mday(date)
)
aqi_table <- group_by(daily_aqi, month) 
aqi_table
#QUESTION1
table_data <- summarise(aqi_table, 
                        Good = sum(aqi_cat == "Good"),
                        Moderate = sum(aqi_cat == "Moderate"),
                        'Unhealthy for Sensitive' = sum(aqi_cat == "Unhealthy for Sensitive"),
                        Unhealthy = sum(aqi_cat == "Unhealthy"),
                        'Very Unhealthy' = sum(aqi_cat == "Very Unhealthy"),
                        Hazardous = sum(aqi_cat == "Hazardous"),
)
install.packages("kableExtra")
library(kableExtra)
kable(table_data) %>%
  kable_styling() %>%
  kable_material("hover") %>%
  column_spec(6, bold = ifelse(table_data$`Very Unhealthy` >= 1, TRUE, FALSE))

#QUESTION2

library(knitr)
opts_knit$set(root.dir = here::here())
opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE, fig.retina = 3,
               comment = "#>")
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
  labs(y = "Month", x = "Day of the Month") +
  coord_fixed(xlim = c(2,30)) +
  theme(
    panel.background = element_rect(fill = NA),
    panel.grid.major = element_line(colour = "grey90"),
    axis.ticks.length.y = unit(0, 'cm'),
    axis.ticks.length.x = unit(0, 'cm'),
    legend.position = 'top'
  )

