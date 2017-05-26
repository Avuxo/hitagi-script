# hitagi-script
A script originally to download Hitagi Senjougahara art.

With that being said, I've tried to make it as easily customizable as possible so it can download whatever art you want

This script searches Pixiv and Danbooru, downloads it to a temporary directory, uploads it to an imgur album and then deletes it from your hard drive

## GENERAL CONFIG (both windows and linux)
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

## Setup & Configuration (Linux)
In order to use this script you must first install the dependencies using
`$ npm install`

run `$ ./setup.sh` in the project directory and give it the information it requests

## Running the script (Linux)

`$ ./run.sh` in the project directory to run the script

## Windows Guide
Install Node.JS 7.x from https://nodejs.org/en/download/current/

Edit `config.json` to contain your info (matching the one above in the github)

Run `run.bat` by either running it from the CMD or by double clicking. Enter a name for the folder it will download to when prompted for a name.
Do not cancel the script until it has finished if you want the directory to be created and the art to be moved into it.
