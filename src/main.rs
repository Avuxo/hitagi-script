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

// entry-point for general scraper
fn scrape(base_url: &str, tags: &str) {
    let page_count: i32 = 3; //count_pages(base_url, tags);
    for i in 1..(page_count+1) {
        let url = format!("{}/posts?tags={}&page={}", base_url, tags, i);
        parse_page(base_url, url);
    }
}

fn count_pages(base_url: &str, tags: &str) -> i32 {
    let mut page_count: i32 = 0;
    let mut url = format!("{}/posts?tags={}&page=", base_url, tags);
    loop {
        page_count += 1;
        url = format!("{}{}", url, page_count);
        if !page_count_valid(&url[..]) {
            break;
        }
    }

    page_count
}

// does current page contain art?
fn page_count_valid(url: &str) -> bool{
    false
}

fn parse_page(base_url: &str, url: String) {
    let post_regex = Regex::new(r"/posts/\d+").unwrap();
    println!("Parsing {}", url);
    let page = reqwest::get(&url[..]).unwrap();
    // I'm skeptical if this does anything because danbooru isn't good about status codes.
    assert!(page.status().is_success());

    Document::from_read(page)
        .unwrap()
        .find(Name("a"))
        .filter_map(|n| n.attr("href"))
        .for_each(|x| {
            if post_regex.is_match(x) {
                let img_url = format!("{}{}", base_url, x);
                let img_page = reqwest::get(&img_url[..]).unwrap();
                assert!(img_page.status().is_success());
                Document::from_read(img_page)
                    .unwrap()
                    .find(Name("img"))
                    .filter_map(|n| n.attr("src"))
                    .for_each(|u| { // iterator should return on first element.
                        download_img(u)
                    });

            }
        });
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
