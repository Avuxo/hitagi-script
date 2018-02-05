# Hitagi-script

Hitagi-Script is a parallelized *booru scraper written in Python.

## Setup
There is only one external dependency in the script (that is not included in the standard Python 3 library): Beautiful Soup 4 (used for parsing HTML easily). In the future I plan to replace this dependency with the html.HTMLParser built in module.

**make sure you have python 3 and not python 2**


## Usage

`$ python3 hitagi.py <arguments>`

```
arguments
=========
 -h : Print the help screen
 -w : # of WORKER threads (default: 3)
 -d : # of DOWNLOAD threads (default: 3)
 -t : tags
 -s : start at page n (default: 0)
 -v : verbose output (default: false)
 -m : maximum amount of art (default: unlimited)
 -b : specify specific *booru base URL (default: danbooru.donmai.us)
```

Ex:

To download 300 pictures of Hitagi Senjougahara (using the default 6 threads), you'd run:

`$ python3 hitagi.py -t "senjougahara_hitagi" -m 300 -b "https://safebooru.org"`

## About
Hitagi-script was originally a node.js script that I created because I wanted to download all of the Hitagi Senjougahara (a character from Bakemonogatari that I'm rather fond of) art on Pixiv and a *booru site (specifically safebooru - I'm not much of a fan of lewd stuff).

The script was simply a wrapper around pixiv and danbooru node modules. Moreover, after a while, the Pixiv module stopped working. I'm not entirely sure why it did, but it did. After that, I rewrote the entire system to be a lot more simple and user friendly. I was satisfied with this version and I was able to help a few people out with downloading bulk art. At one point my script was used by an online acquaintence of mine who was writing a paper and needed a lot of sample data shoutouts to @cow-co.

However, this Node version of the script still had a major issue: performance. Because Node.js is mostly single-threaded, there was little room for improvement in terms of parallelization.

I decided that a full rewrite was in order. I decided to rewrite it in Python because I can rapidly develop an efficient cross-platform tool.

Hitagi-script operates using 3 different series of threads. The first is a single-threaded page crawler. It simply goes page by page clicking hte next button. The second series of threads goes through each page, goes post by post, and gets the URLs for images. These URLs are pushed into a queue where they are popped off by the third series of threads: The download threads. These threads individually pop off of the queue and download files. This architecture allows for far more efficient bulk downloading of art.

Will I ever bring back `run.sh` and `run.bat`? Probably not. I think their purpose has pretty much run out. It's only slightly harder to run a python script with arguments than it is to run a batch script and then hand it arguments one by one.