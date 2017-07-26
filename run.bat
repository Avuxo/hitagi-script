@echo off
cls
@echo:
echo     ,,,                 ;;                      ;, 
echo     ;,     ;;,          ;;                   ;;;;;;;; 
echo   ,;       ;,  ;,    ;;;;;;;;;                  ;;    
echo  ,;         ;,          ;;                 ;;;;;;;;;;;;;
echo  ;;         ;;          ;;  .,,,,               ;; 
echo  ;;         ;;          ;;  ,''''              ,;; 
echo   ;,       ,;           ;;                 ,;''    
echo    ;,     ,;            ;;  ;,             ;;       
echo     ;;;;;;;             ;;    ;;;;;,,      \`;;;;;,, 
@echo:

echo ~~Hitagi-Script Windows Edition~~
echo Please ensure that you have installed NodeJS 7.x
echo https://nodejs.org/en/download/current/
call npm install

set /p name="Safebooru tags (name or additional queries)? "

echo Downloading art...
call node danbooru.js %name%
pause