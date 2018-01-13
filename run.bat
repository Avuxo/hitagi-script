@echo off
cls
@echo:
echo     ,,,                 ;;                      ;,   ; ;
echo     ;,     ;;,          ;;                   ;;;;;;;;  ; ;
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

echo Where would you like to download art from?
echo [D]anbooru
echo [S]afebooru
set /p booru="? "

echo Downloading art...
call node danbooru.js %name% %booru%
pause
