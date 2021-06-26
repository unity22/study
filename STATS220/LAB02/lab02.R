library(readr)
#QUESTION 1
user_reviews <- read_tsv("data/animal-crossing/user_reviews.tsv")
user_reviews 
#QUESTION 2
user_grade <- user_reviews[[1]]
mean(user_grade)
#QUESTION 3
good_grade <- user_grade >= 7
typeof(good_grade)
sum(good_grade)
#QUESTION 4
user_good_grade <- user_reviews[good_grade,-3]
user_good_grade
#QUESTION 5
gapminder <- read_rds("data/gapminder.rds")
gapminder

