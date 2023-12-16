:: Activate-Env.bat
@echo off

:: List functionality
IF "%~1"=="-l" (
    type "%~dp0\documentation\commands.txt"
    GOTO END
)


:: Create .venv if it doesn't exist
IF NOT EXIST ".venv\" (
    echo Creating virtual environment from .venv folder.
    python -m venv .venv
)

:: Activate virtual env if not active
:::: Only interact with VIRTUAL_ENV variable in local
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


:: Iterate through arguments
:PARSE_ARGUMENTS
IF "%~1"=="" GOTO END
IF "%~1"=="-g" GOTO HANDLE_GITIGNORE
IF "%~1"=="-r" GOTO HANDLE_REQUIREMENTS
IF "%~1"=="-re" GOTO HANDLE_REQUIREMENTS_RECURSIVELY
SHIFT
GOTO PARSE_ARGUMENTS


:HANDLE_GITIGNORE
:: Handle .gitignore creation or modification
IF NOT EXIST ".gitignore" (
    echo Creating .gitignore file
    copy "%~dp0\gitignore-templates\python.gitignore" .gitignore
)

:: Add .venv to gitignore if it is not present
IF EXIST ".gitignore" (
    SETLOCAL EnableDelayedExpansion
    SET FOUND=0
    FOR /f "delims=" %%i IN ('findstr /l ".venv" .gitignore') DO SET FOUND=1
    IF !FOUND! EQU 0 (
        echo adding '.venv' to .gitignore
        echo.>> .gitignore
        echo .venv >> .gitignore
    ) ELSE (
        echo .venv in .gitignore
    )
    ENDLOCAL
) ELSE (
    echo .gitignore not present
)
GOTO NEXT_ARGUMENT


:HANDLE_REQUIREMENTS
:: Handle requirements installation
IF EXIST "requirements.txt" (
    echo installing requirements from requirements.txt
    python -m pip install --upgrade pip
    python -m pip install -r requirements.txt
) ELSE (
    echo could not find requirements.txt
)
GOTO NEXT_ARGUMENT


:HANDLE_REQUIREMENTS_RECURSIVELY
echo collecting requirements recursively
python "%~dp0\src-python\get_requirements.py" %cd% > "%~dp0\requirements\tmp_req.txt"

type "%~dp0\requirements\tmp_req.txt"
echo Do you want to install requirements above requirements? [y/n]
set /p USERINPUT=

IF /I "!USERINPUT!"=="y" (
    python -m pip install -r tmp_req.txt
) ELSE (
    echo Installation aborted.
)
del "%~dp0\requirements\tmp_req.txt"
GOTO NEXT_ARGUMENT

:NEXT_ARGUMENT
SHIFT
GOTO PARSE_ARGUMENTS

:END

::TODO: Use %~dp0 instead of explicit path
::TODO: create list functionality
