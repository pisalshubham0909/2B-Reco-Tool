@echo off
title GSTR-2B Reconciliation Tool Launcher
echo =======================================================
echo   GSTR-2B Reconciliation Tool
echo =======================================================
echo.
echo Installing/Verifying dependencies...
python -m pip install -r requirements.txt
if %ERRORLEVEL% neq 0 (
    echo.
    echo WARNING: Failed to install some dependencies. Trying to start anyway...
)
echo.
echo Starting Streamlit App...
python -m streamlit run app.py
pause
