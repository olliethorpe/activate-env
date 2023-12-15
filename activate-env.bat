@echo off

:: Create .venv if it doesn't exist
IF NOT EXIST ".venv\" (
    echo Creating virtual environment from .venv folder.
    python -m venv .venv
)

:: Active venv if not active
:::: Only interact with VIRTUAL_ENV in local
SETLOCAL
IF DEFINED VIRTUAL_ENV (
    echo virtual environment is already active.
    GOTO SKIP_ACTIVATE
) ELSE (
    echo Activating virtual environment.
)
ENDLOCAL
call ".venv\Scripts\activate"
:: Jump to skip_activate if venv is already active
:SKIP_ACTIVATE

:: Check for '-g' argument and create .gitignore if needed
IF "%1"=="-g" (
    IF NOT EXIST ".gitignore" (
        echo Creating .gitignore file
        copy C:\Users\n529634\scripts\gitignore-templates\python.gitignore .gitignore
    )

    :: Add .venv to gitignore if it is not present
    IF EXIST ".gitignore" (
        SETLOCAL EnableDelayedExpansion
        SET FOUND=0
        FOR /f "delims=" %%i IN ('findstr /l ".venv" .gitignore') DO SET FOUND=1
        IF !FOUND! EQU 0 (
            echo adding .venv to .gitignore
            echo.>> .gitignore
            echo .venv >> .gitignore
        ) ELSE (
            echo .venv in .gitignore
        )
        ENDLOCAL
    ) ELSE (
        echo .gitignore not present
    )
)
