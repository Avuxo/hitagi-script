const Danbooru = require('danbooru');
const config = require('./config.json')
const fs = require('fs');

var booru = new Danbooru.Safebooru();

if(!fs.existsSync(config.danbooru_name)){ // make sure directory exists
	fs.mkdirSync(config.danbooru_name);
}

var query = { // the query for danbooru
	tags: config.danbooru_name,
	limit: 200
}

booru.posts(query).then(async posts => { // search posts and download them
	for(var i=0; i<(await posts.length); i++){
		let file = posts[i].file;
		let data = await file.download();
		fs.writeFile(config.danbooru_name + "/"+ file.name, data, (err) => {
			if(err) throw err;
		});
	}
	
});
