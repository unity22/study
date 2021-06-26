library(rvest)
course <- "https://stats220.earo.me"
stats220 <- read_html(course)
stats220
weeks <- stats220 %>% 
  html_elements(".post-meta") %>%
  html_text()
weeks
topics <- stats220 %>% 
  html_elements(".panel-title") %>%
  html_text()
topics
images <- stats220 %>% 
  html_elements(".panel.panel-default img") %>%
  html_attr("src")
images
syllabus <- tibble(Week = weeks, Topic = topics, Image = images) %>% 
  mutate(Week = str_extract(Week, pattern = "[0-9]+"))
syllabus

words <- syllabus$Topic %>%
  str_to_lower() %>%
  str_c(collapse = " ") %>%
  str_extract_all("[a-z']+")
result <- tibble(word = words) %>%
  unnest_longer(word) %>%
  group_by(word) %>%
  summarise(n = n()) %>%
  arrange(-n)
result
