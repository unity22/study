library(fs)
library(lubridate)
library(tidyverse)
csv_files <- dir_ls("data/aklbus2017", glob = "*.csv")
head(csv_files)
#QUESTION 1
aklbus <- map_dfr(
   csv_files, read_csv, .id = "path")
aklbus
#QUESTION 2
aklbus_time <- aklbus %>%
  mutate(
    datetime = as.POSIXlt(str_sub(path, 17, 32), format="%Y-%m-%d-%H-%M",tz=Sys.timezone()),
    route = str_sub(route, 0 , 5),
  ) %>%
  select(datetime, delay, stop.id, stop.sequence, route)
akl_bus_time
mean(aklbus_time$datetime)
#QUESTION 3
aklbus_ontime <- aklbus_time %>%
  group_by(route) %>%
  mutate(
    ontime = sum(abs(delay / 60) <= 5),
    overtime = sum(abs(delay / 60) > 5),
  ) %>%
  mutate(
    ontime_prop = ontime / (ontime + overtime)
  ) %>%
  select(route, ontime_prop) %>%
  summarise(ontime_prop = first(ontime_prop)) %>%
  arrange(ontime_prop)
aklbus_ontime
#QUESTION 4
aklbus_lst <- aklbus_time %>%
  group_by(route) %>%
  mutate(
    ontime = sum(abs(delay / 60) <= 5),
    overtime = sum(abs(delay / 60) > 5),
  ) %>%
  filter(ontime > 0 && overtime > 0) %>%
  select(datetime, delay, stop.id, stop.sequence, route) %>%
  group_split()
aklbus_lst[[220]]
length(aklbus_lst)
#QUESTION 5
table_size <- function(x) c(nrow(x), ncol(x))
aklbus_size <- map(aklbus_lst, table_size)
head(aklbus_size)
