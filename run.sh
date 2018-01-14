#!/bin/bash

#Hitagi
echo "    ,,,                 ;;                      ;,   ; ;"
echo "    ;,     ;;,          ;;                   ;;;;;;;;  ; ;"
echo "  ,;       ;,  ;,    ;;;;;;;;;                  ;;  "     
echo " ,;         ;,          ;;                 ;;;;;;;;;;;;; "
echo " ;;         ;;          ;;  .,,,,               ;; "
echo " ;;         ;;          ;;  ,''''              ,;; "
echo "  ;,       ,;           ;;                 ,;''    "
echo "   ;,     ,;            ;;  ;,             ;;       "
echo "    ;;;;;;;             ;;    ;;;;;,,      \`;;;;;,, "

echo "Safebooru tags (name or additional queries)? "
read tags

printf "Where would you like to download from?\n[D]anbooru\n[S]afebooru\n"
read booru

if [ "$booru" != "S" ] && [ "$booru" != "s" ] && [ "$booru" != "d" ] && [ "$booru" != "D" ]; then
    echo "Not a valid choice"
    exit
fi



echo "Please ensure that you have downloaded Node.js 7.x"
npm install

echo "Downloading art"

if hash nodejs 2>/dev/null; then
    nodejs danbooru.js $booru $tags
else
    node danbooru.js $booru $tags
fi

