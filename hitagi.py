from threading import Thread
import queue, time, random, urllib.parse, sys, hashlib
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
        Thread.__init__(self) # super thread

        # configure arguments
        self.queue = queue
        self.baseUrl = url
        self.url = self.baseUrl
        self.http = http
        self.parent = parent

        # DEBUG -- urllib3 throws SSL warnings because of poorly maintained cert.
        urllib3.disable_warnings()


    # return list of all posts on the current page
    def getPosts(self):
        # get the page and configure HTML parser
        html = self.http.request('GET', self.url)
        soup = bs4.BeautifulSoup(html.data, "html5lib")

        # get all of the posts
        return soup.find_all('article')
        

    # main purpose of the Worker thread is to find posts and get the image url.
    def crawl(self):
        posts = self.getPosts()
        for post in posts:
            postLoc = post.find('a')
            # get the booru base URL
            base = urllib.parse.urlparse(self.url)[1]
            # get the url of the post
            postURL = "https://" + base + postLoc['href']

            # parse page
            postHTML = self.http.request('GET', postURL)
            soup = bs4.BeautifulSoup(postHTML.data, "html5lib")
            # get the url of the first image
            try:
                imgUrl = soup.find('img')['src']
                self.queue.put(soup.find('img')['src'])
            except:
                print("unable to download image.")
                
        self.die() # kill the thread
        
    def die(self):
        self.parent.killWorker() # open spot in thread pool

    def run(self):
        self.crawl()


"""
DownloadWorker class
This class handles the parallization of downloading.
the scraping threads put URLs in a queue and these threads download the files.
"""
class DownloadWorker(Thread):
    def __init__(self, queue, http, parent):
        Thread.__init__(self) # super thread
        
        self.queue = queue
        self.http = http
        self.parent = parent
        
    def download(self):
        # loop through and download until the queue is empty
        while not self.queue.empty():
            curUrl = self.queue.get()

            downloadUrl = "https://danbooru.donmai.us" + curUrl

            data = self.http.request('GET', downloadUrl).data

            # filename is the md5 sum of the sub url
            m = hashlib.md5()
            m.update(curUrl.encode('utf-8'))
            filename = m.hexdigest()

            # open a write stream
            f = open("./" + filename + "." + curUrl[-3:], 'wb')
            f.write(data)

            
            
            self.parent.artDownloaded += 1
        self.die()
        
    def run(self):
        self.download()

    # open spot in the thread pool
    def die(self):
        self.parent.killDownloadWorker()
        

"""
Main webscraper class
Hitagi-script operates as a *booru crawler.
Originally it was a Javascript danbooru API wrapper, but I discovered a shortcoming.
Due to the lack of control over Node's threads, I chose to port over to Python
because the scripts was _slow_ without any parallelization.

The scraper operates in three stages:
- single thread goes through every single page
- spawn a thread on each page (first thread waits until more workers are available)
  - these threads add every image found's URL into a queue for phase 3
- pre-allocated threads download the images found by phase 2 from the queue
"""
class Scraper:
    def __init__(self, baseurl, maxWorkers):
        # setup the http library
        self.http = urllib3.PoolManager()

        # setup queue for image URLs
        self.downloadQueue = queue.Queue()

        # add CLI arguments to class
        self.maxWorkers = int(maxWorkers)
        self.numWorkers = 0
        self.baseurl = baseurl

        # number of thread workers 
        self.maxNumScrapeWorkers   = self.maxWorkers // 2
        self.maxNumDownloadWorkers = self.maxWorkers // 2

        self.numScrapeWorkers   = 0
        self.numDownloadWorkers = 0

        # current *booru page
        self.page = 1
        
        # amount of art done downloading
        self.artDownloaded = 0

        # TODO: implement as cmdline argument; limit art downloaded
        self.artLimit = 0


    # is there a page after the current one?
    def getNextPage(self, url):

        # HTTP get the current page
        html = self.http.request('GET', url)
        # setup the html parser
        soup = bs4.BeautifulSoup(html.data, "html5lib")

        # find the nextButton
        # The next button is: <a rel="next" href="#">>></a>
        tags = soup.find_all('a', {'rel' : True})
        for tag in tags:
            if tag['rel'][0] == 'next':
                return True # there is a next page

        return False # there is not a next page

        
        
    # create a new scrape worker
    def spawnWorker(self, url):
        if self.numScrapeWorkers < self.maxNumScrapeWorkers:
            # create a worker thread and initialize it
            work = Worker(url, self.downloadQueue, self.http, self, self.page)
            work.start()
            # maintain list of workers
            self.numScrapeWorkers += 1
            return True
        else:
            return False

    # create a new worker for the download queue
    def spawnDownloadWorker(self):
        if self.numDownloadWorkers < self.maxNumDownloadWorkers:
            # create a new download worker
            work = DownloadWorker(self.downloadQueue, self.http, self)
            work.start()
            self.numDownloadWorkers += 1
            return True
        else:
            return False
        
    # crawl through pages and spawn a worker on every page
    def crawl(self): # crawl pages
        curPage = self.baseurl
        # is there a next page?
        while self.getNextPage(curPage):
            while self.spawnWorker(curPage) == False: # can we spawn a worker?
                time.sleep(1) # sleep for 1 second and check again
            # attempt to spawn a download worker on every page
            self.spawnDownloadWorker()
            self.page += 1
            curPage = self.baseurl + "&page=" + str(self.page)

    # thread is finished
    def killWorker(self):
        self.numScrapeWorkers -= 1

    # thread is finished
    def killDownloadWorker(self):
        self.numDownloadWorkers -= 1


"""
TODO
- advanced command line parsing
  - -w : # of WORKER threads (default: 3)
  - -d : # of DOWNLOAD threads (default: 3)
  - -t : # of TOTAL threads (default: 6); download = worker = (TOTAL / 2)
  - -t : tags
  - -o : specify output directory (default: .)
  - -s : start at page n (default: 0)
  - -v : verbose output (default: false)
  - -m : maximum amount of art (default: unlimited)
  - -b : specify specific *booru base URL
  - -g : read from stdin
"""

def main():
    if len(sys.argv) < 3:
        print("ERROR: Script requires 2 args: baseURL, maxNumWorkers")
        exit(1)
        
    # create the main crawler
    scraper = Scraper(sys.argv[1], sys.argv[2])

    scraper.crawl()

if __name__ == "__main__":
    main()
