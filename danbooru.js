const Danbooru = require('danbooru');
const co = require('co');
const fs = require('fs');

var booru = new Danbooru.Safebooru();

var name = process.argv[2];


var dirName = sanitize(name);
if(!fs.existsSync(dirName)){ // make sure directory exists
	fs.mkdirSync(dirName);
}

const wait = () => new Promise(resolve => setTimeout(() => resolve(), 100));

function *getNextPage(index){
	var query = { // the query for danbooru
		tags: name,
		limit: 100,
		page: index+1,
		random:true
	}

	yield booru.posts(query).then(async posts => { // search posts and download them
		var failed = 0; // if this exceeds 5, cancel
		for(var i=0; i<(await posts.length); i++){
			if(failed > 5){
				break;
			}
			let file = posts[i].file;
			if(file.name == undefined){
				failed++;
				continue;
			}else{
				failed = 0; // reset the counter
				let data = await file.download();
				fs.writeFile(dirName + "/"+ file.name, data, (err) => {
					if(err) console.log(err);
				});
			}
		}
			
	});
	yield wait();
}

co(function *(){
	var i = 0;
	for(var i=0;i<200;i++){ // 200 is an arbitrary number for "download a bunch, yo -- if you have time concerns, lower it"
		yield getNextPage(i);
	}
});

function sanitize(name){ // sanitize name for directory
	name = name.split('_')[0];
	return name;
}

/*
	Hitagi-Script
	by Ben
	2017
*/