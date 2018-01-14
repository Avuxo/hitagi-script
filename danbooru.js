const Danbooru = require('danbooru');
const co = require('co');
const fs = require('fs');

var name = process.argv.slice(3).join(' '); // get the name as the third argument
var booruType = process.argv[2]; // get safe vs danbooru

if(booruType == "S" || booruType == "s") {
    var booru = new Danbooru.Safebooru();
} else if(booruType == "D" || booruType == "d") {
    var booru = new Danbooru();
    if(name.split(" ").length > 2){
        console.log("ERROR: Danbooru only allows for a maximum of 2 tags at a time");
        process.exit(1);
    }
} else {
    process.exit(1);
}

var dirName = sanitize(name);
if(!fs.existsSync(dirName)){ // make sure directory exists
    fs.mkdirSync(dirName); // create directory if it doesnt exist
}

const wait = () => new Promise(resolve => setTimeout(() => resolve(), 100)); // promise to slow stuff down

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
	    if(failed > 5){ // 5 is an arbitrary number to find when you're at the end of the list
		break;
	    }
	    let file = posts[i].file;
	    if(file.name == undefined){ // make sure the file is valid
		failed++;
		continue;
	    }else{
		failed = 0; // reset the counter
		let data = await file.download(); // download file into memory
		fs.writeFile(dirName + "/"+ file.md5 + "." + file.ext, data, (err) => { // write the file into storage
		    if(err) console.log(err);
		});
	    }
	}
	
    });
    yield wait();
}

co(function *(){ // entry point
    var i = 0; // iterator for what page will be chosen
    for(var i=0;i<200;i++){ // 200 is an arbitrary number for "download a bunch, yo -- if you have time concerns, lower it"
	yield getNextPage(i);
    }
});

function sanitize(name){ // sanitize name for directory use (remove / and () )
    name = name.split('_')[0];
    return name;
}

/*
  Hitagi-Script
  by Ben
  2017
*/
