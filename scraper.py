# adapted from https://www.geeksforgeeks.org/scraping-reddit-using-python/

# import packages
import praw
import pandas

# read-only instance
reddit_read_only = praw.Reddit(
    client_id="", #your info here
    client_secret="", #your info here
    user_agent="", #your info here
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
posts = subreddit.top("all")

posts_dict = { 
    "id": [],
    "created_unix_utc": [],
    "post_url": [],
    "post_title": [],
    "flair": [],
    "score": [],
    "num_comments": [],
    "upvote_ratio": []
}

for post in posts:
    posts_dict["id"].append(post.id)
    posts_dict["created_unix_utc"].append(post.created_utc)
    posts_dict["post_url"].append(post.url)
    posts_dict["post_title"].append(post.title)
    posts_dict["flair"].append(post.link_flair_text)
    posts_dict["score"].append(post.score)
    posts_dict["num_comments"].append(post.num_comments)
    posts_dict["upvote_ratio"].append(post.upvote_ratio)

top_posts_all= pandas.DataFrame(posts_dict)
top_posts_all

top_posts_all.to_csv("Top-Posts-All.csv")
