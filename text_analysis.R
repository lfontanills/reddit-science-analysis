library(tidyverse) # data processing and analysis
library(lubridate) # wrangle dates
library(skimr) # skim data frames
library(urltools) # wrangle urls
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud2) # Wordclouds
library(gghighlight) # Adding to graphs

# calculate word frequencies

frequency_month <- tidy_month %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  filter(word != "NA") %>% 
  count(word) %>% 
  mutate(proportion = n / sum(n)) %>% 
  arrange(desc(proportion))
head(frequency_month, 10)


frequency_year <- tidy_year %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  filter(word != "NA") %>% 
  count(word) %>% 
  mutate(proportion = n / sum(n)) %>% 
  arrange(desc(proportion))
head(frequency_year, 10)

frequency_all <- tidy_all %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  filter(word != "NA") %>% 
  count(word) %>% 
  mutate(proportion = n / sum(n)) %>% 
  arrange(desc(proportion))
head(frequency_all, 10)
  
frequency_compare <- bind_rows(mutate(tidy_month, timeframe = "month"),
                       mutate(tidy_year, timeframe = "year"),
                       mutate(tidy_all, timeframe = "all time")) %>% 
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

# sentiment analysis

get_sentiments("afinn")
get_sentiments("bing")
get_sentiments("nrc")

all_time_sentiment <- tidy_all %>% 
  inner_join(get_sentiments("nrc")) %>% 
  count(flair, index = all_time_rank %/% 80, sentiment) %>% 
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)
all_time_sentiment

afinn <- tidy_all %>% 
  inner_join(get_sentiments("afinn")) %>% 
  group_by(index = all_time_rank %/% 80) %>% 
  mutate(method = "AFINN")
  
bing_and_nrc <- bind_rows(
  tidy_all %>% 
    inner_join(get_sentiments("bing")) %>% 
   mutate(method = "Bing et al."),
  tidy_all %>% 
    inner_join(get_sentiments("nrc") %>% 
                 filter(sentiment %in% c("positive", "negative"))
               ) %>% 
    mutate(method = "NRC")) %>% 
  count(method, index = all_time_rank %/% 80, sentiment) %>% 
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)
  

  # plot sentiment analysis

bind_rows(afinn,
          bing_and_nrc) %>% 
  ggplot(aes(index, sentiment, fill = method)) + 
  geom_col(show.legend = FALSE) + 
  facet_wrap(~method)


get_sentiments("nrc") %>% 
  filter(sentiment %in% c("positive", "negaative")) %>% 
  count(sentiment)

get_sentiments("bing") %>% 
  count(sentiment)

get_sentiments("afinn") %>% 
  count(value)

# most common +, - words

bing_word_counts <- tidy_all %>% 
  inner_join(get_sentiments("bing")) %>% 
  count(word, sentiment, sort = TRUE) %>% 
  ungroup()

bing_word_counts %>% 
  group_by(sentiment) %>% 
  slice_max(n, n=10) %>% 
  ungroup() %>% 
  mutate(word = reorder(word,n)) %>% 
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) + 
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)



# wordclouds

all_words <- tidy_all %>% count(word, sort=TRUE)
wordcloud2(all_words, size = 1.6)

# make a logo for later
logo_reddit <- wordcloud2(all_words, size = 1.6)
logo_reddit

year_words <- tidy_year %>% count(word, sort=TRUE)
wordcloud2(year_words, size = 1.6, color = (c("green","blue")))

# save image for later
img_year <- wordcloud2(year_words, size = 1.6, color = (c("green","blue")))
img_year

month_words <- tidy_month %>% count(word, sort=TRUE)
wordcloud2(month_words, size = 1.6, color=(c("purple","blue")))


### Compare to journal news sites - homepages

nature_titles <- read_csv("nature-titles.csv")

# restructure one token per row: unnest tokens
tidy_nature <-nature_texts %>% 
  unnest_tokens(word, titles)

# remove stop words
data("stop_words")

# customize stop words

tidy_nature <- tidy_nature %>% 
  anti_join(custom_stop_words)


nature_words <- tidy_nature %>% 
  count(word, sort = TRUE) 

## add more data points from popular science psych/social science source
library(readr)
frontiers_titles <- read_csv("frontiers-titles.csv")

# restructure one token per row: unnest tokens
tidy_frontiers <-frontiers_titles %>% 
  unnest_tokens(word, titles)

# remove stop words
tidy_frontiers <- tidy_frontiers %>% 
  anti_join(custom_stop_words)


frontiers_words <- tidy_frontiers %>% 
  count(word, sort = TRUE)

# word clouds

nature_words <- tidy_nature %>% count(word, sort=TRUE)
wordcloud2(nature_words, size = 1.6, color=(c("red","pink")))

frontiers_words <- tidy_frontiers %>% count(word, sort=TRUE)
wordcloud2(frontiers_words, size = 1.6, color=(c("red","purple")))

img_frontiers <- wordcloud2(frontiers_words, size = 1.6, color=(c("red","purple")))
img_frontiers

# calculate frequency

frequency_compare <- bind_rows(mutate(tidy_all, category = "reddit"),
                               mutate(tidy_nature, category = "nature"),
                               mutate(tidy_frontiers, category = "frontiers")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  count(category, word) %>% 
  group_by(category) %>% 
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  pivot_wider(names_from = category, values_from = proportion) %>% 
  pivot_longer(`nature`:`frontiers`,
               names_to = "category", values_to = "proportion")

# see frequency of top reddit words in journal blogs

frequency_compare %>% 
  filter (word != "NA") %>% 
  filter(category == "nature") %>% 
  arrange(desc(reddit)) %>% 
  print(n=20)

frequency_compare %>% 
  filter (word != "NA") %>% 
  filter(category == "frontiers") %>% 
  arrange(desc(reddit)) %>% 
  print(n=20)

# correlation tests
cor.test(data = frequency_compare[frequency_compare$category == "nature",],
         ~ proportion + `reddit`)

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

write.csv(tidy_nature, file = "~/Documents/Projects/reddit-science-analysis-2/tidy_nature.csv")
write.csv(tidy_frontiers, file = "~/Documents/Projects/reddit-science-analysis-2/tidy_frontiers.csv")


