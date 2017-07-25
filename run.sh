#!/bin/bash

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

echo "Safebooru tags (name or additional queries)? "
read tags

echo "Please ensure that you have downloaded Node.js 7.x"
npm install

echo "Downloading art"

if hash nodejs 2>/dev/null; then
    nodejs danbooru.js $tags
else
    node danbooru.js $tags
fi

