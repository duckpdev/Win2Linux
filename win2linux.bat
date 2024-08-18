@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
cls

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
    set "url=https://mirrors.niyawe.de/archlinux/iso/2024.08.01/archlinux-2024.08.01-x86_64.iso"
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

echo Preparing for install

mkdir C:\temp > NUL
curl\curl -L -o C:\temp\target.iso "%url%"
rem copy target.iso C:\temp\target.iso

echo ArchLinux iso: C:\temp\target.iso
echo Mirror: "%url%"

grub2-for-windows\winrar\winrar X C:\temp\target.iso C:\temp > NUL
echo Extracted ArchLinux C:\temp 

xcopy C:\temp\arch C:\arch /E /H /C /I /K > NUL
xcopy C:\temp\loader C:\loader /E /H /C /I /K > NUL
mkdir C:\arch\boot > NUL
mkdir C:\arch\boot\grub > NUL
copy loopback.cfg C:\arch\boot\grub\loopback.cfg > NUL 
echo Copied ArchLinux to C:\

grub2-for-windows\install.bat 
