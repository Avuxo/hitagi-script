# hitagi-script
A script originally to download Hitagi Senjougahara art.

With that being said, I've tried to make it as easily customizable as possible so it can download whatever art you want

This script searches Pixiv and Danbooru, downloads it to a temporary directory, uploads it to an imgur album and then deletes it from your hard drive

## Setup

In order to use this script you must first install the dependencies using
`$ npm install`

In order to contact the pixiv api, it's best to login. To do this, put your login credentials in the `config.json` file

In order to use the imgur api, you need to add an OAUTH2 application key, also place this in the `config.json` file

Example `config.json` file
```
{
        "username":"user@email.com",
        "password":"super_secure_password",
        "imgur_key":"FEIJvi3lijA36",
        "album_id":"FFert",
        "danbooru_token":"FFIJEijli39p/ijllij1lij2",
        "danbooru_login":"username",
	"name":"hitagi",
	"pixiv_name":"ひたぎ",
	"danbooru_name":"senjougahara_hitagi"
}
```

## Configuration

run `$ ./setup.sh` in the project directory and give it the information it requests

## Running the script

`$ ./run.sh` in the project directory to run the script
