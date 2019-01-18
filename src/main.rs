extern crate reqwest;
extern crate clap;
extern crate select;
extern crate regex;

use std::io::copy;
use std::fs::File;
use clap::{Arg, App};
use select::document::Document;
use select::predicate::Name;
use regex::Regex;

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

    // TODO: handle custom base urls (specifically for safebooru)
    let base_url: &str = args
        .value_of("base url")
        .unwrap_or("https://danbooru.donmai.us");

    scrape(base_url, tags);
}

fn scrape(base_url: &str, tags: &str) {
    let page_count: i32 = count_pages(base_url, tags);

    for i in 1..(page_count+1) {
        let url = format!("{}/posts?tags={}&page={}", base_url, tags, i);
        parse_page(base_url, url);
    }
}

fn count_pages(base_url: &str, tags: &str) -> i32 {
    // TODO
    return 3;
}

fn parse_page(base_url: &str, url: String) {
    let post_regex = Regex::new(r"/posts/\d+").unwrap();
    println!("Parsing {}", url);
    let page = reqwest::get(&url[..]).unwrap();
    assert!(page.status().is_success());

    Document::from_read(page)
        .unwrap()
        .find(Name("a"))
        .filter_map(|n| n.attr("href"))
        .for_each(|x| {
            if post_regex.is_match(x) {
                let img_url = find_image(&format!("{}{}", base_url, x)[..]);
                download_img(img_url);
            }
        });
}

fn find_image(url: String) {
    
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
