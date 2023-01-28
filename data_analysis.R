library(tidyverse) # data processing and analysis
library(lubridate) # wrangle dates
library(skimr) # skim data frames
library(urltools) # wrangle urls
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud) # Wordclouds

# skim numerical variables
skim(top_month)
skim(top_year)
skim(top_all)

# confirm normal or non-normal distribution (p > 0.05 is normal)
#all non-normal
shapiro.test(top_month$score)
shapiro.test(top_month$num_comments)
shapiro.test(top_month$upvote_ratio)

shapiro.test(top_year$score)
shapiro.test(top_year$num_comments)
shapiro.test(top_year$upvote_ratio)

shapiro.test(top_all$score)
shapiro.test(top_all$num_comments)
shapiro.test(top_all$upvote_ratio)

# explore relationship between topic and score

# Group by topic flair
by_flair_month <- top_month %>% 
  group_by(flair) %>% 
  summarize(count_id=n_distinct(id)) %>% 
  arrange(desc(count_id))
by_flair_month

by_flair_year <- top_year %>% 
  group_by(flair) %>% 
  summarize(count_id=n_distinct(id)) %>% 
  arrange(desc(count_id))
by_flair_year

by_flair_all <- top_all %>% 
  group_by(flair) %>% 
  summarize(count_id=n_distinct(id)) %>% 
  arrange(desc(count_id))
by_flair_all

# What % of top posts belong to the categories health, psych, social sciences?

29+17+13 # month
20+18+18# year
20+16+15 # all

# graph number of posts by flair

coul <- brewer.pal(4, "BuPu")
coul <- colorRampPalette(coul)(25)

by_flair_month %>% 
  ggplot(aes(x = count_id, y=reorder(flair, count_id), fill=flair)) +
  geom_col(show.legend=FALSE) +
  gghighlight(count_id > 10) +
  labs(
    title = "Top r/science posts by topic",
    subtitle = "Top 100 posts from the past month (Dec 2022)",
    x = "Number of Posts",
    y = "Topic"
  ) +
  theme_minimal()


by_flair_year %>% 
  ggplot(aes(x = count_id, y=reorder(flair, count_id), fill=flair)) +
  geom_col(show.legend=FALSE) +
  gghighlight(count_id > 10) +
  labs(
    title = "Top r/science posts by topic",
    subtitle = "Top 100 posts from the past month (Dec 2022)",
    x = "Number of Posts",
    y = "Topic"
  ) +
  theme_minimal()

by_flair_all %>% 
  ggplot(aes(x = count_id, y=reorder(flair, count_id), fill=flair)) +
  geom_col(show.legend=FALSE) +
  gghighlight(count_id > 10) +
  labs(
    title = "Top r/science posts by topic",
    subtitle = "Top 100 posts from the past month (Dec 2022)",
    x = "Number of Posts",
    y = "Topic"
  ) +
  theme_minimal()


# Group by domain name

by_domain_month <- top_month %>% 
  group_by(domain) %>% 
  summarize(count_id=n_distinct(id))

by_domain_year <- top_year %>% 
  group_by(domain) %>% 
  summarize(count_id=n_distinct(id))

by_domain_all <- top_all %>% 
  group_by(domain) %>% 
  summarize(count_id=n_distinct(id))

by_domain_month %>% 
  arrange(desc(count_id))

by_domain_year %>% 
  arrange(desc(count_id))

by_domain_all %>% 
  arrange(desc(count_id))
