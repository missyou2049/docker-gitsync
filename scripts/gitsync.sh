#!/bin/bash

#
# Copyright 2015-2019 AtjonTV (Thomas Obernosterer)
#
# This is an OSPL Project
# OSPL is an License by ATVG-Studios: https://ospl.atvg-studios.at/
#

version="2.5"
version_date="25th March 2019"

function _folder ()
{
    if [ "$2" = "i" ]; then
        if [ -d "$1" ]; then
            echo "The folder $1 already exists"
            exit 1
        fi
    elif [ "$2" = "n" ]; then
        if [ -d "$1" ]; then
            return 0
	else
	    echo "The folder $1 does not exists"
	    exit 1
        fi
    fi
}

function create ()
{
    _folder $2 "i"
    echo "Cloning '$1'"
    git clone --mirror $1 $2 &> /dev/null
    cd $2
    echo "Setting remote '$3'"
    git remote set-url --push origin $3 &> /dev/null
    echo "Done.";
}

function push ()
{
    _folder $1 "n"
    cd $1
    echo "Pushing '$(pwd)'"
    git push --mirror  &> /dev/null
    echo "Pushed.";
}

function pull ()
{
    _folder $1 "n"
    cd $1
    echo "Pulling '$(pwd)'"
    git fetch -p origin &> /dev/null
    echo "Pulled.";
}

function sync ()
{
    _folder $1 "n"
    cd $1
    echo "Syncing '$(pwd)'"
    git fetch -p origin &> /dev/null
    git push --mirror &> /dev/null
    echo "Synced.";
}

function delete()
{
    _folder $1 "n"
    echo "Deleting '$(pwd)/$1'"
    rm -rf $1
    echo "Deleted."
}

function cron ()
{
    _folder $(pwd)/$1 "n"
    loc=$(pwd)/$1
    cd /tmp
    echo "Exporting Cron"
    crontab -l > crons
    echo "Writing Cron '0 * * * *' (Every hour) for '$loc'"
    echo "0 * * * * /usr/local/bin/gitsync sync $loc" >> crons
    echo "Reloading Cron"
    crontab crons
    echo "Removing TMP"
    rm crons
    echo "Done."
}

function install ()
{
    cd /tmp
    echo "Downloading .."
    wget https://gitlab.atvg-studios.at/root/Scripts/raw/gitsync/gitsync.sh -O gitsync.sh &> /dev/null
    echo "Installing .."
    mv gitsync.sh /usr/local/bin/gitsync &> /dev/null
    echo "Configuring .."
    chmod +x /usr/local/bin/gitsync &> /dev/null
    echo "Testing .."
    gitsync -v
    echo "Installed.";
}

function help ()
{
    echo "Creating (Create a new local mirror)"
    echo "  Command: gitsync create <source> <folder> <target>"
    echo "  Arguments:"
    echo "      <source> = Source Git repository"
    echo "      <folder> = The local name for the repository"
    echo "      <target> = Target Git repository"
    echo ""
    echo "Push (Push the local mirror)"
    echo "  Command: gitsync push <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
    echo ""
    echo "Pull (Pull to local mirror)"
    echo "  Command: gitsync pull <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
    echo ""
    echo "Sync (Fetch original and push mirror)"
    echo "  Command: gitsync sync <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
    echo ""
    echo "Delete (Remove local mirror)"
    echo "  Command: gitsync delete <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
    echo ""
    echo "Add-Cron (Create auto sync)"
    echo "  Command: gitsync add-cron <folder>"
    echo "  Arguments:"
    echo "      <folder> = The local name for the repository"
    echo ""
    echo "Install/Upgrade (Install GitSync)"
    echo "  Command: gitsync <install/upgrade>"
    echo "  Needs:"
    echo "      Root Access or write access to /usr/local/bin"
    echo ""
    echo "Version (Print GitSync Version)"
    echo "  Command: gitsync -v"
}

cd $(pwd)
if [ "${1}" = "create" ]
then
    echo "GitSync v$version ($version_date) by ATVG-Studios"
    if [ -n "${2}" ] || [ -n "${3}" ] || [ -n "${4}" ];
    then
        create ${2} ${3} ${4}
    fi
elif [ "${1}" = "push" ]
then
    echo "GitSync v$version ($version_date) by ATVG-Studios"
    if [ -n "${2}" ];
    then
        sync ${2}
    fi
elif [ "${1}" = "pull" ]
then
    echo "GitSync v$version ($version_date) by ATVG-Studios"
    if [ -n "${2}" ];
    then
        pull ${2}
    fi
elif [ "${1}" = "sync" ]
then
    echo "GitSync v$version ($version_date) by ATVG-Studios"
    if [ -n "${2}" ];
    then
        sync ${2}
    fi
elif [ "${1}" = "delete" ]
then
    echo "GitSync v$version ($version_date) by ATVG-Studios"
    if [ -n "${2}" ];
    then
        delete ${2}
    fi
elif [ "${1}" = "add-cron" ]
then
    echo "GitSync v$version ($version_date) by ATVG-Studios"
    if [ -n "${2}" ];
    then
        cron ${2}
    fi
elif [ "${1}" = "install" ] || [ "${1}" == "upgrade" ]
then
    echo "GitSync v$version ($version_date) by ATVG-Studios"
    install
elif [ "${1}" = "-v" ]
then
    echo "GitSync v$version ($version_date) by ATVG-Studios";
elif [ "${1}" = "help" ]
then
    help
else
    help
fi