#!/usr/bin/env bash

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
ESC="\e[0m"

function _echo_red()    { echo -e "$RED$1$ESC"; }
function _echo_green()  { echo -e "$GREEN$1$ESC"; }
function _echo_yellow() { echo -e "$YELLOW$1$ESC"; }
function is_installed() { test -n "$(command -v "$1")"; }

function _question(){
    retval=-1
    while [ $retval == -1 ]; do
        read -r -p "$1 (y\n) " _answ
        case "$_answ" in
            [Yy]*) retval=0;;
            [Nn]*) retval=1;;
        esac
    done 
    return $retval
}


