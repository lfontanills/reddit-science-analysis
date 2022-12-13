# get summary

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
  summarize(count_id=n_distinct(id))

by_flair_year <- top_year %>% 
  group_by(flair) %>% 
  summarize(count_id=n_distinct(id))

by_flair_all <- top_all %>% 
  group_by(flair) %>% 
  summarize(count_id=n_distinct(id))

# graph number of posts by flair

ggplot(by_flair_month, aes(x=flair, y=count_id)) +
  geom_col()

ggplot(by_flair_year, aes(x=flair, y=count_id)) +
  geom_col()

ggplot(by_flair_all, aes(x=flair, y=count_id)) +
  geom_col()


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