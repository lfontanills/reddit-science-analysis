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