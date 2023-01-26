# Reddit r/science post topic analysis

## Data source
In December 2022, I scraped the top 100 posts (month, year, and all-time) from reddit.com/r/science

I also scraped post titles from the homepages of Frontiers in Science and Nature.

## Data scraping with PRAW 

PRAW (Reddit's API) can only be accessed with Python.

To get a read-only list of posts, I used scraper.py. To run this code yourself, you'll need to follow the instructions [this guide](https://praw.readthedocs.io/en/stable/) and use your own credentials.

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
- tidytext
- wordcloud 
- readr
- gghighlight
- skimr

## Notes

Because I scraped using python and analyzed using R I had to create a virtual environment in my project folder in which I worked in Python. 