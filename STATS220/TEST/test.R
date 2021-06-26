library(tidyverse)
items <- read_csv("data/animal-crossing/items.csv")
items
id_full <- items[[15]]
type <- typeof(id_full)
#p1 <- ggplot(items,aes(x=category,y=buy_value))+layer(geom=boxplot(),stat
#p1


category <- items[[4]]
group <- group_by(items[[8]])
