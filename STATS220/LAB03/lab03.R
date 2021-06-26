library(tidyverse)
villagers <- read_csv("data/animal-crossing/villagers.csv")
villagers
#QUESTION 1
p1 <- ggplot(villagers, aes(x = personality)) + 
  geom_bar()
p1
#QUESTION 2
p2 <- ggplot(villagers, aes(x = personality, fill = gender)) + 
  geom_bar() 
p2
#QUESTION 3
p3 <- ggplot(villagers, aes(x = personality, fill = gender)) + 
  geom_bar(colour = "black") 
p3
#QUESTION 4
p4 <- p3 +
  coord_polar()
p4
#QUESTION 5
p5 <- p4 +
  facet_wrap(vars(species))
p5


