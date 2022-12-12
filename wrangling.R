#import packages
library(readr)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(urltools) #package wrangles urls
library(tidytext) #NLP 

# create data frame with top 100 posts from the last month
top_month <- read_csv("Top-Posts-Month.csv")
View(top_month)

# create data frame with top 100 posts from the last year
top_year <- read_csv("Top-Posts-Year.csv")
View(top_year)

# create data frame with top 100 posts from all time
top_all <- read_csv("Top-Posts-All.csv")
View(top_all)