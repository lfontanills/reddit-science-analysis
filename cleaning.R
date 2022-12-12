#import packages
library(tidyverse)
library(lubridate)
library(ggplot2)
library(urltools) #package wrangles urls
library(tidytext) #NLP 

# import top posts - last month
library(readr)
Top_Posts_Month <- read_csv("Top Posts Month.csv")

# inspect dataset
head(Top_Posts_Month)
str(Top_Posts_Month)

# create new column with post rank #1-100
Top_Posts_Month$Rank <- Top_Posts_Month$...1 + 1
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

  
  



