# get summary

# skim numerical variables
skim(top_month)

# confirm normal or non-normal distribution (p > 0.05 is normal)
shapiro.test(top_month$score)
shapiro.test(top_month$num_comments)
shapiro.test(top_month$upvote_ratio)

# explore relationship between topic and score

# Group by topic flair
by_flair <- top_month %>% 
  group_by(flair) %>% 
  summarize(score, upvote_ratio)


# confirm normal or non-normal distribution (p > 0.05 is normal)
shapiro.test(by_flair$score) # 0.80, normal

shapiro.test(by_flair$upvote_ratio) # non-normal

# graph score by flair

ggplot(by_flair, aes(x=flair, y=median(score))) +
  geom_col()




# Group by by domain name

by_domain <- top_month %>% 
  group_by(domain) %>% 
  summarize(median_score = median(score), num_posts = n_distinct(id), median_upvote = median(upvote_ratio)) %>% 
  arrange(-num_posts)

# Calculate standard deviation 
sd(top_month$score)
sd(top_month$upvote_ratio)

# visualizations
ggplot(top_month, aes(x=score, y=upvote_ratio)) + geom_point()
ggplot(by_domain, aes(x=num_posts, y=mean_upvote)) + geom_point()
ggplot(by_domain, aes(x=num_posts, y=mean_score)) + geom_point()
ggplot(top_month, aes(x=hour(created_utc), y=month_rank)) + geom_point()


# for year
# get summary

summary(top_year)
sd(top_year$score)
sd(top_year$upvote_ratio)
sd(top_year$num_comments)

# What were the posts with the low upvote ratio
#select(top_month$post_title, upvote_ratio < .8)

# Count the number of posts by domain name
top_year %>% 
  group_by(domain) %>% 
  summarize(num_posts = n_distinct(id)) %>% 
  arrange(-num_posts)

by_domain_year <- top_year %>% 
  group_by(domain) %>% 
  summarize(mean_score = mean(score), num_posts = n_distinct(id), mean_upvote = mean(upvote_ratio)) %>% 
  arrange(-num_posts)

# visualizations
ggplot(top_year, aes(x=score, y=upvote_ratio)) + geom_point()
ggplot(by_domain_year, aes(x=num_posts, y=mean_upvote)) + geom_point()
ggplot(by_domain_year, aes(x=num_posts, y=mean_score)) + geom_point()
ggplot(top_year, aes(x=hour(created_utc), y=year_rank)) + geom_point()

## all time

summary(top_year)
sd(top_year$score)
sd(top_year$upvote_ratio)
sd(top_year$num_comments)

# What were the posts with the low upvote ratio
#select(top_month$post_title, upvote_ratio < .8)

# Count the number of posts by domain name
top_all %>% 
  group_by(domain) %>% 
  summarize(num_posts = n_distinct(id)) %>% 
  arrange(-num_posts)

#huh. psypost doesn't crack the top 10

by_domain_all <- top_all %>% 
  group_by(domain) %>% 
  summarize(mean_score = mean(score), num_posts = n_distinct(id), mean_upvote = mean(upvote_ratio)) %>% 
  arrange(-num_posts)

# visualizations
ggplot(top_all, aes(x=score, y=upvote_ratio)) + geom_point()
ggplot(by_domain_all, aes(x=num_posts, y=mean_upvote)) + geom_point()
ggplot(by_domain_all, aes(x=num_posts, y=mean_score)) + geom_point()
ggplot(top_all, aes(x=hour(created_utc), y=all_time_rank)) + geom_point()



#takeaways

# big changes to domain names over time periods
# some time variability
# combine by_domain and make some charts
# look for the outliers