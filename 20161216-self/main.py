#!/usr/bin/env python
# -*- coding: utf-8 -*-

import feedparser
url = 'http://news.google.com.br/news?pz=1&cf=all&ned=tw&hl=zh&output=rss' 
# just some GNews feed - I'll use a specific search later

feed = feedparser.parse(url)
for post in feed.entries:
   #print(post.title)
   print(post.summary)
   #print(post.keys())
