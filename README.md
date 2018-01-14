# Hitagi-script
A script originally designed to download art of the Bakemonogatari character Hitagi Senjougahara.

With that being said, I have since designed it so that it can be used on virtually any character (or tag), assuming they have art.

This script searches either Danbooru or Safebooru and downloads all of the art it finds

Make sure that you're using the tags used by danbooru's query system when searching (ex: Hitagi art is found via `senjougahara_hitagi`)

For multiple queries, ensure that the tags are separated via spaces (ex: for art with only hitagi and no other characters, use `senjoughara_hitagi solo`)

Danbooru's API allows for a maximum of 2 tags in one query, Safebooru doesn't have this restriction.

## Running the script (Linux)
Install Node.js 7.x through your package manager via https://nodejs.org/en/download/package-manager/

`$ ./run.sh` in the project directory and provide the safebooru tag(s) when prompted

## Running the script (Windows)
Ensure that you have installed Node.js 7.x from https://nodejs.org/en/download/current/

run `run.bat` by either running it from a command prompt or double clicking it.
Provide the safebooru tag(s) when prompted

## Known Bugs
Sometimes the Dan/safebooru api will return an invalid image. I'm not really sure why this happens and it will cause a crash. However, if the script crashes it can be restarted, any repeat images found will simply overwrite their previous incarnation. Not really a huge deal.