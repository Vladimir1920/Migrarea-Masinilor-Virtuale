@echo off
setlocal enabledelayedexpansion

:: ===== Inceput cronometru TOTAL =====
set /a START=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%

:: Cautare USB
echo [INFO] Cautare stick USB cu folderul \Migrari...
set "SRC="
for %%D in (E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  if exist "%%D:\Migrari\" (
    set "SRC=%%D:\Migrari"
    goto gasit
  )
)
:gasit
if not defined SRC (
  echo [EROARE] Stickul nu a fost gasit.
  pause
  exit /b
)
echo [INFO] Gasit folderul pe: %SRC%

:: Creare folder local
set "DEST=D:\Migrari"
echo [INFO] Creare folder: %DEST%
if not exist "%DEST%" mkdir "%DEST%"

:: ===== Copiere .zip =====
set /a T1=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
echo [INFO] Incep copierea arhivei din: %SRC%
for %%F in ("%SRC%\*.zip") do (
  set "ZIP=%%~nxF"
  echo [INFO] Gasit arhiva: !ZIP!
  copy "%%F" "%DEST%\%%~nxF" >nul
)
set /a T2=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
set /a DUR=T2-T1
call :format !DUR! COPIERE
echo [TIMP] Copierea a durat: %COPIERE%

:: ===== Dezarhivare =====
set /a T1=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
echo [INFO] Dezarhivare %ZIP%...
tar -xf "%DEST%\%ZIP%" -C "%DEST%"
del "%DEST%\%ZIP%"
set /a T2=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
set /a DUR=T2-T1
call :format !DUR! EXTRACT
echo [TIMP] Dezarhivarea a durat: %EXTRACT%

:: Verificare .ova
set "OVA=MyDisertatie.ova"
if exist "%DEST%\%OVA%" (
  echo [OK] Fisierul %OVA% a fost extras.
) else (
  echo [EROARE] Fisierul .ova nu exista.
  pause
  exit /b
)

:: ===== VBoxManage =====
echo [INFO] Cautare VBoxManage.exe...
set "VBOX="
for %%P in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  for /f "delims=" %%X in ('dir /b /s /a:-d "%%P:\VBoxManage.exe" 2^>nul') do (
    set "VBOX=%%X"
    goto gasitvbox
  )
)
:gasitvbox
if not defined VBOX (
  echo [EROARE] VBoxManage nu a fost gasit.
  pause
  exit /b
)
echo [DEBUG] VBoxManage gasit la: "%VBOX%"

:: ===== Import VM =====
set /a T1=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
echo [INFO] Import masina virtuala...
"%VBOX%" import "%DEST%\%OVA%" >nul
set /a T2=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
set /a DUR=T2-T1
call :format !DUR! IMPORT
echo [TIMP] Importul a durat: %IMPORT%

:: ===== Sfarsit TOTAL =====
set /a END=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
set /a DUR=END-START
call :format !DUR! TOTAL
echo.
echo === Gata! Masina virtuala a fost importata cu succes. ===
echo [TIMP TOTAL] Intregul proces a durat: %TOTAL%
pause
exit /b

:: ===== Functie simpla pentru format hh:mm:ss =====
:format
setlocal
set /a h=%1/3600, m=(%1%%3600)/60, s=%1%%60
if %h% lss 10 set h=0%h%
if %m% lss 10 set m=0%m%
if %s% lss 10 set s=0%s%
endlocal & set "%2=%h%:%m%:%s%"
exit /b