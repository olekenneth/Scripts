#!/bin/sh

argNum=$#;

if [ "$1" == "--help" ]; then
    echo "usage: connect [hostname] [path] [username] [mountname]";
else
    username="";
    path="webdev";
    hostname="dev";
    mountname=$hostname;
    mountbase=~/sshfsmount;
    mountpath="$mountbase/$hostname";

    # Check if mount dir exists and create if not
    if [ ! -d $mountbase ]
    then
        mkdir $mountbase;
    fi

    # Check if dir for this host exists and create if not
    if [ ! -d $mountpath ]
    then
        mkdir $mountpath;
    fi

    if [ $argNum == 1 ]; then
        hostname=$1;
    fi

    if [ $argNum == 2 ]; then
        path=$2;
    fi

    if [ $argNum == 3 ]; then
        username="$3@";
    fi

    if [ $argNum == 4 ]; then
        mountname=$4;
    fi

    # Mount volume
    sshfs $username$hostname:$path $mountpath -ocache=no -onolocalcaches,noappledouble -ovolname=$mountname
fi
