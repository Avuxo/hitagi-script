const Danbooru = require('danbooru');
const co = require('co');
const config = require('./config.json');
const fs = require('fs');

var booru = new Danbooru.Safebooru();

if(!fs.existsSync(config.danbooru_name)){ // make sure directory exists
    fs.mkdirSync(config.danbooru_name);
}

const wait = () => new Promise(resolve => setTimeout(() => resolve(), 100));

function *getNextPage(index){
    var query = { // the query for danbooru
	tags: config.danbooru_name,
	limit: 100,
	page: index+1
    }

    yield booru.posts(query).then(async posts => { // search posts and download them
	for(var i=0; i<(await posts.length); i++){
	    let file = posts[i].file;
	    if(file.name == undefined){
		console.log("Skipping file.");
		continue;
	    }else{
		console.log("Starting file: " + file.name);
		let data = await file.download();
		fs.writeFile(config.danbooru_name + "/"+ file.name, data, (err) => {
		    if(err) throw err;
		    console.log("Finished file: " + file.name);
		});
	    }
	}
	
    });
    yield wait();
}

co(function *(){
    for(var i=0; i<20; i++){
	yield getNextPage(i);
	//yield wait();
	i++;
    }
})
