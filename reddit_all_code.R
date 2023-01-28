## Data cleaning

#import packages for project
library(tidyverse) # data processing and analysis
library(lubridate) # wrangle dates
library(skimr) # skim data frames
library(urltools) # wrangle urls
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud2) # Wordclouds
library(gghighlight) # Adding to graphs

# create view data frame with top 100 posts from all time
top_all <- read_csv("Top-Posts-All.csv")

# create and view data frame with top 100 posts from the last year
top_year <- read_csv("Top-Posts-Year.csv")

# create and view data frame with top 100 posts from the last month
top_month <- read_csv("Top-Posts-Month.csv")


# check that all rows are unique

n_distinct(top_all$id) == nrow(top_all)
n_distinct(top_year$id) == nrow(top_year)
n_distinct(top_month$id) == nrow(top_month)

# change column 1 name from ...1 to rank
colnames(top_all)[1] <- "all_rank"
colnames(top_year)[1] <- "year_rank"
colnames(top_month)[1] <- "month_rank"

glimpse(top_all)

# add 1 to all the rankings for clarity
top_all$all_rank = top_all$all_rank + 1

top_year$year_rank = top_year$year_rank + 1

top_month$month_rank = top_month$month_rank + 1

# check post rankings are between 1 and 100

summary(top_all)
summary(top_year)
summary(top_month)

# change created_unix_utc to a datetime
top_all$created_utc <- as_datetime(top_all$created_unix_utc)

top_year$created_utc <- as_datetime(top_year$created_unix_utc)

top_month$created_utc <- as_datetime(top_month$created_unix_utc)

# make column with domain name only
top_all$domain <- domain(top_all$post_url)

top_year$domain <- domain(top_year$post_url)

top_month$domain <- domain(top_month$post_url)

head(top_all)

# make cleaned dfs

all_clean <- top_all
year_clean <- top_year
month_clean <- top_month

# export cleaned files as csvs
write.csv(all_clean, file = "~/Documents/Projects/reddit-science/all_clean.csv")
write.csv(year_clean, file = "~/Documents/Projects/reddit-science/year_clean.csv")
write.csv(month_clean, file = "~/Documents/Projects/reddit-science/month_clean.csv")


# subset dataframes with title text, flair, domain

text_all <- month_clean[c("post_title")]
text_year <- year_clean[c("post_title")]
text_month <- all_clean[c("post_title")]

# restructure one token per row: unnest tokens
text_all <- text_all %>% 
  unnest_tokens(word, post_title)

text_year <- text_year %>% 
  unnest_tokens(word, post_title)

text_month <-text_month %>% 
  unnest_tokens(word, post_title)

# remove stop words

data("stop_words")

text_all <- text_month %>% 
  anti_join(stop_words)

text_year<- text_year %>% 
  anti_join(stop_words)

text_month <- text_month %>% 
  anti_join(stop_words)

# check word frequencies for each period

text_all %>% 
  count(word, sort = TRUE) %>% 
  head(20)

text_year %>% 
  count(word, sort = TRUE) %>% 
  head(20)

text_month %>% 
  count(word, sort = TRUE) %>% 
  head(20)

# make custom stopword lists

stop_nums<- as.data.frame(as.character(1:10000))
colnames(stop_nums)[1] <- "word"

stop_science <- c("study", "found", "scientist", "scientists", "research", "researchers", "suggests", "finding")
stop_science <- as.data.frame(stop_science)
colnames(stop_science)[1] <- "word"

text_all_clean <- text_all %>% 
  anti_join(stop_nums) %>% 
  anti_join(stop_science)

text_year_clean <- text_year %>% 
  anti_join(stop_nums) %>% 
  anti_join(stop_science)

text_month_clean <- text_month %>% 
  anti_join(stop_nums) %>% 
  anti_join(stop_science)


# find most common words

text_all_clean %>% 
  count(word, sort = TRUE) %>% 
  head(20)

text_year_clean %>% 
  count(word, sort = TRUE) %>% 
  head(20)

text_month_clean %>% 
  count(word, sort = TRUE) %>% 
  head(20)

# Export to csv
write.csv(text_all_clean, "~/Documents/Projects/reddit-science/text_all_clean.csv")
write.csv(text_year_clean, "~/Documents/Projects/reddit-science/text_year_clean.csv")
write.csv(text_month_clean, "~/Documents/Projects/reddit-science/text_month_clean.csv")

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

all_clean %>% 
  ggplot(aes(x=all_rank, y = num_comments)) +
  geom_point() +
  geom_smooth()

year_clean %>% 
  ggplot(aes(x=year_rank, y = num_comments)) +
  geom_point() +
  geom_smooth()

month_clean %>% 
  ggplot(aes(x=month_rank, y = num_comments)) +
  geom_point() +
  geom_smooth()

# score
all_clean %>% 
  ggplot(aes(x=all_rank, y = score)) +
  geom_point() +
  geom_smooth()

year_clean %>% 
  ggplot(aes(x=year_rank, y = score)) +
  geom_point() +
  geom_smooth()

month_clean %>% 
  ggplot(aes(x=month_rank, y = score)) +
  geom_point() +
  geom_smooth()

# upvote ratio

all_clean %>% 
  ggplot(aes(x=all_rank, y = upvote_ratio)) +
  geom_point() +
  geom_smooth()

year_clean %>% 
  ggplot(aes(x=year_rank, y = upvote_ratio)) +
  geom_point() +
  geom_smooth()

month_clean %>% 
  ggplot(aes(x=month_rank, y = upvote_ratio)) +
  geom_point() +
  geom_smooth()

# explore relationship between topic and score

# Group by topic flair
by_flair_all <- all_clean %>% 
  group_by(flair) %>% 
  summarize(count_id=n_distinct(id)) %>% 
  arrange(desc(count_id))
by_flair_all

by_flair_year <- year_clean %>% 
  group_by(flair) %>% 
  summarize(count_id=n_distinct(id)) %>% 
  arrange(desc(count_id))
by_flair_year


by_flair_month <- month_clean %>% 
  group_by(flair) %>% 
  summarize(count_id=n_distinct(id)) %>% 
  arrange(desc(count_id))
by_flair_month

# What % of top posts belong to the categories health, psych, social sciences?
20+16+15 # all
20+18+18# year
29+17+13 # month



# graph number of posts by flair

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

by_domain_month <- month_clean %>% 
  group_by(domain) %>% 
  summarize(count_id=n_distinct(id))

by_domain_year <- year_clean %>% 
  group_by(domain) %>% 
  summarize(count_id=n_distinct(id))

by_domain_all <- all_clean %>% 
  group_by(domain) %>% 
  summarize(count_id=n_distinct(id))

by_domain_month %>% 
  arrange(desc(count_id))

by_domain_year %>% 
  arrange(desc(count_id))

by_domain_all %>% 
  arrange(desc(count_id))

#####

## Text analysis

# calculate word frequencies

frequency_all <- text_all_clean %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  filter(word != "NA") %>% 
  count(word) %>% 
  mutate(proportion = n / sum(n)) %>% 
  arrange(desc(proportion))
head(frequency_all, 10)

frequency_month <- text_month_clean %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  filter(word != "NA") %>% 
  count(word) %>% 
  mutate(proportion = n / sum(n)) %>% 
  arrange(desc(proportion))
head(frequency_month, 10)


frequency_year <- text_year_clean %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  filter(word != "NA") %>% 
  count(word) %>% 
  mutate(proportion = n / sum(n)) %>% 
  arrange(desc(proportion))
head(frequency_year, 10)

frequency_compare <- bind_rows(mutate(text_month_clean, timeframe = "month"),
                               mutate(text_year_clean, timeframe = "year"),
                               mutate(text_all_clean, timeframe = "all time")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  filter(word != "NA") %>% 
  count(timeframe, word) %>% 
  group_by(timeframe) %>% 
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  pivot_wider(names_from = timeframe, values_from = proportion) %>% 
  pivot_longer(`month`:`year`,
               names_to = "timeframe", values_to = "proportion") %>% 
  arrange(desc(proportion))
head(frequency_compare, 50)


# plot frequencies - 

ggplot(frequency_compare, aes(x=proportion, y=`all time`,
                              color = abs(`all time` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", high = "gray75") +
  facet_wrap(~timeframe, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "all time", x = NULL)

# test correlations 

cor.test(data = frequency_compare[frequency_compare$timeframe == "month",],
         ~ proportion + `all time`)

cor.test(data = frequency_compare[frequency_compare$timeframe == "year",],
         ~ proportion + `all time`)

# wordclouds



# sentiment analysis

get_sentiments("nrc")

all_time_sentiment <- text_all_clean %>% 
  inner_join(get_sentiments("nrc"), by = "word")

year_sentiment <- text_year_clean %>% 
  inner_join(get_sentiments("nrc"), by = "word")

month_sentiment <- text_month_clean %>% 
  inner_join(get_sentiments("nrc"), by = "word")

sentiment_all_plot <- all_time_sentiment %>% 
  group_by(sentiment) %>% 
  summarize(num_words = n()) %>% 
  arrange(desc(num_words)) %>% 
  ggplot(aes(x = num_words, y=reorder(sentiment, num_words), fill=sentiment)) +
  geom_col(show.legend=FALSE) +
  gghighlight(num_words > 100) +
  labs(
    title = "Sentiment analysis of post titles",
    subtitle = "Top 100 posts of all time",
    x = "Number of words",
    y = "Sentiment"
  ) +
  theme_minimal()
sentiment_all_plot

sentiment_year_plot <- year_sentiment %>% 
  group_by(sentiment) %>% 
  summarize(num_words = n()) %>% 
  arrange(desc(num_words)) %>% 
  ggplot(aes(x = num_words, y=reorder(sentiment, num_words), fill=sentiment)) +
  geom_col(show.legend=FALSE) +
  gghighlight(num_words > 100) +
  labs(
    title = "Sentiment analysis of post titles",
    subtitle = "Top 100 posts last year (2022)",
    x = "Number of words",
    y = "Sentiment"
  ) +
  theme_minimal()
sentiment_year_plot

sentiment_month_plot <- month_sentiment %>% 
  group_by(sentiment) %>% 
  summarize(num_words = n()) %>% 
  arrange(desc(num_words)) %>% 
  ggplot(aes(x = num_words, y=reorder(sentiment, num_words), fill=sentiment)) +
  geom_col(show.legend=FALSE) +
  gghighlight(num_words > 100) +
  labs(
    title = "Sentiment analysis of post titles",
    subtitle = "Top 100 posts last month (December 2022)",
    x = "Number of words",
    y = "Sentiment"
  ) +
  theme_minimal()
sentiment_month_plot


# wordclouds


all_words <- text_all_clean %>% count(word, sort=TRUE)
wordcloud2(all_words, size = 1.6)

# make a logo for later
logo_reddit <- wordcloud2(all_words, size = 1.6)
logo_reddit

year_words <- text_year_clean %>% count(word, sort=TRUE)
wordcloud2(year_words, size = 1.6, color = (c("green","blue")))

# save image for later
img_year <- wordcloud2(year_words, size = 1.6, color = (c("green","blue")))
img_year

month_words <- text_month_clean %>% count(word, sort=TRUE)
wordcloud2(year_words, size = 1.6, color = (c("purple","blue")))


## add more data points from popular science psych/social science source
library(readr)
frontiers_titles <- read_csv("frontiers-titles.csv")

# restructure one token per row: unnest tokens
frontiers_titles <-frontiers_titles %>% 
  unnest_tokens(word, titles)

# remove stop words
frontiers_clean <- frontiers_titles %>% 
  anti_join(stop_nums) %>% 
  anti_join(stop_science)

frontiers_clean %>% 
  count(word, sort = TRUE)

write.csv(frontiers_clean, "~/Documents/projects/reddit-science/frontiers_clean.csv")

# word clouds

frontiers_words <- frontiers_clean %>% count(word, sort=TRUE)
wordcloud2(frontiers_words, size = 1.6, color=(c("red","purple")))

img_frontiers <- wordcloud2(frontiers_words, size = 1.6, color=(c("red","purple")))
img_frontiers

# see frequency of top reddit words in journal blogs

frequency_compare %>% 
  filter (word != "NA") %>% 
  filter(category == "frontiers") %>% 
  arrange(desc(reddit)) %>% 
  print(n=20)

# correlation tests

cor.test(data = frequency_compare[frequency_compare$category == "frontiers",],
         ~ proportion + `reddit`)

# plot frequencies

ggplot(frequency_compare, aes(x = proportion, y = `reddit`, 
                              color = abs(`reddit` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", high = "gray75") +
  facet_wrap(~category, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Reddit", x = NULL)

# export to csv

write.csv(tidy_frontiers, file = "~/Documents/Projects/reddit-science-analysis/frontiers_clean.csv")




