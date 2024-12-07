@echo off
:: ตั้งค่าให้รองรับภาษาไทยใน CMD
chcp 65001

:: ตรวจสอบว่าเปิดในโหมด Administrator หรือไม่
NET SESSION >nul 2>&1
if %errorlevel% neq 0 (
    echo สคริปต์นี้ต้องการสิทธิ์ผู้ดูแลระบบ
    echo กำลังกำหนดให้เปิดใหม่ด้วยสิทธิ์ Administrator...
    pause
    :: เรียกตัวเองด้วยสิทธิ์ Administrator
    PowerShell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: ตั้งค่าภาพรวม
color 1f
title Epic CMD Menu 2024 - ระบบที่มีฟีเจอร์เสริม

:: เมนูหลัก
:MENU
cls
echo ========================================
echo        ยินดีต้อนรับสู่เมนู Epic CMD
echo ========================================
echo.
echo 1. แสดงข้อมูลระบบ
echo 2. ตรวจสอบการตั้งค่าเครือข่าย
echo 3. การใช้งานดิสก์และพื้นที่ว่าง
echo 4. จัดการไฟล์ (สร้าง/ลบ/สำรอง/ค้นหา/ย้าย)
echo 5. การใช้งาน CPU, RAM และ Storage
echo 6. ทดสอบความเร็วเครือข่าย
echo 7. สำรองข้อมูล
echo 8. ตรวจสอบการอัปเดตระบบ
echo 9. ปิด/รีสตาร์ทระบบ
echo 10. อัปเดตสคริปต์
echo 11. ตั้งค่าการเชื่อมต่อเครือข่าย (เปิด/ปิด Wi-Fi)
echo 12. ตรวจสอบการใช้งาน GPU
echo 13. ตรวจสอบการใช้งานเน็ตเวิร์ก (Ping, Traceroute)
echo 14. ค้นหาไฟล์
echo 15. ย้ายไฟล์
echo 16. สร้างโฟลเดอร์ใหม่
echo 17. ตรวจสอบสุขภาพของระบบ
echo 18. ล้างไฟล์แคช (Clear Cache)
echo 19. ออกจากโปรแกรม
echo.
set /p choice=กรุณาเลือกตัวเลือก (1-19): 

:: ตรวจสอบการเลือกและเปลี่ยนไปยังฟังก์ชันที่เกี่ยวข้อง
if "%choice%"=="1" goto SYSTEMINFO
if "%choice%"=="2" goto NETWORKSTATUS
if "%choice%"=="3" goto DISKUSAGE
if "%choice%"=="4" goto FILEMANAGE
if "%choice%"=="5" goto CPU_RAM_STORAGE
if "%choice%"=="6" goto SPEEDTEST
if "%choice%"=="7" goto BACKUP
if "%choice%"=="8" goto SYSTEMUPDATE
if "%choice%"=="9" goto SHUTDOWN
if "%choice%"=="10" goto SCRIPTUPDATE
if "%choice%"=="11" goto NETWORK_SETTINGS
if "%choice%"=="12" goto GPU_USAGE
if "%choice%"=="13" goto NETWORKTOOLS
if "%choice%"=="14" goto SEARCHFILES
if "%choice%"=="15" goto MOVEFILES
if "%choice%"=="16" goto CREATEFOLDER
if "%choice%"=="17" goto SYSTEM_HEALTH
if "%choice%"=="18" goto CLEAR_CACHE
if "%choice%"=="19" goto EXIT
goto MENU

:: ฟังก์ชันการแสดงข้อมูลระบบ
:SYSTEMINFO
cls
echo ข้อมูลระบบ:
echo ========================
systeminfo
pause
goto MENU

:: ฟังก์ชันตรวจสอบการตั้งค่าเครือข่าย
:NETWORKSTATUS
cls
echo การตั้งค่าเครือข่าย:
echo ========================
ipconfig
pause
goto MENU

:: ฟังก์ชันการใช้งานดิสก์และพื้นที่ว่าง
:DISKUSAGE
cls
echo การใช้งานดิสก์และพื้นที่ว่าง:
echo ==========================
wmic logicaldisk get size,freespace,caption
pause
goto MENU

:: ฟังก์ชันการจัดการไฟล์
:FILEMANAGE
cls
echo การจัดการไฟล์
echo =================
echo 1. สร้างไฟล์ใหม่
echo 2. ลบไฟล์
echo 3. สำรองไฟล์
echo 4. ค้นหาไฟล์
echo 5. ย้ายไฟล์
echo 6. กลับสู่เมนูหลัก
set /p file_choice=เลือกตัวเลือก (1-6): 

if "%file_choice%"=="1" goto CREATEFILE
if "%file_choice%"=="2" goto DELETEFILE
if "%file_choice%"=="3" goto BACKUPFILES
if "%file_choice%"=="4" goto SEARCHFILES
if "%file_choice%"=="5" goto MOVEFILES
if "%file_choice%"=="6" goto MENU
goto FILEMANAGE

:: สร้างไฟล์ใหม่
:CREATEFILE
cls
echo กรอกชื่อไฟล์ที่ต้องการสร้าง:
set /p filename=ชื่อไฟล์: 
echo กำลังกสร้างไฟล์ %filename%...
echo Hello, this file was created by Epic CMD Menu! > "%filename%"
if exist "%filename%" (
    echo ไฟล์ "%filename%" ถูกสร้างขึ้นแล้ว!
) else (
    echo ไม่สามารถสร้างไฟล์ได้!
)
pause
goto FILEMANAGE

:: ลบไฟล์
:DELETEFILE
cls
echo กรอกชื่อไฟล์ที่ต้องการลบ:
set /p filename=ชื่อไฟล์: 
del "%filename%"
echo ไฟล์ "%filename%" ถูกลบเรียบร้อยแล้ว!
pause
goto FILEMANAGE

:: สำรองไฟล์
:BACKUPFILES
cls
echo กรอกไดเรกทอรีต้นทางที่ต้องการสำรอง:
set /p source_dir=ไดเรกทอรีต้นทาง: 
echo กรอกไดเรกทอรีปลายทางที่ต้องการสำรอง:
set /p backup_dir=ไดเรกทอรีปลายทาง: 
if exist "%source_dir%" (
    xcopy "%source_dir%" "%backup_dir%" /E /H /C /I
    echo สำรองข้อมูลเสร็จสิ้น!
) else (
    echo ไดเรกทอรีต้นทางไม่พบ!
)
pause
goto FILEMANAGE

:: ค้นหาไฟล์
:SEARCHFILES
cls
echo กรอกชื่อไฟล์ที่ต้องการค้นหา:
set /p search_name=ชื่อไฟล์: 
dir /s /b "%search_name%"
pause
goto FILEMANAGE

:: ย้ายไฟล์
:MOVEFILES
cls
echo กรอกไฟล์ต้นทางที่ต้องการย้าย:
set /p source_file=ไฟล์ต้นทาง: 
echo กรอกที่อยู่ปลายทาง:
set /p dest_dir=ที่อยู่ปลายทาง: 
if exist "%source_file%" (
    move "%source_file%" "%dest_dir%"
    echo ย้ายไฟล์เสร็จสิ้น!
) else (
    echo ไม่พบไฟล์ต้นทาง!
)
pause
goto FILEMANAGE

:: สร้างโฟลเดอร์ใหม่
:CREATEFOLDER
cls
echo กรอกชื่อโฟลเดอร์ที่ต้องการสร้าง:
set /p foldername=ชื่อโฟลเดอร์: 
mkdir "%foldername%"
echo โฟลเดอร์ "%foldername%" ถูกสร้างขึ้นแล้ว!
pause
goto FILEMANAGE

:: ฟังก์ชันการใช้งาน CPU, RAM และ Storage
:CPU_RAM_STORAGE
cls
echo การใช้งาน CPU, RAM และ Storage:
echo =============================
wmic cpu get loadpercentage
wmic os get FreePhysicalMemory,TotalVisibleMemorySize
wmic logicaldisk get caption, freespace, size
pause
goto MENU

:: ฟังก์ชันทดสอบความเร็วเครือข่าย
:SPEEDTEST
cls
echo ทดสอบความเร็วเครือข่าย:
echo ========================
speedtest-cli
pause
goto MENU

:: ฟังก์ชันการสำรองข้อมูล
:BACKUP
cls
echo กำลังสำรองข้อมูล...
:: สำรองข้อมูลด้วยคำสั่ง xcopy หรือ robocopy
xcopy "C:\Users\%USERNAME%\Documents" "D:\Backup" /E /H /C /I
pause
goto MENU

:: ฟังก์ชันตรวจสอบการอัปเดตระบบ
:SYSTEMUPDATE
cls
echo กำลังตรวจสอบการอัปเดต...
powershell -Command "Get-WindowsUpdate"
pause
goto MENU

:: ฟังก์ชันปิด/รีสตาร์ทระบบ
:SHUTDOWN
cls
echo 1. ปิดเครื่อง
echo 2. รีสตาร์ทเครื่อง
set /p shutdown_choice=เลือกตัวเลือก (1-2): 
if "%shutdown_choice%"=="1" shutdown /s /f /t 0
if "%shutdown_choice%"=="2" shutdown /r /f /t 0
pause
goto MENU

:: ฟังก์ชันอัปเดตสคริปต์
:SCRIPTUPDATE
cls
echo กำลังอัปเดตสคริปต์...
:: ดาวน์โหลดสคริปต์เวอร์ชันใหม่จาก GitHub หรือที่ตั้งไว้
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Yhodgk/BOOTFPS/main/epic_menu.bat' -OutFile 'C:\PathToYourScript\epic_menu.bat'"
echo อัปเดตเสร็จสิ้น
pause
goto MENU

:: ฟังก์ชันตั้งค่าการเชื่อมต่อเครือข่าย (เปิด/ปิด Wi-Fi)
:NETWORK_SETTINGS
cls
echo 1. เปิด Wi-Fi
echo 2. ปิด Wi-Fi
set /p wifi_choice=เลือกตัวเลือก (1-2): 
if "%wifi_choice%"=="1" netsh interface set interface name="Wi-Fi" admin=enabled
if "%wifi_choice%"=="2" netsh interface set interface name="Wi-Fi" admin=disabled
pause
goto MENU

:: ฟังก์ชันตรวจสอบการใช้งาน GPU
:GPU_USAGE
cls
echo การใช้งาน GPU:
echo ========================
wmic path win32_videocontroller get name, adapterram, currentdisplaymode
pause
goto MENU

:: ฟังก์ชันตรวจสอบการใช้งานเน็ตเวิร์ก
:NETWORKTOOLS
cls
echo 1. Ping
echo 2. Traceroute
set /p network_tool_choice=เลือกตัวเลือก (1-2): 
if "%network_tool_choice%"=="1" goto PING
if "%network_tool_choice%"=="2" goto TRACEROUTE
goto NETWORKTOOLS

:PING
cls
echo กรอกที่อยู่ IP หรือชื่อโดเมนเพื่อ Ping:
set /p ping_address=ที่อยู่ IP/ชื่อโดเมน: 
ping -t %ping_address%
pause
goto NETWORKTOOLS

:TRACEROUTE
cls
echo กรอกที่อยู่ IP หรือชื่อโดเมนเพื่อ Traceroute:
set /p tracert_address=ที่อยู่ IP/ชื่อโดเมน: 
tracert %tracert_address%
pause
goto NETWORKTOOLS

:: ฟังก์ชันล้างไฟล์แคช
:CLEAR_CACHE
cls
echo ล้างไฟล์แคช
echo =================
del /q /s /f %TEMP%\*.*
del /q /s /f %windir%\Temp\*.*
echo ล้างไฟล์แคชเสร็จสิ้น!
pause
goto MENU

:: ฟังก์ชันตรวจสอบสุขภาพของระบบ
:SYSTEM_HEALTH
cls
echo กำลังตรวจสอบสุขภาพของระบบ...
wmic /namespace:\\root\cimv2 path Win32_OperatingSystem get FreePhysicalMemory, TotalVisibleMemorySize, FreeSpace
pause
goto MENU

:: ฟังก์ชันออกจากโปรแกรม
:EXIT
cls
echo ขอบคุณที่ใช้ Epic CMD Menu!
exit /b
