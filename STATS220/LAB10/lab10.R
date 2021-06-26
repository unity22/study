library(ggrepel)
library(tidytext)
library(tidyverse)
rm_words <- c("animal", "crossing", "horizons", "game", "nintendo", 
              "switch", "series", "island")
critic <- read_tsv("data/animal-crossing/critic.tsv")
critic

#QUESTION1
critic_tokens <- critic %>%
  unnest_tokens(output = word, input = text)
critic_tokens

#QUESTION2
stopwords_smart <- get_stopwords(source = "smart")
critic_smart <- critic_tokens %>%
  anti_join(stopwords_smart)
critic_smart 

#QUESTION3
p1 <- critic_smart %>%
  filter(!(word %in% rm_words)) %>%
  count(word) %>%
  slice_max(n, n = 20) %>% 
  ggplot(aes(x = n, y = fct_reorder(word, n))) +
  geom_col() +
  labs(x = "Frequency of words", y = "")
p1

#QUESTION4
sentiments_bing <- get_sentiments("bing")
critic_sentiments <- critic_smart  %>%
  inner_join(sentiments_bing) %>%
  count(sentiment, word, sort = FALSE) %>%
  arrange(n,desc(n))
critic_sentiments

#QUESTION5
p2 <- critic_sentiments %>%
    group_by(sentiment) %>%
    ggplot(aes(x = 0, y = 0, label = word, colour = sentiment,size = n)) +
    scale_colour_manual(values = c("#4d9221", "#c51b7d")) +
    theme_bw() +
    theme(
      legend.position = "none",
      axis.title = element_blank(), 
      axis.ticks = element_blank(),
      axis.text = element_blank(),
    ) +
    facet_grid(cols = vars(sentiment)) +
    facet_grid(~factor(sentiment,levels = c("positive", "negative"))) +
    geom_text_repel(force_pull = 0, max.overlaps = Inf, segment.color = NA, point.padding = NA, seed = 220)
p2


