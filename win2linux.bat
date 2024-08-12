
@echo off
set "currentdir=%~dp0"
cd %currentdir%

echo Hello !!!

echo Warning: All your data will be erased please make backup to another disk (very very small chance)

:ask
echo Do you need to install linux on your pc ? (Y/N)
set /p choice=Choose option:

if /i "%choice%"=="Y" (
    goto :continue
) else if /i "%choice%"=="N" (
    exit
) else if /i "%choice%"=="y" (
    goto :continue
) else if /i "%choice%"=="n" (
    exit
) else (
    echo Invalid option
    goto :ask
)

:continue

:ask1
echo Select disk letter which don`t in use. Like C:, D:, B:, A:, O: and etc (Need with : example: a:,b: and etc)
set /p unusedLetter=Choose disk letter:

if /i "%unusedLetter%"=="" (
    echo Null letter
    goto :ask1
)

:ask2

echo Mirrors:
echo ru - Russia
echo us - USA
echo de - Germany
echo ch - China
echo ww - World wide

set /p mirror=Choose mirror:

if /i "%mirror%"=="ru" (
    echo Selected mirror: Russia
    set "url=https://mirror.yandex.ru/archlinux/iso/2024.08.01/archlinux-2024.08.01-x86_64.iso"
) else if /i "%mirror%"=="us" (
    echo Selected mirror: USA
    set "url=https://mirrors.edge.kernel.org/archlinux/iso/2024.08.01/archlinux-2024.08.01-x86_64.iso"
) else if /i "%mirror%"=="de" (
    echo Selected mirror: Germany
    set "url=https://arch.jensgutermuth.de/iso/2024.08.01/archlinux-2024.08.01-x86_64.iso"
) else if /i "%mirror%"=="ch" (
    echo Selected mirror: China
    set "url=https://mirrors.nju.edu.cn/archlinux/iso/2024.08.01/archlinux-2024.08.01-x86_64.iso"
) else if /i "%mirror%"=="ww" (
    echo Selected mirror: World wide
    set "url=https://mirror.rackspace.com/archlinux/iso/2024.08.01/archlinux-2024.08.01-x86_64.iso"
) else (
    echo Invalid mirror
    goto :ask2
)

:found

echo Mirror: %url%

echo Enter any key to continue Installing 

pause

echo Installing arch linux iso


if not exist C:\temp (
    mkdir C:\temp
    echo Created temp directory
) 

curl\curl -L -o C:\temp\target.iso "%url%"

echo Done

for /f "skip=1 tokens=2 delims= " %%d in ('wmic logicaldisk get name') do (
    call :searchAndDelete %%d
)

call :cont

:searchAndDelete
for /f "delims=" %%i in ('where winauto.label') do (
    del "%%i"
)

for /f "tokens=2,3" %%a in ('wmic logicaldisk where "DeviceID='C:'" assoc /assocclass:Win32_LogicalDiskToPartition 2^>nul ^| findstr /i "DiskIndex PartitionNumber"') do (
    if "%%a"=="DiskIndex" set mainDisk=%%b
    if "%%a"=="PartitionNumber" set partitionNumber=%%b
)

exit /b

:cont

set "root=set root=(hd%mainDisk%,gpt%partitionNumber%)"

xcopy winrar c:\windows\system32 /s /e /h /i /y

echo Done

echo Unpacking iso file

winrar x c:/temp/target.iso C:\arch\

echo Done

echo Unpacking GRUB



echo Copying files
copy loopback.cfg c:\arch\boot\grub
mkdir c:\bot
winrar x boot.zip c:\bot
echo Done

echo "idk" > c:\winauto.label 

echo %unusedLetter%

mountvol %unusedLetter% /s 

set "TARGET=C:\grub"                             
set "ISO_CONTENT_PATH=C:\target"          

for /f "tokens=2 delims={}" %%i in ('bcdedit /create /d "GRUB" /application bootsector') do (
    set "ID={%%i}"
)

xcopy efi\boot %unusedLetter%\efi\boot /s /e /h /i /y
xcopy c:\bot\boot %unusedLetter%\boot /s /e /h /i /y

echo Boot entry ID: {bootmgr}

bcdedit /set {bootmgr} path efi\boot\bootx64.efi

bcdedit /displayorder {bootmgr} /addlast

bcdedit /timeout 10

echo Done

echo win2linux is successfuly installed

echo Enter any key to reboot system...

pause

shutdown /r /t 0
