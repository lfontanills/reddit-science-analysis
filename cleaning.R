#import packages for project
library(tidyverse)
library(lubridate)
library(ggplot2)
library(urltools) #package wrangles urls
library(tidytext) #NLP 

# change column 1 name from ...1 to all_time_rank, year_rank, or month_rank
colnames(top_all)[1] <- "all_time_rank"
colnames(top_year)[1] <- "year_rank"
colnames(top_month)[1] <- "month_rank"

# add 1 to all the rankings for clarity
top_all$all_time_rank = top_all$all_time_rank + 1
top_year$year_rank = top_year$year_rank + 1
top_month$month_rank = top_month$month_rank + 1

# combine data frames
top_post_temp <- full_join(top_all, top_year)
top_posts <- full_join(top_post_temp, top_month)

