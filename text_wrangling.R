#import packages for project

library(tidyverse) # data cleaning
library(tidytext) #NLP toolkit

# subset dataframes with title text, flair, domain

text_month <- top_month[,c("month_rank","id", "flair", "domain", "post_title")]
text_year <- top_year[,c("year_rank","id", "flair", "domain", "post_title")]
text_all <- top_all[,c("all_time_rank","id", "flair", "domain", "post_title")]

# restructure one token per row: unnest tokens
tidy_month <-text_month %>% 
  unnest_tokens(word, post_title)
tidy_month

tidy_year <- text_year %>% 
  unnest_tokens(word, post_title)
tidy_year

tidy_all <- text_all %>% 
  unnest_tokens(word, post_title)
tidy_all

# remove stop words

data("stop_words")

tidy_month <- tidy_month %>% 
  anti_join(stop_words)

# find most common words

tidy_month %>% 
  count(word, sort = TRUE)


