library(tidyverse) # data processing and analysis
library(lubridate) # wrangle dates
library(skimr) # skim data frames
library(urltools) # wrangle urls
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud2) # Wordclouds

# skim numerical variables
skim(all_clean)
skim(year_clean)
skim(month_clean)

# confirm normal or non-normal distribution (p > 0.05 is normal)
# all non-normal
shapiro.test(month_clean$score)
shapiro.test(month_clean$num_comments)
shapiro.test(month_clean$upvote_ratio)

shapiro.test(year_clean$score)
shapiro.test(year_clean$num_comments)
shapiro.test(year_clean$upvote_ratio)

shapiro.test(all_clean$score)
shapiro.test(all_clean$num_comments)
shapiro.test(all_clean$upvote_ratio)

# quick viz: post rank vs. num_comments, post_rank vs. score, post_rank vs. upvote ratio

# comments

top_posts_2 %>% 
  ggplot(aes(x=all_rank, y = num_comments)) +
  geom_point() +
  geom_smooth()

top_year %>% 
  ggplot(aes(x=year_rank, y = num_comments)) +
  geom_point() +
  geom_smooth()

top_month %>% 
  ggplot(aes(x=month_rank, y = num_comments)) +
  geom_point() +
  geom_smooth()

# score
top_all %>% 
  ggplot(aes(x=all_rank, y = score)) +
  geom_point() +
  geom_smooth()

top_year %>% 
  ggplot(aes(x=year_rank, y = score)) +
  geom_point() +
  geom_smooth()

top_month %>% 
  ggplot(aes(x=month_rank, y = score)) +
  geom_point() +
  geom_smooth()

# upvote ratio

top_all %>% 
  ggplot(aes(x=all_rank, y = upvote_ratio)) +
  geom_point() +
  geom_smooth()

top_year %>% 
  ggplot(aes(x=year_rank, y = upvote_ratio)) +
  geom_point() +
  geom_smooth()

top_month %>% 
  ggplot(aes(x=month_rank, y = upvote_ratio)) +
  geom_point() +
  geom_smooth()

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

top_month %>% 
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
