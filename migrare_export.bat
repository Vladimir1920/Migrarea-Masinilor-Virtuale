@echo off
setlocal enabledelayedexpansion

:: ===== Început cronometru TOTAL =====
set /a START=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%

:: ===== Căutare WinRAR sau 7-Zip pe discul C =====
echo [INFO] Cautare WinRAR sau 7-Zip pe discul C...
set "ARCHIVER="
set "ARCHIVE_CMD="

for /f "delims=" %%F in ('dir /s /b /a:-d "C:\WinRAR.exe" 2^>nul') do (
    set "ARCHIVER=WINRAR"
    set "ARCHIVE_CMD=%%F"
    goto found_archiver
)
for /f "delims=" %%F in ('dir /s /b /a:-d "C:\7z.exe" 2^>nul') do (
    set "ARCHIVER=7ZIP"
    set "ARCHIVE_CMD=%%F"
    goto found_archiver
)

echo [EROARE] Nu a fost gasit WinRAR sau 7-Zip pe discul C.
pause
exit /b

:found_archiver
echo [INFO] Gasit arhivator: %ARCHIVER% la %ARCHIVE_CMD%

:: ===== Verificare fișier .ova =====
set "OVA_PATH=D:\Download\Migrari\MyDisertatie.ova"
if not exist "%OVA_PATH%" (
    echo [EROARE] Fisierul .ova nu exista: %OVA_PATH%
    pause
    exit /b
)

:: ===== Cronometru ARHIVARE =====
set /a T1=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
echo [INFO] Arhivare %OVA_PATH%...
if "%ARCHIVER%"=="WINRAR" (
    "%ARCHIVE_CMD%" a -afzip "D:\Download\Migrari\MyDisertatie.ova.zip" "%OVA_PATH%"
    if errorlevel 1 (
        echo [EROARE] WinRAR a returnat o eroare.
        pause
        exit /b
    )
) else (
    "%ARCHIVE_CMD%" a -tzip "D:\Download\Migrari\MyDisertatie.ova.zip" "%OVA_PATH%"
    if errorlevel 1 (
        echo [EROARE] 7-Zip a returnat o eroare.
        pause
        exit /b
    )
)
set /a T2=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
set /a DUR_ARHIV=T2-T1
call :format %DUR_ARHIV% T_ARHIV
echo [TIMP] Arhivarea a durat: %T_ARHIV%

:: ===== Căutare stick USB =====
echo [INFO] Cautare stick USB...
set "USB_DRIVE="
for %%E in (E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%E:\" (
        set "USB_DRIVE=%%E:"
        goto found_usb
    )
)
echo [EROARE] Nu a fost gasit niciun stick USB.
pause
exit /b

:found_usb
echo [INFO] Stick gasit: %USB_DRIVE%

:: ===== Creare folder \Migrari pe stick =====
if not exist "%USB_DRIVE%\Migrari" (
    echo [INFO] Folder \Migrari nu exista pe stick. Se creeaza...
    mkdir "%USB_DRIVE%\Migrari"
)

:: ===== Cronometru COPIERE =====
set /a T1=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
echo [INFO] Copiere arhiva pe stick...
copy /Y "D:\Download\Migrari\MyDisertatie.ova.zip" "%USB_DRIVE%\Migrari\" >nul
set /a T2=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
set /a DUR_COPY=T2-T1
call :format %DUR_COPY% T_COPY
if exist "%USB_DRIVE%\Migrari\MyDisertatie.ova.zip" (
    echo [OK] Arhiva a fost copiata cu succes.
    echo [TIMP] Copierea a durat: %T_COPY%
) else (
    echo [EROARE] Copierea a esuat.
    pause
    exit /b
)

:: ===== Ștergere arhivă locală =====
echo [INFO] Stergere arhiva locala...
del "D:\Download\Migrari\MyDisertatie.ova.zip"
if exist "D:\Download\Migrari\MyDisertatie.ova.zip" (
    echo [ATENTIE] Arhiva nu a fost stearsa. Poate este deschisa in alt program.
) else (
    echo [OK] Arhiva locala stearsa cu succes.
)

:: ===== Sfârșit cronometru TOTAL =====
set /a END=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
set /a DUR=END-START
call :format %DUR% T_TOTAL

echo.
echo [OK] Proces finalizat complet.
echo [TIMP TOTAL] Intregul script a durat: %T_TOTAL%
echo.
echo === Apasa orice tasta pentru a iesi... ===
pause >nul
exit /b

:: ===== Funcție simplă pentru format hh:mm:ss =====
:format
setlocal
set /a h=%1/3600, m=(%1%%3600)/60, s=%1%%60
if %h% lss 10 set h=0%h%
if %m% lss 10 set m=0%m%
if %s% lss 10 set s=0%s%
endlocal & set "%2=%h%:%m%:%s%"
exit /b