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

echo "~~Hitagi-Script Windows Edition~~"
echo "Please ensure that you have installed NodeJS 7.x"
echo "https://nodejs.org/dist/v7.10.0/node-v7.10.0-x64.msi"

echo "STEP ONE: configure config.json  (as is seen on the github page)"
set /p name="Name of target art? "

REM configuring for download
if not exist "%name%\" mkdir %name%

echo "Downloading art..."
node pixiv-download-win.js
move 1* %name%
move 2* %name%
move 3* %name%
move 4* %name%
move 5* %name%
move 6* %name%
move 7* %name%
move 8* %name%
move 9* %name%
REM TODO: imgur upload


pause