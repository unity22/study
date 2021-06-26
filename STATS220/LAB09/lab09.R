library(rvest)
library(tidyverse)
link <- "https://www.imdb.com/search/title/?title_type=feature&num_votes=25000,&genres=horror&sort=user_rating,desc&view=simple&sort=user_rating"
horror <- read_html(link)
horror
#QUESTION1
film_poster <- horror %>% 
  html_elements("img.loadlate") %>%
  html_attr("loadlate")
head(film_poster)
#QUESTION2
movie <- horror %>%
  html_elements("img.loadlate") %>%
  html_attr("alt")
head(movie)
#QUESTION3
year <- horror %>%
  html_elements("span.lister-item-year") %>%
  html_text()%>% 
  str_extract("[0-9]+") %>%
  as.double()
year
#QUESTION4
rating <- horror %>%
  html_elements(".col-imdb-rating strong") %>%
  html_text(trim=TRUE) %>%
  as.double()
rating
#QUESTION5
rank <- horror %>%
  html_elements(".lister-item-index") %>%
  html_text(trim=TRUE) %>%
  as.integer()
top50_horror <- tibble(
  Rank = rank, Poster = film_poster, Movie = movie, Year = year, Rating = rating
)
top50_horror

