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
echo 5. อื่นๆ (เช่น ปรับแต่ง Registry, Defrag)
echo 6. บูท FPS
echo 7. สร้างทางลัดจุดคืนค่า
echo 8. ปิดการอัปเดต Windows อัตโนมัติ
echo 9. ทางลัดสำหรับแอปเริ่มต้น
echo 10. เพิ่มประสิทธิภาพการตั้งค่า Windows
echo 11. ปิดใช้งานบริการบลูทูธ
echo 12. ปิดใช้งานบริการการวินิจฉัยและการวัดระยะไกล
echo 13. ปิดใช้งานตัวจัดการการดาวน์โหลดแผนที่
echo 14. ปิดใช้งานบริการเสริม
echo 15. ปิดใช้งานบริการเครื่องพิมพ์
echo 16. ปิดใช้งาน Windows Defender
echo 17. ปิดใช้งานบริการ Xbox
echo 18. ออกจากโปรแกรม
echo 19. เลือกทั้งหมด (1-17)
echo.
set /p choice=กรุณาเลือกตัวเลือก (1-19): 

:: ตรวจสอบตัวเลือกและเรียกฟังก์ชันที่เกี่ยวข้อง
if "%choice%"=="1" goto CLOSE_PROGRAMS
if "%choice%"=="2" goto TUNE_WINDOWS
if "%choice%"=="3" goto CLEAN_CACHE
if "%choice%"=="4" goto TROUBLESHOOT
if "%choice%"=="5" goto MORE
if "%choice%"=="6" goto BOOT_FPS
if "%choice%"=="7" goto CREATE_RESTORE_POINT
if "%choice%"=="8" goto DISABLE_WINDOWS_UPDATE
if "%choice%"=="9" goto STARTUP_APPS
if "%choice%"=="10" goto OPTIMIZE_WINDOWS_SETTINGS
if "%choice%"=="11" goto DISABLE_BLUETOOTH
if "%choice%"=="12" goto DISABLE_DIAGNOSTICS
if "%choice%"=="13" goto DISABLE_MAPS_DOWNLOADER
if "%choice%"=="14" goto DISABLE_SUPPLEMENTARY_SERVICES
if "%choice%"=="15" goto DISABLE_PRINT_SERVICES
if "%choice%"=="16" goto DISABLE_WINDOWS_DEFENDER
if "%choice%"=="17" goto DISABLE_XBOX
if "%choice%"=="18" goto EXIT
if "%choice%"=="19" goto SELECT_ALL

:: จัดการข้อผิดพลาดเมื่อเลือกตัวเลือกที่ไม่ถูกต้อง
echo Invalid choice. Please enter a number between 1 and 19.
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
echo คุณสามารถปรับแต่ง Registry ของคุณได้จากที่นี่.
echo [%date% %time%] เปิด Registry Editor >> "%LOGFILE%"
pause
goto MORE

:DEFRAG_DISK
cls
echo กำลัง Defrag ฮาร์ดไดรฟ์...
:: ใช้คำสั่ง Defrag เพื่อทำการ Defragment ฮาร์ดไดรฟ์
defrag C: /O
echo การ Defrag เสร็จสมบูรณ์.
echo [%date% %time%] Defrag ฮาร์ดไดรฟ์ >> "%LOGFILE%"
pause
goto MORE

:BOOT_FPS
cls
echo กำลังตรวจสอบบูท FPS และเวลาในการบูท...
:: PowerShell command to get boot time and FPS
powershell.exe -Command "& {
    $bootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $fps = Measure-Command { 
        $counter = 0
        do {
            $counter++
            Start-Sleep -Milliseconds 100
        } while ($counter -lt 200)
    }.TotalMilliseconds / 200
    Write-Output 'Boot Time: $bootTime'
    Write-Output 'FPS: $fps'
} "
echo [%date% %time%] บูท FPS และเวลาในการบูท >> "%LOGFILE%"
pause
goto MENU

:CREATE_RESTORE_POINT
cls
echo กำลังสร้างจุดคืนค่า...
wmic /namespace:\\root\default path SystemRestore CreateRestorePoint "Pre-optimization", 100, 7
echo [%date% %time%] สร้างจุดคืนค่า >> "%LOGFILE%"
pause
goto MENU

:DISABLE_WINDOWS_UPDATE
cls
echo กำลังปิดการอัปเดต Windows อัตโนมัติ...
net stop wuauserv
sc config wuauserv start= disabled
echo [%date% %time%] ปิดการอัปเดต Windows >> "%LOGFILE%"
pause
goto MENU

:STARTUP_APPS
cls
echo กำลังเปิดตัวเลือกแอปเริ่มต้น...
start ms-settings:appsfeatures
echo [%date% %time%] เปิดตัวเลือกแอปเริ่มต้น >> "%LOGFILE%"
pause
goto MENU

:OPTIMIZE_WINDOWS_SETTINGS
cls
echo กำลังเพิ่มประสิทธิภาพการตั้งค่า Windows...
powercfg -h off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
echo [%date% %time%] ปรับแต่งการตั้งค่า Windows >> "%LOGFILE%"
pause
goto MENU

:DISABLE_BLUETOOTH
cls
echo กำลังปิดใช้งานบริการบลูทูธ...
sc stop BTHPORT
sc config BTHPORT start= disabled
echo [%date% %time%] ปิดใช้งานบริการบลูทูธ >> "%LOGFILE%"
pause
goto MENU

:DISABLE_DIAGNOSTICS
cls
echo กำลังปิดใช้งานบริการการวินิจฉัยและการวัดระยะไกล...
sc stop DiagTrack
sc config DiagTrack start= disabled
echo [%date% %time%] ปิดใช้งานบริการการวินิจฉัยและการวัดระยะไกล >> "%LOGFILE%"
pause
goto MENU

:DISABLE_MAPS_DOWNLOADER
cls
echo กำลังปิดใช้งานตัวจัดการการดาวน์โหลดแผนที่...
sc stop MapDownload
sc config MapDownload start= disabled
echo [%date% %time%] ปิดใช้งานตัวจัดการการดาวน์โหลดแผนที่ >> "%LOGFILE%"
pause
goto MENU

:DISABLE_SUPPLEMENTARY_SERVICES
cls
echo กำลังปิดใช้งานบริการเสริม...
sc stop DiagTrack
sc config DiagTrack start= disabled
echo [%date% %time%] ปิดใช้งานบริการเสริม >> "%LOGFILE%"
pause
goto MENU

:DISABLE_PRINT_SERVICES
cls
echo กำลังปิดใช้งานบริการเครื่องพิมพ์...
sc stop Spooler
sc config Spooler start= disabled
echo [%date% %time%] ปิดใช้งานบริการเครื่องพิมพ์ >> "%LOGFILE%"
pause
goto MENU

:DISABLE_WINDOWS_DEFENDER
cls
echo กำลังปิดใช้งาน Windows Defender...
sc stop WinDefend
sc config WinDefend start= disabled
echo [%date% %time%] ปิดใช้งาน Windows Defender >> "%LOGFILE%"
pause
goto MENU

:DISABLE_XBOX
cls
echo กำลังปิดใช้งานบริการ Xbox...
sc stop XboxGipSvc
sc config XboxGipSvc start= disabled
echo [%date% %time%] ปิดใช้งานบริการ Xbox >> "%LOGFILE%"
pause
goto MENU

:EXIT
cls
echo ขอบคุณที่ใช้โปรแกรม!
exit /b

:SELECT_ALL
cls
echo กำลังเลือกทั้งหมด...
goto CLOSE_PROGRAMS
goto TUNE_WINDOWS
goto CLEAN_CACHE
goto TROUBLESHOOT
goto MORE
goto BOOT_FPS
goto CREATE_RESTORE_POINT
goto DISABLE_WINDOWS_UPDATE
goto STARTUP_APPS
goto OPTIMIZE_WINDOWS_SETTINGS
goto DISABLE_BLUETOOTH
goto DISABLE_DIAGNOSTICS
goto DISABLE_MAPS_DOWNLOADER
goto DISABLE_SUPPLEMENTARY_SERVICES
goto DISABLE_PRINT_SERVICES
goto DISABLE_WINDOWS_DEFENDER
goto DISABLE_XBOX

:: Check for elevated privileges and prompt for admin rights if not
