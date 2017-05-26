@echo off
cls
chcp 65001
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

echo "STEP ONE: configure config.json  (as is seen on the github page)"
set /p name="Name of target art? "

echo Downloading art...
node pixiv-download-win.js
if not exist "%name%\" mkdir %name%
for /l %%x in (1, 1, 9) do if exist %%x* move %%x* %name% > nul

REM TODO: imgur upload


pause
