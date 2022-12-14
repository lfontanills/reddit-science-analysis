#import packages for project

library(tidyverse) # data cleaning
library(tidytext) #NLP toolkit

# subset dataframes with title text, flair, domain

text_month <- top_month %>% 