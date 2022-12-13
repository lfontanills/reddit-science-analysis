#import packages for project
library(tidyverse)
library(lubridate)
library(ggplot2)
library(urltools) #package wrangles urls
library(tidytext) #NLP 

# before combining data frames, add a column indicating if it was a top "month", "year", or "all" post.
top_all_2 <- top_all %>% 
  mutate(all_time = TRUE) %>% 
  mutate(past_year = FALSE) %>% 
  mutate(past_month = FALSE)

top_year_2 <- top_year %>%
  mutate(all_time = FALSE) %>% 
  mutate(past_year = TRUE) %>% 
  mutate(past_month = FALSE)

top_month_2 <- top_month %>% 
  mutate(all_time = FALSE) %>% 
  mutate(past_year = FALSE) %>% 
  mutate(past_month = TRUE)

#


# create new column with post rank #1-100
top_month$rank <- top_month$...1 + 1
head(Top_Posts_Month)  

# rename 'Created UTC'
colnames(Top_Posts_Month)[3] = "Created unix"

# create new column with post creation datetime
Top_Posts_Month$`Created utc` <- as_datetime(Top_Posts_Month$`Created unix`)

# create new column with domain names
Top_Posts_Month$`Domain` <- domain(Top_Posts_Month$`Post URL`)


# clean titles: remove case, punctuation, numerics, whitespace
Top_Posts_Month$`Clean Title` <- tolower(Top_Posts_Month$Title)
Top_Posts_Month$`Clean Title` <- gsub("[[:punct:]]", "", Top_Posts_Month$`Clean Title`)
Top_Posts_Month$`Clean Title` <- gsub("[[:digit:]]", "", Top_Posts_Month$`Clean Title`)
Top_Posts_Month$`Clean Title` <- gsub("\\s+", " ", str_trim(Top_Posts_Month$`Clean Title`))

  
  



