#!/bin/bash

#the location that the files will be saved to
LOCATION=$HOME
#the name of the folder that will be created temporarily
FOLDER='hitagi'

#Hitagi
echo "    ,,,                 ;;                      ;, "
echo "    ;,     ;;,          ;;                   ;;;;;;;; "
echo "  ,;       ;,  ;,    ;;;;;;;;;                  ;;  "     
echo " ,;         ;,          ;;                 ;;;;;;;;;;;;; "
echo " ;;         ;;          ;;  .,,,,               ;; "
echo " ;;         ;;          ;;  ,''''              ,;; "
echo "  ;,       ,;           ;;                 ,;''    "
echo "   ;,     ,;            ;;  ;,             ;;       "
echo "    ;;;;;;;             ;;    ;;;;;,,      \`;;;;;,, "

#pixiv
echo downloading from pixiv...
nodejs pixiv-download.js
sleep 1


#loop through and move files
mkdir $LOCATION/$FOLDER/

#danbooru
echo downloading from danbooru...
nodejs danbooru-download.js $LOCATION/$FOLDER
echo done downlodaing
echo cleaning danbooru
bash clean_danbooru.sh
sleep 1

echo moving files
for i in {1..9}
do
    mv $i* $LOCATION/$FOLDER > /dev/null
done
echo done
sleep 1

echo removing unnecessary files
rm $LOCATION/$FOLDER/*.undefined
rm $LOCATION/$FOLDER/*.webm

#upload to imgur
echo uploading to imgur
#nodejs imgur-upload.js $LOCATION/$FOLDER
#make sure the upload worked all good like
if [ $? -eq 1 ]; then
    exit 1
fi
echo done
sleep 1

#delete the files from temp directory
#if you don't want the files to be deleted just go ahead and delete this section from here down to the final echo statement
#rm -r $LOCATION/$FOLDER

sleep 1

echo DONE
