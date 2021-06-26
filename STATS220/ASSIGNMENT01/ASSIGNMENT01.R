library(tidyverse)
#QUESTION 1
nycbikes18_raw <- read_csv("data/2018-citibike-tripdata.csv")
nycbikes18_raw
#QUESTION 2
library(ggplot2)
p1 <- ggplot(nycbikes18_raw, aes(x = birth_year,fill = usertype)) + geom_bar(colour = "white")
p1
#QUESTION 3
library(dplyr)
nycbikes18 <- filter(nycbikes18_raw,birth_year > 1900)
nycbikes18
#QUESTION 4
ttl_tripd <- sum(nycbikes18$tripduration)
ttl_tripd
#QUESTION 5
n_bikes <- length(unique(nycbikes18$bikeid))
n_bikes
#QUESTION 6
p2 <- ggplot(nycbikes18, aes(x = usertype)) + geom_bar()
p2
#QUESTION 7
p3 <- ggplot(nycbikes18, aes(x = gender, fill = usertype)) + geom_bar(position = "dodge")
p3
#QUESTION 8
p4 <- ggplot(nycbikes18, aes(birth_year,tripduration))+ facet_grid(rows = vars(usertype), cols = vars(gender)) + geom_point(size = 0.5)
p4
#QUESTION 9
p5 <- ggplot(nycbikes18) + geom_point(aes(start_station_longitude,start_station_latitude)) + geom_point(aes(end_station_longitude,end_station_latitude))
p5             
#QUESTION 10
p6 <- ggplot(nycbikes18) + geom_segment(aes(x=start_station_longitude, y=start_station_latitude, xend=end_station_longitude, yend=end_station_latitude), arrow = arrow(length = unit(0.01, "npc")), alpha = 0.3)
p6
