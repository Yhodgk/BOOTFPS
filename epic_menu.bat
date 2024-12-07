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
echo 17. ติดตั้งซอฟต์แวร์จาก URL
echo 18. ปรับปรุงความปลอดภัยของระบบ
echo 19. ตรวจสอบสุขภาพของระบบ
echo 20. ออกจากโปรแกรม
echo.
set /p choice=กรุณาเลือกตัวเลือก (1-20): 

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
if "%choice%"=="17" goto INSTALL_SOFTWARE
if "%choice%"=="18" goto SECURITY
if "%choice%"=="19" goto SYSTEM_HEALTH
if "%choice%"=="20" goto EXIT
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
:: ใส่คำสั่งสำหรับดาวน์โหลดและอัปเดตสคริปต์ที่ใหม่กว่า (หากมี)
pause
goto MENU

:: ฟังก์ชันตั้งค่าการเชื่อมต่อเครือข่าย
:NETWORK_SETTINGS
cls
echo กำลังตั้งค่าการเชื่อมต่อเครือข่าย:
echo 1. เปิด/ปิด Wi-Fi
echo 2. เปลี่ยนการตั้งค่า IP
echo 3. กลับสู่เมนูหลัก
set /p network_choice=เลือกตัวเลือก (1-3): 

if "%network_choice%"=="1" (
    netsh interface set interface name="Wi-Fi" admin=enable
    echo Wi-Fi เปิดใช้งานแล้ว!
) else if "%network_choice%"=="2" (
    echo กรอกการตั้งค่า IP ใหม่:
    set /p new_ip=ที่อยู่ IP ใหม่: 
    netsh interface ip set address name="Wi-Fi" static %new_ip% 255.255.255.0 192.168.0.1
    echo การตั้งค่า IP ใหม่เสร็จสิ้น!
)
pause
goto MENU

:: ฟังก์ชันตรวจสอบการใช้งาน GPU
:GPU_USAGE
cls
echo การใช้งาน GPU:
echo ========================
wmic path win32_videocontroller get name, videoProcessor
pause
goto MENU

:: ฟังก์ชันทดสอบเครือข่าย (Ping, Traceroute)
:NETWORKTOOLS
cls
echo กรอกที่อยู่เพื่อทดสอบ:
set /p test_address=ที่อยู่: 
ping %test_address%
tracert %test_address%
pause
goto MENU

:: ฟังก์ชันตั้งค่าความปลอดภัยของระบบ
:SECURITY
cls
echo ตั้งค่าความปลอดภัยของระบบ:
echo 1. ตรวจสอบไฟร์วอลล์
echo 2. ปรับตั้งค่า UAC
echo 3. กลับสู่เมนูหลัก
set /p security_choice=เลือกตัวเลือก (1-3): 

if "%security_choice%"=="1" (
    netsh advfirewall show allprofiles
) else if "%security_choice%"=="2" (
    echo กำลังปรับตั้งค่า UAC...
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
    echo UAC ถูกตั้งค่าเรียบร้อย!
)
pause
goto MENU

:: ฟังก์ชันตรวจสอบสุขภาพของระบบ
:SYSTEM_HEALTH
cls
echo ตรวจสอบสุขภาพของระบบ:
echo =========================
chkdsk /f /r
pause
goto MENU

:: ฟังก์ชันออกจากโปรแกรม
:EXIT
cls
echo ขอบคุณที่ใช้ Epic CMD Menu 2024!
pause > nul
exit /B
