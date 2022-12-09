---
title: "Reddit Science Analysis"
author: "Laura Fontanills"
date: "2022-12-08"
output: 
  html_document: 
    keep_md: yes
---



## Introduction
Welcome to my project! I use Reddit a lot and while there's plenty of interesting, new information there's also a lot of posts that feel...samey? I recently checked the subreddit r/science and felt like I was seeing double as I scrolled past pop-sci articles from sites like psypost.com with clickbaity titles like "Study shows when comparing students who have identical subject-specific competence, teachers are more likely to give higher grades to girls." These are interesting, I guess, and clearly popular if they're making it to the top of my feed, but they feel a bit like [a parody of science journalism.](https://www.smbc-comics.com/comic/science-journalism)

I know from experience that it's really, really hard to communicate science concepts to a general audience. Heck, it's hard to communicate science concepts to other scientists if their specialty is different from yours. The gap between how scientists communicate with each other about science and how nonspecialists communicate with each other about science is massive. That's why [videos like this one](https://www.youtube.com/watch?v=hYip_Vuv8J0) are so impressive.

So much is lost in translation, understandably, and it makes sense that people-centered science stories would fare better on social media than highly-technical journal articles. Then there's the issue of open journal access, which is a whole mess. And r/science is a general forum in itself; more specialized science subreddits exist and do a great job of fostering discussion. 

Still, I wanted to see what kinds of posts made it to the top of r/science: what topics interest the average reddit user the most? Are pop-psychology articles really so overrepresented, or am I just  mad about "Attractive female students no longer earned higher grades when classes moved online during COVID-19" (a highly flawed and since-disowned study) being the top post of the WHOLE YEAR?

## Part 1: About this project
Question: What are the characteristics of the top posts on r/science?

My hunch: pop-psy is overrepresented, physical science is underrepresented, and the topics in general are significantly different from the topics of leading scientific journals.

My back-of-the-envelope calculations: I'm only looking at the top 100 posts per month, year, and all-time. Posts are ranked based on their "score" (or, number of upvotes). I counted more than 40 posts today, meaning that my sample represents the top 8% of posts this month, the top 0.6% of posts this year, and the top 0.01% of all posts since 2015 (this is certainly an overestimation as posting frequency has also increased over time as the site grows, but even so I'm confident that I'm looking at the top-of-the-top here).

My limitations: In comparing top posts to each other, I'm working with a very small sample. A better approach would be a longitudinal study of top posts by month over a 12-month period. I'm hoping that looking at three time periods (past-month, past-year, and all-time) helps me see if any topics are amplified or diminished by selection (upvoting) over time; only ___ of this month's top posts make the top-year list, and only ___ makes the top all-time list. 

My limitations, continued: I have a lot of data points in the form of title words, but analyzing word frequency and significance is tricky, because a chi-2 assumes a normal distribution while language follows a .... (also, we're just talking about science posts, so there's additional selection muddying things). I don't know if I can manage a thorough statistical analysis of this data set, but I can try.

Potential biases: You may have noticed that I have a not-so-flattering take on some of the top posts on r/science. I come from an Earth science and chemistry background, and I've been a science teacher for 7 years, so make of that what you will.

My goals: A tidy wordcloud of title words compared with titles from scientific journals in the last month. A statistical analysis of my dataset wherein, hopefully, some significant trends appear and I either pat myself on the back or eat crow. Strong documentation of my work so that it's reproducible.

## Part 2: Data scraping

We're starting off in Python, because PRAW (Reddit's API Wrapper) uses Python. Most of my code comes straight from [here](https://www.geeksforgeeks.org/scraping-reddit-using-python/). To run this code yourself, you'll need to follow the instructions [here](https://praw.readthedocs.io/en/stable/) and input your own user information.

Step 1. Import packages

```python
# import packages
import praw
import pandas
```

Step 2: create a read-only instance in PRAW with your personal credentials. 

```python
# read-only instance
reddit_read_only = praw.Reddit(
    # input project information
    client_id='1qm6oGK-TDENrxYDwMW-8g',
    client_secret='WGhXW9c0xmvPAaejNAGMH7xjZliTDQ',
    user_agent='burritoparade'
)
```


Step 3: Check that everything is working printing getting subreddit information

```python

# extract subreddit information
subreddit = reddit_read_only.subreddit("science")

# display subreddit name
print("Display Name:", subreddit.display_name)

# display subreddit title
```

```
## Display Name: science
```

```python
print("Title:", subreddit.title)

# display subreddit description
```

```
## Title: Reddit Science
```

```python
print("Description:", subreddit.description)
```

```
## Description: # [Submission Rules](https://www.reddit.com/r/science/wiki/rules#wiki_submission_rules)
## 
## 1. Directly link to published peer-reviewed research or media summary
## 2. No summaries of summaries, re-hosted press releases, or reposts
## 3. No editorialized, sensationalized, or biased titles
## 4. Research must be less than 6 months old
## 5. No blogspam, images, videos, or infographics
## 6. All submissions must have flair assigned
## 
## # [Comment Rules](https://www.reddit.com/r/science/wiki/rules#wiki_comment_rules)
## 
## 1. No off-topic comments, memes, low-effort comments or jokes
## 2. No abusive or offensive comments
## 3. Non-professional personal anecdotes will be removed
## 4. Criticism of published work should assume basic competence of the researchers and reviewers
## 5. Comments dismissing established findings and fields of science must provide evidence
## 6. No medical advice
## 7. Repeat or flagrant offenders will be banned
## 
## ---
## 
## 
## 
## ## [New to reddit? Click here!](https://www.reddit.com/wiki/reddit_101)
## 
## ## [Get flair in /r/science](https://www.reddit.com/r/science/wiki/flair)
## 
## ## [Previous Science AMA's](https://www.reddit.com/r/science/search?q=flair%3A%27AMA%27&sort=new&restrict_sr=on)
## 
## > 
## - **filter by field**
## - [Animal Sci.](https://goo.gl/STb58P)
## - [Anthropology](https://goo.gl/janxGX)
## - [Astronomy](https://goo.gl/dTqMXH)
## - [Biology](https://goo.gl/m4QZbs)
## - [Cancer](https://goo.gl/rjLfaK)
## - [Chemistry](https://goo.gl/Jjxj3P)
## - [Computer Sci.](https://goo.gl/Xpvh6i)
## - [Engineering](https://goo.gl/iFi3Gu)
## - [Environment](https://goo.gl/oedACs)
## - [Epidemiology](https://goo.gl/VmmsA9)
## - [Geology](https://goo.gl/J4xdyq)
## - [Health](https://goo.gl/kWcS6m)
## - [Mathematics](https://goo.gl/8SMPsP)
## - [Medicine](https://goo.gl/kyPRCD)
## - [Nanoscience](https://goo.gl/UmxqQd)
## - [Neuroscience](https://goo.gl/AphkXU)
## - [Paleontology](https://goo.gl/iMgZoU)
## - [Physics](https://goo.gl/1ZrRAu)
## - [Psychology](https://goo.gl/J2vKF1)
## - [Social Sci.](https://goo.gl/CftfVE)
## - [Sci Discussion](https://goo.gl/dGn6F8)
## 
## ---
## 
## [](#/RES_SR_Config/NightModeCompatible)
```

Step 4: Scrape post information from the past month.

```python
# get top posts this from time period
posts = subreddit.top("month")
```

```
## <string>:1: DeprecationWarning: Positional arguments for 'BaseListingMixin.top' will no longer be supported in PRAW 8.
## Call this function with 'time_filter' as a keyword argument.
```

```python
posts_dict = { 
    "ID": [],
    "Created UTC": [],
    "Post URL": [],
    "Title": [],
    "Link flair text": [],
    "Score": [],
    "Num comments": [],
    "Upvote ratio": []
}

for post in posts:
    posts_dict["ID"].append(post.id)
    posts_dict["Created UTC"].append(post.created_utc)
    posts_dict["Post URL"].append(post.url)
    posts_dict["Title"].append(post.title)
    posts_dict["Link flair text"].append(post.link_flair_text)
    posts_dict["Score"].append(post.score)
    posts_dict["Num comments"].append(post.num_comments)
    posts_dict["Upvote ratio"].append(post.upvote_ratio)

top_posts_month = pandas.DataFrame(posts_dict)

top_posts_month.to_csv("Top Posts Month.csv")
```

Step 5: Now repeat for year and all-time

```python
# get top posts - past year
posts = subreddit.top("year")

posts_dict = { 
    "ID": [],
    "Created UTC": [],
    "Post URL": [],
    "Title": [],
    "Link flair text": [],
    "Score": [],
    "Num comments": [],
    "Upvote ratio": []
}

for post in posts:
    posts_dict["ID"].append(post.id)
    posts_dict["Created UTC"].append(post.created_utc)
    posts_dict["Post URL"].append(post.url)
    posts_dict["Title"].append(post.title)
    posts_dict["Link flair text"].append(post.link_flair_text)
    posts_dict["Score"].append(post.score)
    posts_dict["Num comments"].append(post.num_comments)
    posts_dict["Upvote ratio"].append(post.upvote_ratio)

top_posts_year = pandas.DataFrame(posts_dict)

top_posts_year.to_csv("Top Posts Year.csv")
```

```python

# get top posts - all time
posts = subreddit.top("all")

posts_dict = { 
    "ID": [],
    "Created UTC": [],
    "Post URL": [],
    "Title": [],
    "Link flair text": [],
    "Score": [],
    "Num comments": [],
    "Upvote ratio": []
}

for post in posts:
    posts_dict["ID"].append(post.id)
    posts_dict["Created UTC"].append(post.created_utc)
    posts_dict["Post URL"].append(post.url)
    posts_dict["Title"].append(post.title)
    posts_dict["Link flair text"].append(post.link_flair_text)
    posts_dict["Score"].append(post.score)
    posts_dict["Num comments"].append(post.num_comments)
    posts_dict["Upvote ratio"].append(post.upvote_ratio)

top_posts_all = pandas.DataFrame(posts_dict)

top_posts_all.to_csv("Top Posts All.csv")
```

We did it!
