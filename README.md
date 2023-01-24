# Reddit r/science post topic analysis

## Data source
In December 2022, I scraped the top 100 posts (month, year, and all-time) from reddit.com/r/science

I also scraped post titles from the homepages of Frontiers in Science and Nature.

## Data scraping with PRAW 

PRAW (Reddit's API) can only be accessed with Python.

To get a read-only list of posts, I used scraper.py.

You'll need a client id, client secret, user agent to access PRAW. Here's how to get that:
1. Go to https://www.reddit.com/prefs/apps
2. Click on "create an app" or "create another app"
3. Create the application

### Python packages
- praw
- pandas

## Post data analysis 

I investigated which topics are most prevalent on top of r/science

## Title text analysis

I looked at the frequency of words in top post titles. I also made a wordcloud.

### R packages
- tidyverse
- lubridate 
- textdata (Sentiment analysis)
- wordcloud 
- readr

## Notes

Because I scraped using python and analyzed using R I had to create a virtual environment in my project folder in which I worked in Python. 