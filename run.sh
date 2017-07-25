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
nodejs danbooru.js $tags
