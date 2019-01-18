extern crate reqwest;
extern crate clap;

use std::io::copy;
use std::fs::File;
use clap::{Arg, App};

fn main() {
    // setup argv
    let args = App::new("Hitagi")
        .version("4.0")
        .author("Ben <Avuxo>")
        .about("High performance *booru scraper")
        .arg(Arg::with_name("tags")
             .short("t")
             .long("tags")
             .value_name("TAGS")
             .takes_value(true)
             .required(true)
             .help("comma-separated list of *booru tags to include in the query"))
        .arg(Arg::with_name("base url")
             .short("b")
             .long("base")
             .value_name("URL")
             .takes_value(true)
             .required(false)
             .help("A url with {} in the search term (default: https://danbooru.donmai.us/posts?tags={})"))
        .get_matches();

    let tags: &str = args
        .value_of("tags")
        .unwrap();

    let base_url: &str = args
        .value_of("base url")
        .unwrap_or("https://danbooru.donmai.us/posts?tags=");

    scrape(base_url, tags);
}

fn scrape(base_url: &str, tags: &str) {
    let page_count: i32 = count_pages(base_url, tags);

    for i in 1..(page_count+1) {
        let url = format!("{}{}&page={}", base_url, tags, i);
        parse_page(url);
    }
}

fn count_pages(base_url: &str, tags: &str) -> i32 {
    return 3;
}

fn parse_page(url: String) {
    // let page1 = reqwest::get(url)
    //     .unwrap()
    //     .text()
    //     .unwrap();
   
}

fn download_img(name: &str) {
    let mut response = reqwest::get(name).unwrap();
    let mut dest = {
        let fname = response
            .url()
            .path_segments()
            .and_then(|segments| segments.last())
            .unwrap();

        println!("downloading {}", fname);
        File::create(fname).unwrap()
    };
    copy(&mut response, &mut dest);
}
