#!/bin/bash
#store the first arguemnt in a variable for the path
path=$1
cd "$path" || return
gfind . -maxdepth 2 -mindepth 1 -type d -printf "%f\n"