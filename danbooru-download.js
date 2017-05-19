const Danbooru = require('danbooru');
const fs = require('fs');
const creds = require('./config.json');

shortBooru = Danbooru(creds.danbooru_login, creds.danbooru_token);
//senjougahara_hitagi

if(process.argv.length < 3) process.exit(1);
const path = process.argv[2];

/*I am actually disgusted by this block of code, but it works.*/
/*For some reason all loops need to be initialized at 1, idfk why*/
Danbooru.search('senjougahara_hitagi rating:s limit:150', function(err, page1){
    if(err) throw err;
    //console.log(page1);
    for(let i=1; i<page1.length; i++){
        Danbooru.request(page1[i].large_file_url)
            .pipe(fs.createWriteStream(path + page1[i].md5  + i  + "." +  page1[i].file_ext));
    }
}).next(function(err, page2){
    if(err) throw err;
    //console.log(page2);
    for(let j=1; j<page2.length; j++){
        Danbooru.request(page2[j].large_file_url)
            .pipe(fs.createWriteStream(path + page2[j].md5 + j + "." + page2[j].file_ext));
    }
    page2.next(function(err, page3){
        if(err) throw err;
        //console.log(page3);
        for(let k=1; k<page3.length; k++){
            Danbooru.request(page3[k].large_file_url)
                .pipe(fs.createWriteStream(path + page3[k].md5  + k + "." + page3[k].file_ext));
        }
        page3.next(function(err, page4){
            if(err) throw err;
            
            for(let o=1; 0<page4.length-2; o++){
                try{
                    Danbooru.request(page4[o].large_file_url)
                        .pipe(fs.createWriteStream(path + page4[o].md5 + o + "." + page4[o].file_ext));
                }catch(err){
                    //console.log(err); //I don't wanna see the stupid error anymore, it aint my damn problem :^ )
                    break;
                }
            }
            page4.next(function(err, page5){
                if(err) throw err;

                for(let i=0; i<page5.length; i++){
                    try{
                        Danbooru.request(page5[i].large_file_url)
                            .pipe(fs.createWriteStream(path + page5[i].md5 + i + "." + page5[i].file_ext));
                    }catch(err){
                        break;
                    }
                }
                page5.next(function(err, page6){
                    if(err) throw err;

                    for(let i=0; i<page6.length; i++){
                        Danbooru.request(page6[i].large_file_url)
                            .pipe(fs.createWriteStream(path + page6[i].md5 + i + "." + page6[i].file_ext));
                    }
                    page6.next(function(err, page7){
                        if(err) throw err;
                        
                        for(let i=0; i<page7.length; i++){
                            Danbooru.request(page7[i].large_file_url)
                                .pipe(fs.createWriteStream(path + page7[i].md5 + i + "." + page7[i].file_ext));
                        }
                    })
                })
            })
        })
    });
});

