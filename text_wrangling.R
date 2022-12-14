#import packages for project

library(tidyverse) # data cleaning
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud) # Wordclouds


# subset dataframes with title text, flair, domain

text_month <- top_month[,c("post_title")]
text_year <- top_year[,c("post_title")]
text_all <- top_all[,c("all_time_rank", "flair","post_title")]

# restructure one token per row: unnest tokens
tidy_month <-text_month %>% 
  unnest_tokens(word, post_title)
tidy_month

tidy_year <- text_year %>% 
  unnest_tokens(word, post_title)
tidy_year

tidy_all <- text_all %>% 
  unnest_tokens(word, post_title)
tidy_all

# remove stop words

data("stop_words")

tidy_month <- tidy_month %>% 
  anti_join(stop_words)

tidy_year <- tidy_year %>% 
  anti_join(stop_words)

tidy_all <- tidy_all %>% 
  anti_join(stop_words)

# find most common words

tidy_month %>% 
  count(word, sort = TRUE)

tidy_year %>% 
  count(word, sort = TRUE)

tidy_all %>% 
  count(word, sort = TRUE)

# calculate word frequencies

frequency <- bind_rows(mutate(tidy_month, timeframe = "month"),
                       mutate(tidy_year, timeframe = "year"),
                       mutate(tidy_all, timeframe = "all time")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  count(timeframe, word) %>% 
  group_by(timeframe) %>% 
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  pivot_wider(names_from = timeframe, values_from = proportion) %>% 
  pivot_longer(`month`:`year`,
               names_to = "timeframe", values_to = "proportion")
  
frequency
  
# plot frequencies

ggplot(frequency, aes(x=proportion, y=`all time`,
                      color = abs(`all time` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", high = "gray75") +
  facet_wrap(~timeframe, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "all time", x = NULL)
 
# test correlations

cor.test(data = frequency[frequency$timeframe == "month",],
         ~ proportion + `all time`)

cor.test(data = frequency[frequency$timeframe == "year",],
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

custom_stop_words <- bind_rows(tibble(word = c(1:2022, "study", "found", "percent", "researchers", "research", "suggests", "suggest", "scientist", "scientists"),
                                      lexicon = c("custom")),
                               stop_words)


# wordclouds - fix scale later

tidy_all %>% 
  anti_join(custom_stop_words) %>% 
  count(word) %>% 
  with(wordcloud(word, n, max.words = 50))

tidy_year %>% 
  anti_join(custom_stop_words) %>% 
  count(word) %>% 
  with(wordcloud(word, n, max.words = 50))

tidy_month %>% 
  anti_join(custom_stop_words) %>% 
  count(word) %>% 
  with(wordcloud(word, n, max.words = 50))


