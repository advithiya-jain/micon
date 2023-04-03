#!/bin/bash
# store the current directory in a variable for later use
script_dir=$(pwd)

#store the first arguemnt in a variable for the path
path="$1"

# Validate path argument
if [[ ! -d "$path" ]]; then
echo "Invalid path"
exit 1
fi

function seticon() {
	gfind "$1" -type f -iregex '.*/cover\.\(jpg\|jpeg\|png\)$' -print0 | while IFS= read -r -d '' file; do
		# Extract the filename from the path
		filename=${file##*/}
		musicdirpath=${file%/*}/
		echo "pwd: $(pwd)"
		echo " seticon music dir: $musicdirpath"
		echo " seticon argument: $1"
		# Change directory to the specified path 
		# (since we cd later to the directory containing the cover art)

		# Set the cover art for the parent directory
		fileicon set "$musicdirpath" "$file"

		# Change directory to the directory containing the cover art
		
		cd "$musicdirpath" || exit 1

		# Loop through all the flac files in the directory
		for i in *.mp3 *.flac *.m4a *.ogg *.wav *.aiff *.wma *.alac; do

			# set the cover art for the file using the cover art filename
			if fileicon set -q "$i" "$filename"; then
				echo "Set icon for $i"
			else
				echo " "
			fi

		done
	done
}

# Change directory to the path
cd "$path" || exit 1

# Declare an associative array to store processed directories
declare -a processed_dirs=()

find . -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.m4a" -o -iname "*.ogg" -o -iname "*.wav" -o -iname "*.aiff" -o -iname "*.wma" \) -print0 | while IFS= read -r -d '' file; do

	# Extract the directory path from the file path and add a trailing slash
	dirpath=${file%/*}/

	# Check if the directory has already been processed
	if [[ ! " ${processed_dirs[@]} " =~ " ${dirpath} " ]]; then
		echo "pwd in main loop: $(pwd)"
		# Process the directory
		if find "$dirpath" -maxdepth 1 -type f -name 'cover*' | grep -q '.'; then

			# Set the icon if the cover art exists
			echo "Cover art found for $dirpath"
			seticon "$dirpath"
			processed_dirs+=("$dirpath")

		else
			echo "No art found. Downloading based on Album folder name and Artist folder name"
			# Get the album and artist name from the directory path
			album=$(basename "$dirpath") # basename gives us the containing folder of the music file, which should be the album
			artist=$(basename "$(dirname "$dirpath")") # dirname of $dirpath gives us the parent directory of the album directory, which should be the artist
			echo "Directoy: $dirpath"
			echo "Artist: $artist"
			echo "Album: $album"
			#echo "pwd: $(pwd)"
			# Check if the python script exists
			if [[ -f "${script_dir}/cvrFndr.py" ]]; then
				# First change directory into the Album folder
				cd "$dirpath" || exit 1
				# Run the python script
				python3 "${script_dir}/cvrFndr.py" -a "$artist" -al "$album"
				# Now change directory back to the parent
				cd .. || exit 1
			else
				echo "cvrFndr.py not found"
				exit 1
			fi
			seticon "$dirpath"
			processed_dirs+=("$dirpath")
		fi
	fi

done
