library(tidyverse) # data processing and analysis
library(lubridate) # wrangle dates
library(skimr) # skim data frames
library(urltools) # wrangle urls
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud2) # Wordclouds
library(gghighlight) # Adding to graphs

# create view data frame with top 100 posts from all time
top_all <- read_csv("Top-Posts-All.csv")

# create and view data frame with top 100 posts from the last year
top_year <- read_csv("Top-Posts-Year.csv")

# create and view data frame with top 100 posts from the last month
top_month <- read_csv("Top-Posts-Month.csv")


# check that all rows are unique

n_distinct(top_all$id) == nrow(top_all)
n_distinct(top_year$id) == nrow(top_year)
n_distinct(top_month$id) == nrow(top_month)

# change column 1 name from ...1 to rank
colnames(top_all)[1] <- "all_rank"
colnames(top_year)[1] <- "year_rank"
colnames(top_month)[1] <- "month_rank"

glimpse(top_all)

# add 1 to all the rankings for clarity
top_all$all_rank = top_all$all_rank + 1

top_year$year_rank = top_year$year_rank + 1

top_month$month_rank = top_month$month_rank + 1

# check post rankings are between 1 and 100

summary(top_all)
summary(top_year)
summary(top_month)

# change created_unix_utc to a datetime
top_all$created_utc <- as_datetime(top_all$created_unix_utc)

top_year$created_utc <- as_datetime(top_year$created_unix_utc)

top_month$created_utc <- as_datetime(top_month$created_unix_utc)

# make column with domain name only
top_all$domain <- domain(top_all$post_url)

top_year$domain <- domain(top_year$post_url)

top_month$domain <- domain(top_month$post_url)

head(top_all)

# make cleaned dfs

all_clean <- top_all
year_clean <- top_year
month_clean <- top_month

# export cleaned files as csvs
write.csv(all_clean, file = "~/Documents/Projects/reddit-science/all_clean.csv")
write.csv(year_clean, file = "~/Documents/Projects/reddit-science/year_clean.csv")
write.csv(month_clean, file = "~/Documents/Projects/reddit-science/month_clean.csv")

#import packages for project

library(tidyverse) # data cleaning
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud) # Wordclouds


# subset dataframes with title text, flair, domain

text_all <- month_clean[c("post_title")]
text_year <- year_clean[c("post_title")]
text_month <- all_clean[c("post_title")]

# restructure one token per row: unnest tokens
text_all <- text_all %>% 
  unnest_tokens(word, post_title)

text_year <- text_year %>% 
  unnest_tokens(word, post_title)

text_month <-text_month %>% 
  unnest_tokens(word, post_title)

# remove stop words

data("stop_words")

text_all <- text_month %>% 
  anti_join(stop_words)

text_year<- text_year %>% 
  anti_join(stop_words)

text_month <- text_month %>% 
  anti_join(stop_words)

# check word frequencies for each period

text_all %>% 
  count(word, sort = TRUE) %>% 
  head(20)

text_year %>% 
  count(word, sort = TRUE) %>% 
  head(20)

text_month %>% 
  count(word, sort = TRUE) %>% 
  head(20)

# make custom stopword lists

stop_nums<- as.data.frame(as.character(1:10000))
colnames(stop_nums)[1] <- "word"

stop_science <- c("study", "found", "scientist", "scientists", "research", "researchers", "suggests", "finding")
stop_science <- as.data.frame(stop_science)
colnames(stop_science)[1] <- "word"

text_all_clean <- text_all %>% 
  anti_join(stop_nums) %>% 
  anti_join(stop_science)

text_year_clean <- text_year %>% 
  anti_join(stop_nums) %>% 
  anti_join(stop_science)

text_month_clean <- text_month %>% 
  anti_join(stop_nums) %>% 
  anti_join(stop_science)


# find most common words

text_all_clean %>% 
  count(word, sort = TRUE) %>% 
  head(20)

text_year_clean %>% 
  count(word, sort = TRUE) %>% 
  head(20)

text_month_clean %>% 
  count(word, sort = TRUE) %>% 
  head(20)

# Export to csv
write.csv(text_all_clean, "~/Documents/Projects/reddit-science/text_all_clean.csv")
write.csv(text_year_clean, "~/Documents/Projects/reddit-science/text_year_clean.csv")
write.csv(text_month_clean, "~/Documents/Projects/reddit-science/text_month_clean.csv")

