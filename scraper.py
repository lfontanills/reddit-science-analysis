# from https://www.geeksforgeeks.org/scraping-reddit-using-python/

# import packages
import praw
import pandas

# read-only instance
reddit_read_only = praw.Reddit(
    client_id='1qm6oGK-TDENrxYDwMW-8g',
    client_secret='WGhXW9c0xmvPAaejNAGMH7xjZliTDQ',
    user_agent='burritoparade'
)

# extract subreddit information

subreddit = reddit_read_only.subreddit("science")

# display subreddit name

print("Display Name:", subreddit.display_name)

# display subreddit title
print("Title:", subreddit.title)

# display subreddit description
print("Description:", subreddit.description)

# get top posts this from time period
posts = subreddit.top("week")

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

top_posts_week = pandas.DataFrame(posts_dict)
top_posts_week

top_posts_week.to_csv("Top-Posts-Week.csv")