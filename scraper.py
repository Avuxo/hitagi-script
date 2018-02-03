from threading import Thread
import queue, time, random, urllib.parse
import bs4, urllib3 # beautiful soup is the only external dependency


"""
Worker class
This class does all the parallelized crawling.
Provided a link it will run until it finds an image URL.
It will then push the URL into a queue.
At each page a worker is spawned and it auto-destroys when it is out of images
"""

class Worker(Thread):
    def __init__(self, url, queue, http, parent, page):
        Thread.__init__(self)

        self.queue = queue
        self.baseUrl = url
        self.url = self.baseUrl
        self.http = http
        self.parent = parent

        # DEBUG
        urllib3.disable_warnings()


    def getPosts(self):
        html = self.http.request('GET', self.url)
        soup = bs4.BeautifulSoup(html.data, "html5lib")

        # get all of the posts
        return soup.find_all('article')
        
        
    def crawl(self):
        posts = self.getPosts()
        for post in posts:
            postLoc = post.find('a')
            # get the booru base URL
            base = urllib.parse.urlparse(self.url)[1]
            # get the url of the post
            postURL = "https://" + base + postLoc['href']
            
            postHTML = self.http.request('GET', postURL)
            soup = bs4.BeautifulSoup(postHTML.data, "html5lib")
            self.queue.put(soup.find('img')['src'])
            
        self.die()
        
    def die(self):
        self.parent.killWorker()

    def run(self):
        self.crawl()


"""
DownloadWorker class
This class handles the parallization of downloading.
the scraping threads put URLs in a queue and these threads download the files.
"""
class DownloadWorker(Thread):
    def __init__(self, queue):
        Thread.__init__(self)
        self.queue = queue

    def download(self, url):
        self.queue.pop()
        

"""
Main webscraper class
Hitagi-script operates as a *booru crawler.
Originally it was a Javascript danbooru API wrapper, but I discovered a shortcoming.
Due to the lack of control over Node's threads, I chose to port over to Python
because the scripts was _slow_ without any parallelization.
"""
class Scraper:
    def __init__(self, baseurl, maxWorkers):
        self.http = urllib3.PoolManager()
        self.downloadQueue = queue.Queue()
        self.maxWorkers = int(maxWorkers)
        self.baseurl = baseurl
        self.numWorkers = 0
        self.page = 1


    # is there a page after the current one?
    def getNextPage(self, url):
        print(url)
        html = self.http.request('GET', url)
        soup = bs4.BeautifulSoup(html.data, "html5lib")

        # find the nextButton
        nextBtn = ""
        tags = soup.find_all('a', {'rel' : True})
        for tag in tags:
            print(tag['rel'])
            if tag['rel'][0] == 'next':
                return True # there is a next page

        return False # there is not a next page

        
        
    # create a new worker
    def spawnWorker(self, url):
        if self.numWorkers < self.maxWorkers:
            work = Worker(url, self.downloadQueue, self.http, self, self.page)
            work.start()
            self.numWorkers += 1
            return True
        else:
            return False

    def spawnDownloadWorker(self):
        if self.numWorkers < self.maxWorkers:
            work = DownloadWorker(self.queue)
            self.numWorkers += 1
            return True
        else:
            return False
        
    # crawl through pages and spawn a worker on every page
    def crawl(self): # crawl pages
        curPage = self.baseurl
        # is there a next page?
        while self.getNextPage(curPage):
            while self.spawnWorker(curPage) == False:
                time.sleep(1) # sleep for 1 second and check again

            self.page += 1
            curPage = self.baseurl + "&page=" + str(self.page)
            
    def killWorker(self):
        self.numWorkers -= 1
