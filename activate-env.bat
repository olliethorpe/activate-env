@echo off
SETLOCAL

:: Check if a .venv folder exists
IF EXIST ".venv\" (
    echo Activating virtual environment from .venv folder.
    call ".venv\Scripts\activate"
    GOTO EndScript
)

:: Get the name of the current directory and replace '_' with '-'
FOR %%I IN (.) DO SET "CURRENT_DIR_NAME=%%~nxI"
SET "VENV_NAME=.%CURRENT_DIR_NAME:_=-%-venv"

:: Check if a virtual environment already exists
IF EXIST "%VENV_NAME%" (
    echo Activating existing virtual environment: %VENV_NAME%
) ELSE (
    echo Creating and activating new virtual environment: %VENV_NAME%
    python -m venv "%VENV_NAME%"
)

:: Activate the virtual environment
call "%VENV_NAME%\Scripts\activate"

:EndScript
ENDLOCAL