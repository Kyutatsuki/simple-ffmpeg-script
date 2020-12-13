TITLE ffmpeg: AudioAndVideoConverter by Kyutatsuki
@echo off

:start
cls
echo(
echo  [107m                                         [0m
echo  [107m[32m  __ffmpeg: Audio And Video Converter__  [0m
echo  [107m                                         [0m
echo  [7m                                         [0m

SetLocal
set "audio="
set "image="
set "audiofolder=%~dp0"
set "imagefolder=%~dp0"

echo(
if exist "ffmpeg\bin\ffmpeg.exe" (
echo [96m[SUCCESS] [0mffmpeg is installed.[0m
) else (
echo [91m[ERROR] [0mffmpeg is either not installed or cannot be found:
echo [93m%cd%\ffmpeg\bin\ffmpeg.exe[0m
pause
exit
)

echo(
echo [92m[1] [0mConvert Video to Audio
echo [92m[2] [0mConvert Audio to Video
set /P c=Type a command. 
if /I "%c%" EQU "1" goto :mp3
if /I "%c%" EQU "2" goto :mp4
goto :start

:mp3

echo(
echo(

echo(  Select MP4
call:fileSelectionThird "%audio%", "%audiofolder%", "Choose a video", audio, audiofolder
echo(      Selected: %audio%

echo(
echo(

set /P name=Set file name: 
if not exist "output" mkdir output
"ffmpeg\bin\ffmpeg.exe" -i "%audiofolder%\%audio%" -vn -ar 44100 -ac 2 -b:a 320k "output\%name%.mp3"

goto :choice

:mp4

echo(
echo(

echo(  Select MP3
call:fileSelection "%audio%", "%audiofolder%", "Choose an audio", audio, audiofolder
echo(      Selected: %audio%

echo(
echo(

echo(  Select PNG
call:fileSelectionSecond "%image%", "%imagefolder%", "Choose an image", image, imagefolder
echo(      Selected: %image%

echo(
echo(

set /P name=Set file name: 
if not exist "output" mkdir output
"ffmpeg\bin\ffmpeg.exe" -i "%audiofolder%\%audio%" -i "%imagefolder%\%image%" -s 1080x1080 -pix_fmt yuv420p -codec:a copy "output\%name%.mp4"
EndLocal

goto :choice

exit/B

:choice
set /P c=Do you want to continue ? [y/N] 
if /I "%c%" EQU "Y" goto :start
if /I "%c%" EQU "N" exit
goto :choice

:fileSelection
SetLocal & set "file=%~1" & set "folder=%~2"  &
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.filename='%~1';$f.InitialDirectory='%~2';$f.title='%~3';$f.showHelp=$false;$f.Filter='MP3 files (*.mp3)^|*.mp3^|All files (*.*)^|*.*';$f.ShowDialog()^|Out-Null;$f.FileName""
for /f "delims=" %%I in ('%dialog%') do set "res=%%I"
echo "%res%" | find "\" >NUL && call:stripPath "%res%", file, folder  &
EndLocal & set "%4=%file%" & set "%5=%folder%"
exit/B 0

:fileSelectionSecond
SetLocal & set "file=%~1" & set "folder=%~2"  &
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.filename='%~1';$f.InitialDirectory='%~2';$f.title='%~3';$f.showHelp=$false;$f.Filter='PNG files (*.png)^|*.png^|All files (*.*)^|*.*';$f.ShowDialog()^|Out-Null;$f.FileName""
for /f "delims=" %%I in ('%dialog%') do set "res=%%I"
echo "%res%" | find "\" >NUL && call:stripPath "%res%", file, folder  &
EndLocal & set "%4=%file%" & set "%5=%folder%"
exit/B 0

:fileSelectionThird
SetLocal & set "file=%~1" & set "folder=%~2"  &
set "dialog=powershell -sta "Add-Type -AssemblyName System.windows.forms^|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.filename='%~1';$f.InitialDirectory='%~2';$f.title='%~3';$f.showHelp=$false;$f.Filter='MP4 files (*.mp4)^|*.mp4^|All files (*.*)^|*.*';$f.ShowDialog()^|Out-Null;$f.FileName""
for /f "delims=" %%I in ('%dialog%') do set "res=%%I"
echo "%res%" | find "\" >NUL && call:stripPath "%res%", file, folder  &
EndLocal & set "%4=%file%" & set "%5=%folder%"
exit/B 0

:stripPath
SetLocal & set "file=%~nx1" & set "folder=%~dp1"
EndLocal & set "%2=%file%" & set "%3=%folder:~0,-1%"
exit/B
