#!/bin/bash
#store the first arguemnt in a variable for the path
path=$1

#change directory to the path
cd "$path" || return

ctrj=0
ctrp=0
for i in *.jpg; do
    ctrj=$ctrj+1
done
for i in *.png; do
    ctrp=$ctrp+1
done

if [ $ctrj -eq $ctrp ] && [ $ctrp+$ctrj -ne 0 ]; then
    echo "More than one image type found, please remove the extra cover art and try again"
    exit 1
elif [ $ctrj -gt 1 ] && [ $ctrp -gt 1 ]; then
    echo "More than one cover art found, please remove the extra cover art and try again"

else    
    for i in *.flac; do
        fileicon set "$i" cover.png # set the cover art for the file
    done
fi

# If the cover art exists as a jpg file
#if [ -f cover.jpg ]; then
#    #loop through all the flac files in the directory
#    for i in *.flac; do
#        fileicon set "$i" "$path"/cover.jpg # set the cover art for the file
#    done
#    exit 1
#elif [ -f cover.png ]; then
#    #loop through all the flac files in the directory
#    for i in *.flac; do
#        fileicon set "$i" "$path"/cover.png # set the cover art for the file
#    done
#    exit 1
#else
#    ctr=0
#    for i in *.jpg; do
#        ctr++
#    done
#    if [ $ctr -gt 1 ]; then
#        echo "More than one cover art found, please remove the extra cover art and try again"
#        exit 1
#    else    
#        for i in *.jpg; do
#            fileicon set "$i" "$path"/"$i" # set the cover art for the file
#        done
#        exit 1
#    fi
#
#fi
#
#