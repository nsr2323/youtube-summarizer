@echo off
chcp 65001 >nul
title YouTube 影片摘要生成器 (Google API 有字幕版)

REM 切換到腳本所在目錄
cd /d "%~dp0"

echo.
echo ========================================
echo   YouTube 影片摘要生成器 (Google API 有字幕版)
echo ========================================
echo.

REM 檢查環境變數或 .env 檔案
if not defined GOOGLE_API_KEY (
    if exist .env (
        echo 從 .env 檔案載入 API Key...
        for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
            if "%%a"=="GOOGLE_API_KEY" set GOOGLE_API_KEY=%%b
        )
    )
)

if not defined GOOGLE_API_KEY (
    echo.
    echo 錯誤：未設定 GOOGLE_API_KEY 環境變數！
    echo.
    echo 請選擇以下方式之一設定 API Key：
    echo 1. 建立 .env 檔案並加入：GOOGLE_API_KEY=您的API金鑰
    echo 2. 設定系統環境變數 GOOGLE_API_KEY
    echo.
    echo 申請 API Key：https://aistudio.google.com/app/apikey
    echo.
    pause
    exit /b 1
)

set "VIDEO_URL=%~1"

if "%VIDEO_URL%"=="" (
    echo 請輸入 YouTube 影片網址：
    set /p VIDEO_URL="網址: "
)

if "%VIDEO_URL%"=="" (
    echo.
    echo 錯誤：未提供網址！
    pause
    exit /b 1
)

echo.
echo 正在處理：%VIDEO_URL%
echo 使用 Google AI Studio API 生成摘要（有字幕版）...
echo.

REM 檢查 Python 是否可用
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo 錯誤：找不到 Python！請確保 Python 已安裝並添加到系統 PATH。
    echo.
    echo 請訪問 https://www.python.org/downloads/ 下載並安裝 Python
    pause
    exit /b 1
)

REM 檢查並安裝必要的套件（簡化版）
echo 檢查 Python 套件...
python -c "import google.generativeai, youtube_transcript_api, requests" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo 正在安裝必要的套件...
    python -m pip install google-generativeai youtube-transcript-api requests
    echo.
) else (
    echo 套件檢查完成，繼續執行...
)

python youtube_summarizer_google_with_subtitle.py "%VIDEO_URL%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 處理完成！摘要已儲存。
) else (
    echo.
    echo 處理失敗！請檢查錯誤訊息。
    echo.
    echo 如果遇到套件依賴問題，請執行：
    echo   完全修復套件.bat
)

echo.
pause
