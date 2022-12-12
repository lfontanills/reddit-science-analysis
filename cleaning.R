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

  
  



