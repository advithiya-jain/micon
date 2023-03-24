#!/bin/bash

#store the first arguemnt in a variable for the path
path=$1

#change directory to the path
cd "$path" || return

############################################################################################################
#
# gfind (GNU find): 
#
# Find all the cover art files in the directory and subdirectories that match the case-insensitive regex:
# ".*/cover\.\(jpg\|jpeg\|png\)$" (cover.jpg, cover.jpeg, cover.png) and print the path to the file 
#
# Using the find command gives us the full path to the cover art file so it's easier to traverse the 
# directory tree for changing the cover art for the parent directory and the flac files in the directory.
#
############################################################################################################
# while loop: We then pipe the output of the find command to a while loop that reads the output line by line
gfind . -type f -iregex '.*/cover\.\(jpg\|jpeg\|png\)$' -print0 | while IFS= read -r -d '' file; do

    # Extract the directory path from the file path and add a trailing slash
    dirpath=${file%/*}/  
    # Extract the filename from the path
    filename=${file##*/}

    # Change directory to the originally specified path 
    # (since we cd later to the directory containing the cover art)
    cd "$path" || exit 1

    # Set the cover art for the parent directory
    fileicon set "$dirpath" "$file"

    # Change directory to the directory containing the cover art
    cd "$dirpath" || exit 1

    # Loop through all the flac files in the directory
    for i in *.mp3 *.flac *.m4a *.ogg *.wav *.aiff *.wma *.alac; do

        # set the cover art for the file using the cover art filename
        fileicon set "$i" "$filename"

    done
done