library(tidyverse) # data processing and analysis
library(lubridate) # wrangle dates
library(skimr) # skim data frames
library(urltools) # wrangle urls
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud2) # Wordclouds
library(gghighlight) # Adding to graphs

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


