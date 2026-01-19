@echo off
setlocal

:: ==========================================
:: BEÁLLÍTÁSOK
:: ==========================================
set BRANCH=main
set REMOTE=origin
:: A GitHub Repository címe
set REPO_URL=https://github.com/wb-projects/AstroERP.git

:: Git eleresi utvonal
set GIT_CMD="C:\Program Files\Git\cmd\git.exe"

:: Felhasználói adatok
set GIT_NAME="AstroERP Fejleszto"
set GIT_EMAIL="info@astroerp.hu"

:: ==========================================
:: 0. LÉPÉS: Konfiguráció
:: ==========================================
echo.
echo [0/4] Git konfiguralasa...

%GIT_CMD% config user.email %GIT_EMAIL%
%GIT_CMD% config user.name %GIT_NAME%

:: Kapcsolat beállítása (ha már létezik, felülírjuk)
%GIT_CMD% remote add origin %REPO_URL% 2>nul
%GIT_CMD% remote set-url origin %REPO_URL%

:: Branch beállítása
%GIT_CMD% branch -M %BRANCH%

:: ==========================================
:: FELTÖLTÉS
:: ==========================================

echo.
echo [1/4] Fajlok hozzaadasa...
:: A PONT (.) MINDEN FAJLT HOZZAAD A MAPPABOL!
:: Igy biztosan nem marad ki semmi.
%GIT_CMD% add .

echo.
echo [2/4] Commit letrehozasa...
set TIMESTAMP=%DATE% %TIME%
%GIT_CMD% commit -m "Update release: %TIMESTAMP%"

echo.
echo [3/4] Feltoltes a GitHub-ra (KENYSZERITVE)...
:: A --force kapcsoló megoldja a "rejected" hibát
%GIT_CMD% push --force -u %REMOTE% %BRANCH%

if %errorlevel% equ 0 (
    echo.
    echo [SIKER] A feltoltes sikeres volt!
) else (
    echo.
    echo [HIBA] Nem sikerult a feltoltes.
)

pause