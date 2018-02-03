import sys
from scraper import Scraper

def main():
    if len(sys.argv) < 3:
        print("ERROR: Script requires 2 args: baseURL, maxNumWorkers")
        exit(1)
        
    # create the main crawler
    scraper = Scraper(sys.argv[1], sys.argv[2])

    scraper.crawl()

if __name__ == "__main__":
    main()
