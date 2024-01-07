# Activate-env

A bash/ cmd package designed to handle python virtual environments made by the py package venv.

---

# Setup requirements

## Windows machine - Command Prompt (cmd)

Add this repository to PATH and activate-env will be callable from any cmd shell.

## Windows machine - Bash shell

Create the following files in your home directory. Bash: ~ || Windows: C:/Users/user_name/
~/.bashrc:

```
alias activate-env='source activate-env'
```

Anything in .bashrc will be run by a bash shell as soon as the session is started. This creates the alias that will source the script (run it in your current shell session) when you call activate-env. This is required for the script to make changes to your current session instead of instantiating a new session and activate a virtual environment there.

You may need to also create ~/.bash_profile with the following contents to allow .bashrc to function properly.

```
test -f ~/.bashrc && . ~/.bashrc
```

#### Done! -- Now you can call activate-env in a bash shell on your windows machine.
