/*
  DEPENDENCIES
              */

const PixivAppApi = require('pixiv-app-api'); //pixiv library (modern)
const fs = require('fs'); //file system
const creds = require('./config.json'); //load the credentials
const pixivImg = require('pixiv-img'); //pixiv image downloader
const co = require('co');
const pixiv = new PixivAppApi(creds.username, creds.password);

const wait = () => new Promise(resolve => setTimeout(() => resolve(), 100)); //I straight up stole this code from the API page

//this isntstolen from the API page, but it sure as hell looks like it
co(function * (){
	//ひたぎ
    var json = yield pixiv.searchIllust(creds.pixiv_name); //initial query
    yield dl(json); 
    for(;;){ //infinte loop
        if(!pixiv.hasNext) break;
        var json = yield pixiv.next();
        yield dl(json); //download
        
    }
    console.log(done);
});

/*download function*/
function* dl(json){
    for(var i of json.illusts){
        var url = i.imageUrls.large; //get original image url
        if(url){
            yield pixivImg(url); //download image
            yield wait();
        }
    }
}

/*
  Hitagi Script
  by: Ben
  2017
*/
