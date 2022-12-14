library(tidyverse) # data cleaning
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud) # Wordclouds
library(readr)

science_texts <- read_csv("science nature titles - Sheet1.csv")
science_texts

# restructure one token per row: unnest tokens
tidy_science <-science_texts %>% 
  unnest_tokens(word, titles)
tidy_science

# remove stop words

data("stop_words")

# customize stop words
custom_stop_words <- bind_rows(tibble(word = c(1:2022),
                                      lexicon = c("custom")),
                               stop_words)

tidy_science <- tidy_science %>% 
  anti_join(custom_stop_words)
tidy_science

tidy_science %>% 
  count(word, sort = TRUE)

frequency_2 <- bind_rows(mutate(tidy_month, timeframe = "month"),
                       mutate(tidy_year, timeframe = "year"),
                       mutate(tidy_science, timeframe = "journals")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  count(timeframe, word) %>% 
  group_by(timeframe) %>% 
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  pivot_wider(names_from = timeframe, values_from = proportion) %>% 
  pivot_longer(`month`:`year`,
               names_to = "timeframe", values_to = "proportion")

frequency_2

cor.test(data = frequency_2[frequency_2$timeframe == "month",],
         ~ proportion + `journals`)

cor.test(data = frequency_2[frequency_2$timeframe == "year",],
         ~ proportion + `journals`)

## add more data pints from popular science psych/social science sources
