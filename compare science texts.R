library(tidyverse) # data cleaning
library(tidytext) # NLP toolkit
library(textdata) # Sentiment analysis
library(wordcloud) # Wordclouds
library(readr)

nature_titles <- read_csv("nature-titles.csv")

# restructure one token per row: unnest tokens
tidy_nature <-nature_texts %>% 
  unnest_tokens(word, titles)

# remove stop words
data("stop_words")

# customize stop words

tidy_nature <- tidy_nature %>% 
  anti_join(custom_stop_words)
tidy_nature

tidy_nature %>% 
  count(word, sort = TRUE) %>% 
  head(20)

## add more data points from popular science psych/social science source
library(readr)
frontiers_titles <- read_csv("frontiers-titles.csv")

# restructure one token per row: unnest tokens
tidy_frontiers <-frontiers_titles %>% 
  unnest_tokens(word, titles)

# remove stop words
tidy_frontiers <- tidy_frontiers %>% 
  anti_join(custom_stop_words)


tidy_frontiers %>% 
  count(word, sort = TRUE) %>% 
  head(20)

# word clouds

tidy_nature %>% 
  count(word) %>% 
  with(wordcloud(word, n, colors=colorRampPalette(brewer.pal(9,"Greens"))(30), max.words = 30))

tidy_frontiers %>% 
  count(word) %>% 
  with(wordcloud(word, n, colors=colorRampPalette(brewer.pal(9,"Greens"))(30), max.words = 30))


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
