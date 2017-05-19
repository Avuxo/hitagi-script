const imgur = require('imgur');
const creds = require('./config.json');

//reads from the credentials file
const id = creds.imgur_key;
const album = creds.album_id;

//make sure there is the right amount of arguments
if(process.argv.length < 3) process.exit(1);
const path = process.argv[2];

//add a client ID and then create album
imgur.setClientId(id);
imgur.createAlbum()  
    .then(function(json) {
        //console.log(json);
        
        //upload the files to imgur
        console.log('When done uploading, images will be at: https://imgur.com/a/' + json.data.id);
        imgur.uploadFile(path + '/*', json.data.deletehash)
            .then(function (json) {
                //console.log(json.data.link);
                console.log('finished.');

            })
            .catch(function (err) {
                console.error(err.message);
            });
    })
    .catch(function (err) {
        console.error(err.message);
    });

