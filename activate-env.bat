:: Activate-Env.bat
@echo off


:: List functionality
IF "%~1"=="-l" (
    type "%~dp0\documentation\commands.txt"
    GOTO END
)

:: Create .venv if it doesn't exist
IF NOT EXIST ".venv\" (
    echo Creating virtual environment...
    python -m venv .venv
)

:: Activate virtual env if not active
IF DEFINED VIRTUAL_ENV (
    IF NOT "%VIRTUAL_ENV%"=="%cd%\.venv" (
        :: Only interact with VIRTUAL_ENV variable in local
        :: EnableDelayedExpansion allows vars to be used in same code block
        SETLOCAL EnableDelayedExpansion
        echo Active virtual environment is not from this directory...
        echo "Current environment: %VIRTUAL_ENV%"
        echo Would you like to switch? [Y/N]
        set /p USERINPUT=

        :: /I makes case insensitive
        IF /I "!USERINPUT!"=="Y" (
            ENDLOCAL
            echo Deactivating current virtual environment...
            call "%VIRTUAL_ENV%\Scripts\deactivate.bat"
            echo Activating virtual environment from this directory...
            call "%cd%\.venv\Scripts\activate"
        ) ELSE (
            ENDLOCAL
            echo Virtual environment unchanged.
        ) 
    ) ELSE (
        echo Virtual environment from this directory is already active...
    )
) ELSE (
    echo No virtual environment active. Activating virtual environment from this directory...
    call "%cd%\.venv\Scripts\activate.bat"
)

:::: Anything after this will not be executed unless marked and referenced above ::::
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
    echo Creating .gitignore file...
    copy "%~dp0gitignore-templates\python.gitignore" .gitignore
)

:: Add .venv to gitignore if it is not present
IF EXIST ".gitignore" (
    SETLOCAL EnableDelayedExpansion
    SET FOUND=0
    FOR /f "delims=" %%i IN ('findstr /l ".venv" .gitignore') DO SET FOUND=1
    IF !FOUND! EQU 0 (
        echo adding '.venv' to .gitignore...
        echo.>> .gitignore
        echo .venv >> .gitignore
    ) ELSE (
        echo '.venv' is already present in .gitignore...
    )
    ENDLOCAL
) ELSE (
    echo .gitignore not present
)
GOTO NEXT_ARGUMENT


:HANDLE_REQUIREMENTS
:: Handle requirements installation
IF EXIST "requirements.txt" (
    echo Installing requirements from requirements.txt...
    python -m pip install --upgrade pip
    python -m pip install -r requirements.txt
) ELSE (
    echo Could not find requirements.txt...
)
GOTO NEXT_ARGUMENT


:HANDLE_REQUIREMENTS_RECURSIVELY
echo collecting requirements recursively
python "%~dp0\src-python\get_requirements.py" %cd% > "%~dp0\requirements\tmp_req.txt"

type "%~dp0\requirements\tmp_req.txt"
echo Do you want to install the above requirements? [Y/N]
set /p USERINPUT=

IF /I "!USERINPUT!"=="Y" (
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

:: Create Bash functionality
:: Create Deactivate script
:: Add background upgrade / update of pip and virtualenv
