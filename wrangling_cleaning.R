#import packages for project
library(tidyverse)
library(lubridate)
library(ggplot2)
library(urltools) #package wrangles urls
library(tidytext) #NLP 

#import packages
library(readr)

# create and view data frame with top 100 posts from the last month
top_month <- read_csv("Top-Posts-Month.csv")
View(top_month)

# create and view data frame with top 100 posts from the last year
top_year <- read_csv("Top-Posts-Year.csv")
View(top_year)

# create view data frame with top 100 posts from all time
top_all <- read_csv("Top-Posts-All.csv")
View(top_all)


# change column 1 name from ...1 to all_time_rank, year_rank, or month_rank
colnames(top_all)[1] <- "all_time_rank"

colnames(top_year)[1] <- "year_rank"

colnames(top_month)[1] <- "month_rank"

# add 1 to all the rankings for clarity
top_all$all_time_rank = top_all$all_time_rank + 1

top_year$year_rank = top_year$year_rank + 1

top_month$month_rank = top_month$month_rank + 1

# change created_unix_utc to a datetime
top_all$created_utc <- as_datetime(top_all$created_unix_utc)

top_year$created_utc <- as_datetime(top_year$created_unix_utc)

top_month$created_utc <- as_datetime(top_month$created_unix_utc)

# make column with domain name only
top_all$domain <- domain(top_all$post_url)

top_year$domain <- domain(top_year$post_url)

top_month$domain <- domain(top_month$post_url)
