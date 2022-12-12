
# import top posts - last month
library(readr)
Top_Posts_Month <- read_csv("Top Posts Month.csv")

# inspect dataset
head(Top_Posts_Month)
str(Top_Posts_Month)

Top_Posts_Month$Rank <- Top_Posts_Month$...1 + 1
head(Top_Posts_Month)    
