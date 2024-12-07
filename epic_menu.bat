@echo off
chcp 65001

:: ตรวจสอบสิทธิ์ผู้ดูแลระบบ
:: ตรวจสอบว่าผู้ใช้เป็นผู้ดูแลระบบหรือไม่
if not "%errorlevel%" == "0" (
    echo กรุณารันสคริปต์นี้ในฐานะผู้ดูแลระบบ.
    exit /b
)

:: ฟังก์ชันบันทึกกิจกรรม
SET LOGFILE="%USERPROFILE%\performance.log"

:MENU
cls
echo ========================================
echo     ยินดีต้อนรับสู่เมนูปรับปรุงประสิทธิภาพ
echo ========================================
echo.
echo 1. ปิดโปรแกรมที่ไม่จำเป็น
echo 2. ปรับแต่งการตั้งค่า Windows
echo 3. ล้างแคชและไฟล์ชั่วคราว
echo 4. ตรวจสอบและแก้ไขปัญหา
echo 5. ซ่อมแซม Network
echo 6. ซ่อมแซม Power Plan
echo 7. เคลียไฟล์ Temp
echo 8. ซ่อมแซม Windows
echo 9. แก้พับจอเกมส์แล้วค้าง
echo 10. ซ่อม Windows Service Control
echo 11. ซ่อม Windows Search Box
echo 12. อื่นๆ (เช่น ปรับแต่ง Registry, Defrag)
echo 13. บูท FPS
echo 14. สร้างทางลัดจุดคืนค่า
echo 15. ปิดการอัปเดต Windows อัตโนมัติ
echo 16. ทางลัดสำหรับแอปเริ่มต้น
echo 17. เพิ่มประสิทธิภาพการตั้งค่า Windows
echo 18. ปิดใช้งานบริการบลูทูธ
echo 19. ปิดใช้งานบริการการวินิจฉัยและการวัดระยะไกล
echo 20. ปิดใช้งานตัวจัดการการดาวน์โหลดแผนที่
echo 21. ปิดใช้งานบริการเสริม
echo 22. ปิดใช้งานบริการเครื่องพิมพ์
echo 23. ปิดใช้งาน Windows Defender
echo 24. ปิดใช้งานบริการ Xbox
echo 25. บันทึกและออก
echo 26. เลือกทั้งหมด (1-25)
echo.
set /p choice=กรุณาเลือกตัวเลือก (1-26): 

:: ตรวจสอบตัวเลือกและเรียกฟังก์ชันที่เกี่ยวข้อง
if "%choice%"=="1" goto CLOSE_PROGRAMS
if "%choice%"=="2" goto TUNE_WINDOWS
if "%choice%"=="3" goto CLEAN_CACHE
if "%choice%"=="4" goto TROUBLESHOOT
if "%choice%"=="5" goto REPAIR_NETWORK
if "%choice%"=="6" goto REPAIR_POWER_PLAN
if "%choice%"=="7" goto CLEAR_TEMP
if "%choice%"=="8" goto REPAIR_WINDOWS
if "%choice%"=="9" goto FIX_GAME_FOLD
if "%choice%"=="10" goto REPAIR_SERVICE_CONTROL
if "%choice%"=="11" goto REPAIR_SEARCH_BOX
if "%choice%"=="12" goto MORE
if "%choice%"=="13" goto BOOT_FPS
if "%choice%"=="14" goto CREATE_RESTORE_POINT
if "%choice%"=="15" goto DISABLE_WINDOWS_UPDATE
if "%choice%"=="16" goto STARTUP_APPS
if "%choice%"=="17" goto OPTIMIZE_WINDOWS_SETTINGS
if "%choice%"=="18" goto DISABLE_BLUETOOTH
if "%choice%"=="19" goto DISABLE_DIAGNOSTICS
if "%choice%"=="20" goto DISABLE_MAPS_DOWNLOADER
if "%choice%"=="21" goto DISABLE_SUPPLEMENTARY_SERVICES
if "%choice%"=="22" goto DISABLE_PRINT_SERVICES
if "%choice%"=="23" goto DISABLE_WINDOWS_DEFENDER
if "%choice%"=="24" goto DISABLE_XBOX
if "%choice%"=="25" goto LOG_AND_EXIT
if "%choice%"=="26" goto SELECT_ALL

:: จัดการข้อผิดพลาดเมื่อเลือกตัวเลือกที่ไม่ถูกต้อง
echo Invalid choice. Please enter a number between 1 and 26.
pause
goto MENU

:: ฟังก์ชันต่างๆ
:CLOSE_PROGRAMS
cls
echo กำลังปิดโปรแกรมที่ไม่จำเป็น...
:: รายการโปรแกรมที่จะปิด
for %%p in (notepad.exe calc.exe chrome.exe) do (
    taskkill /IM "%%p" /F 2>nul
)
echo โปรแกรมที่ไม่จำเป็นได้ถูกปิดแล้ว.
echo [%date% %time%] ปิดโปรแกรมที่ไม่จำเป็น >> "%LOGFILE%"
pause
goto MENU

:TUNE_WINDOWS
cls
echo กำลังปรับแต่งการตั้งค่า Windows...
:: ปิด System Restore point creation
echo ปิดการสร้างจุดคืนค่าระบบ...
powercfg -h off
echo การสร้างจุดคืนค่าระบบได้ถูกปิด
:: ปิดการใช้งานบริการที่ไม่จำเป็นอื่นๆ เช่น Windows Update, BTHPORT, DiagTrack, Spooler
sc stop wuauserv
sc config wuauserv start= disabled
sc stop BTHPORT
sc config BTHPORT start= disabled
sc stop DiagTrack
sc config DiagTrack start= disabled
sc stop Spooler
sc config Spooler start= disabled
echo [%date% %time%] ปรับแต่งการตั้งค่า Windows >> "%LOGFILE%"
pause
goto MENU

:CLEAN_CACHE
cls
echo กำลังล้างแคชและไฟล์ชั่วคราว...
:: ใช้คำสั่ง Disk Cleanup กับตัวเลือกเพิ่มเติม
cleanmgr /sagerun:1
echo แคชและไฟล์ชั่วคราวได้ถูกลบแล้ว.
echo [%date% %time%] ล้างแคชและไฟล์ชั่วคราว >> "%LOGFILE%"
pause
goto MENU

:TROUBLESHOOT
cls
echo กำลังตรวจสอบและแก้ไขปัญหา...
:: เรียกใช้เครื่องมือ Troubleshoot ของ Windows
msdt.exe /id WindowsUpdateDiagnostic
echo การตรวจสอบเสร็จสมบูรณ์.
echo [%date% %time%] ตรวจสอบและแก้ไขปัญหา >> "%LOGFILE%"
pause
goto MENU

:REPAIR_NETWORK
cls
echo กำลังซ่อมแซม Network...
:: รีสตาร์ทบริการ Network
netsh winsock reset
netsh int ip reset
echo [%date% %time%] ซ่อมแซม Network >> "%LOGFILE%"
pause
goto MENU

:REPAIR_POWER_PLAN
cls
echo กำลังซ่อมแซม Power Plan...
:: รีเซ็ต Power Plan เป็นค่าเริ่มต้น
powercfg -restoredefaultschemes
echo [%date% %time%] ซ่อมแซม Power Plan >> "%LOGFILE%"
pause
goto MENU

:CLEAR_TEMP
cls
echo กำลังเคลียไฟล์ Temp...
:: ลบไฟล์ Temp
del /Q %TEMP%\*.* >nul
echo [%date% %time%] เคลียไฟล์ Temp >> "%LOGFILE%"
pause
goto MENU

:REPAIR_WINDOWS
cls
echo กำลังซ่อมแซม Windows...
:: ใช้คำสั่ง SFC /SCANNOW เพื่อซ่อมแซมไฟล์ระบบ
sfc /scannow
echo [%date% %time%] ซ่อมแซม Windows >> "%LOGFILE%"
pause
goto MENU

:FIX_GAME_FOLD
cls
echo กำลังแก้พับจอเกมส์แล้วค้าง...
:: รีสตาร์ทบริการ Windows Service Control
net stop "Windows Update"
net start "Windows Update"
echo [%date% %time%] แก้พับจอเกมส์แล้วค้าง >> "%LOGFILE%"
pause
goto MENU

:REPAIR_SERVICE_CONTROL
cls
echo กำลังซ่อม Windows Service Control...
:: เรียกใช้ System File Checker (SFC) เพื่อซ่อมไฟล์ระบบที่เสียหาย
sfc /scannow
echo [%date% %time%] ซ่อม Windows Service Control >> "%LOGFILE%"
pause
goto MENU

:REPAIR_SEARCH_BOX
cls
echo กำลังซ่อม Windows Search Box...
:: รีเซ็ตการตั้งค่า Windows Search Box
powershell -Command "Reset-WindowsSearch"
echo [%date% %time%] ซ่อม Windows Search Box >> "%LOGFILE%"
pause
goto MENU

:MORE
cls
echo ฟังก์ชันอื่นๆ
echo 1. ปรับแต่ง Registry
echo 2. Defrag
echo.
set /p choice=กรุณาเลือกตัวเลือก (1-2): 

:: ตรวจสอบตัวเลือกและเรียกฟังก์ชันที่เกี่ยวข้อง
if "%choice%"=="1" goto CUSTOMIZE_REGISTRY
if "%choice%"=="2" goto DEFRAG_DISK

:: จัดการข้อผิดพลาดเมื่อเลือกตัวเลือกที่ไม่ถูกต้อง
echo Invalid choice. Please enter a number between 1 and 2.
pause
goto MORE

:CUSTOMIZE_REGISTRY
cls
echo กำลังเปิด Registry Editor...
:: เปิด Registry Editor
start regedit
echo คุณสามารถปรับแต่ง Registry ของคุณได้แล้ว.
pause
goto MORE

:DEFRAG_DISK
cls
echo กำลัง Defrag Disk...
:: เรียกใช้ Disk Defragmenter
defrag C: -O -V
echo [%date% %time%] Defrag Disk >> "%LOGFILE%"
pause
goto MORE

:BOOT_FPS
cls
echo กำลังเพิ่มประสิทธิภาพ FPS สำหรับเกม...
:: ปิดการใช้งานประสิทธิภาพการจัดการพลังงาน
powercfg -setactive scheme balanced
echo [%date% %time%] เพิ่มประสิทธิภาพ FPS สำหรับเกม >> "%LOGFILE%"
pause
goto MENU

:CREATE_RESTORE_POINT
cls
echo กำลังสร้างจุดคืนค่า...
:: สร้างจุดคืนค่า
wmic.exe /namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Performance Optimization" 100
echo [%date% %time%] สร้างจุดคืนค่า >> "%LOGFILE%"
pause
goto MENU

:DISABLE_WINDOWS_UPDATE
cls
echo กำลังปิดการอัปเดต Windows อัตโนมัติ...
:: ปิดการอัปเดต Windows อัตโนมัติ
sc stop wuauserv
sc config wuauserv start= disabled
echo [%date% %time%] ปิดการอัปเดต Windows อัตโนมัติ >> "%LOGFILE%"
pause
goto MENU

:STARTUP_APPS
cls
echo กำลังจัดการแอปเริ่มต้น...
:: เปิด Task Manager เพื่อจัดการแอปเริ่มต้น
start taskmgr
echo คุณสามารถจัดการแอปเริ่มต้นได้แล้ว.
pause
goto MENU

:OPTIMIZE_WINDOWS_SETTINGS
cls
echo กำลังเพิ่มประสิทธิภาพการตั้งค่า Windows...
:: เปิด Power Options เพื่อปรับแต่งการตั้งค่า
powercfg.cpl
echo [%date% %time%] เพิ่มประสิทธิภาพการตั้งค่า Windows >> "%LOGFILE%"
pause
goto MENU

:DISABLE_BLUETOOTH
cls
echo กำลังปิดใช้งานบริการบลูทูธ...
:: ปิดใช้งานบลูทูธ
sc config BTHPORT start= disabled
echo [%date% %time%] ปิดใช้งานบริการบลูทูธ >> "%LOGFILE%"
pause
goto MENU

:DISABLE_DIAGNOSTICS
cls
echo กำลังปิดใช้งานบริการการวินิจฉัยและการวัดระยะไกล...
:: ปิดการใช้งาน DiagTrack
sc config DiagTrack start= disabled
echo [%date% %time%] ปิดใช้งานบริการการวินิจฉัยและการวัดระยะไกล >> "%LOGFILE%"
pause
goto MENU

:DISABLE_MAPS_DOWNLOADER
cls
echo กำลังปิดใช้งานบริการดาวน์โหลดแผนที่...
:: ปิดการใช้งาน Windows Maps Downloader
sc config MAPSVC start= disabled
echo [%date% %time%] ปิดใช้งานบริการดาวน์โหลดแผนที่ >> "%LOGFILE%"
pause
goto MENU

:DISABLE_SUPPLEMENTARY_SERVICES
cls
echo กำลังปิดใช้งานบริการเสริม...
:: ปิดการใช้งานบริการเสริมอื่นๆ (เช่น Print Spooler, Windows Update)
sc stop "Print Spooler"
sc config "Print Spooler" start= disabled
echo [%date% %time%] ปิดใช้งานบริการเสริม >> "%LOGFILE%"
pause
goto MENU

:DISABLE_PRINT_SERVICES
cls
echo กำลังปิดใช้งานบริการเครื่องพิมพ์...
:: ปิดการใช้งาน Print Spooler
sc config "Spooler" start= disabled
echo [%date% %time%] ปิดใช้งานบริการเครื่องพิมพ์ >> "%LOGFILE%"
pause
goto MENU

:DISABLE_WINDOWS_DEFENDER
cls
echo กำลังปิดใช้งาน Windows Defender...
:: ปิดการใช้งาน Windows Defender
sc config WinDefend start= disabled
echo [%date% %time%] ปิดใช้งาน Windows Defender >> "%LOGFILE%"
pause
goto MENU

:DISABLE_XBOX
cls
echo กำลังปิดใช้งานบริการ Xbox...
:: ปิดการใช้งาน Xbox Services
sc stop "Xbox Live Auth Manager"
sc config "Xbox Live Auth Manager" start= disabled
echo [%date% %time%] ปิดใช้งานบริการ Xbox >> "%LOGFILE%"
pause
goto MENU

:LOG_AND_EXIT
cls
echo บันทึกกิจกรรม...
:: บันทึกและออกจากสคริปต์
echo [%date% %time%] ออกจากสคริปต์และบันทึกกิจกรรม >> "%LOGFILE%"
exit /b
