# List available aliases
lsaliases() {
	echo
	echo 'Available aliases:'
	echo '=================='
	echo
	alias | awk -F'=' '{print $1}' | grep "alias" | awk '{gsub("alias ", ""); print}'
	echo
}

# List available functions
lsfunctions() {
	echo
	echo 'Available functions:'
	echo '===================='
	typeset -f | awk '/ \(\) $/ && !/^main / {print $1}' | awk '{gsub("command_not_found_handle", ""); print}'
	echo
}

# Create a symlink for a source and destination
# Params: $1 {source}, $2 {destination}
link() {
	rm -f $2
	ln -s $1 $2
	echo "Symlinked $1 to $2"
}

# Download a whole site, I think..
download_website() {
	if [ $# -eq 0 ]; then
		echo 'Oops. Please give me a directory.'
		return 1
	fi
	wget --mirror --convert-links --adjust-extension --page-requisites --no-parent $1
}

getavailabledisk() {
	i=1
	FIRSTAVAILABLEDISK="/dev/disk${i}s1"

	while [ $i -lt 99 ]; do
		if ! mount | grep -q "/dev/disk${i}s1"; then
			FIRSTAVAILABLEDISK="/dev/disk${i}s1"
			break
		fi
		((i++))
	done

	echo "$FIRSTAVAILABLEDISK"
}

backup() {
	DRYRUN=""

	if [[ $1 = "--dry-run" ]]; then
		DRYRUN="n"
	fi

	EVERYTHINGDRIVE="/Volumes/Everything"
	PHOTODRIVE="/Volumes/THICCC"

	if ! mount | grep -q $EVERYTHINGDRIVE && ! mount | grep -q $PHOTODRIVE; then
		echo '🙈 Either the Everything drive or the Photos drive must be mounted in order to continue. Exiting...'
		return 1
	fi

	if mount | grep -q $PHOTODRIVE; then
		echo "Starting photo backup to $PHOTODRIVE"

		rsync -rv$DRYRUN --delete --delete-after --size-only \
			--exclude-from="$HOME/.dotfiles/config/.rsyncignore" \
			"$ICLOUD_HOME/Photos/" "$PHOTODRIVE/"

		echo "📷 Completed rsync photo backup with exit code: $?"
	fi

	if mount | grep -q $EVERYTHINGDRIVE; then
		echo "Starting to backup everything to $EVERYTHINGDRIVE"

		rsync -rv$DRYRUN --delete --delete-after --size-only \
			--exclude-from="$HOME/.dotfiles/config/.rsyncignore" \
			"$ICLOUD_HOME/" "$EVERYTHINGDRIVE/"

		# Backup things that are not in iCloud
		mkdir -p $EVERYTHINGDRIVE/Backups
		rsync -rv$DRYRUN --delete --delete-after --size-only \
			--exclude-from="$HOME/.dotfiles/config/.rsyncignore" \
			"$HOME/Backups/" "$EVERYTHINGDRIVE/Backups/"

		echo "Rsync backup completed with exit code: $?"
	fi
}

# What is listening on a certain port?
# https://stackoverflow.com/a/30029855/1171790
# Optional param: $1 {A port number}
listening() {
	if [ $# -eq 0 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P
	elif [ $# -eq 1 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
	else
		echo "Usage: listening [port]"
	fi
}

# Get a known wifi password
wifi_password() {
	if [ $# -eq 0 ]; then
		echo 'Oops. Please tell me a wifi network name.'
		echo 'Usage: wifi-password <wifi network name>'
	else
		security find-generic-password -ga $1 | grep password:
	fi
}

# Just a quick function to reduce an image's size by percentage
shrink_image() {
	if [ $# -eq 0 ]; then
		echo 'Oops. Please give me a filename.'
		echo 'Usage: shrink-image <filename> [percentage]'
	else
		local percentage="${2:-50}"
		sips -Z "$percentage"% "$1" --out "$1"
	fi
}

# Quickly resize an image to a given width
resize_image_width() {
	if [ $# -ne 2 ]; then
		echo 'Oops. Please give me a filename and desired width.'
		echo 'Usage: resize-image-width <filename> <width in pixels>'
	else
		sips -z "$2" auto "$1" --out "$1"
	fi
}

# Prep high-res images for upload to blog-like things
blogimages() {
	echo 'Converting images to lo-res (900px wide)...'
	for i in *.jpg; do
		printf "Resizing $i\n"
		sips -z 900 auto "$i" --out "$i"
	done
	echo 'Done.'
}

# Converts various image formats (HEIC, DNG, 3G2, 3GP, PSD, TIFF, TIF, BMP, PDF, DV, MPEG) to JPEG.
# Automatically resizes images if their long edge exceeds IMAGE_LONG_EDGE_SIZE.
# Deletes original files after successful conversion.
#
# Usage:
#   convert_images_to_jpg /path/to/directory
#   convert_images_to_jpg .
#
# Parameters:
#   $1 - Directory path containing image files to convert
#
# Environment Variables:
#   IMAGE_LONG_EDGE_SIZE - Maximum size for the long edge in pixels (default: 3600)
#
# Quality Settings:
#   - Images requiring resize: 87
#   - Images without resize: 83
#
# Returns:
#   0 on success, 1 on error
convert_images_to_jpg() {
	if [ $# -eq 0 ]; then
		echo "❌ Error: No directory path provided"
		return 1
	fi

	if [ ! -d "$1" ]; then
		echo "❌ Error: Not a directory: $1"
		return 1
	fi

	local dir="$1"

	if [ -z "$IMAGE_LONG_EDGE_SIZE" ]; then
		IMAGE_LONG_EDGE_SIZE=3600
	fi

	local files=()
	while IFS= read -r -d '' file; do
		files+=("$file")
	done < <(find "$dir" -maxdepth 1 -type f \( \
		-iname "*.heic" -o \
		-iname "*.dng" -o \
		-iname "*.3g2" -o \
		-iname "*.3gp" -o \
		-iname "*.psd" -o \
		-iname "*.tiff" -o \
		-iname "*.tif" -o \
		-iname "*.bmp" -o \
		-iname "*.pdf" -o \
		-iname "*.dv" -o \
		-iname "*.mpeg" -o \
		-iname "*.mpg" \
		\) -print0)

	if [ ${#files[@]} -eq 0 ]; then
		echo "⚠️  Warning: No supported image files found in: $dir"
		return 0
	fi

	echo "📁 Found ${#files[@]} file(s) to process"

	for file in "${files[@]}"; do
		# Get the directory and filename without extension
		local file_dir=$(dirname "$file")
		local filename=$(basename "$file")
		local name="${filename%.*}"

		local output="$file_dir/$name.jpg"

		# Get image dimensions
		local width=$(sips -g pixelWidth "$file" 2>/dev/null | awk '/pixelWidth:/ {print $2}')
		local height=$(sips -g pixelHeight "$file" 2>/dev/null | awk '/pixelHeight:/ {print $2}')

		# Check if sips could read the file
		if [ -z "$width" ] || [ -z "$height" ]; then
			echo "⚠️  Warning: Could not read dimensions, skipping: $file"
			continue
		fi

		# Determine the long edge
		if [ "$width" -ge "$height" ]; then
			local long_edge=$width
		else
			local long_edge=$height
		fi

		# Convert to JPEG with quality and resize if needed
		if [ "$long_edge" -gt $IMAGE_LONG_EDGE_SIZE ]; then
			echo "🔄 Converting and resizing: $file -> $output"
			sips -s format jpeg -s formatOptions 87 --resampleHeightWidthMax $IMAGE_LONG_EDGE_SIZE "$file" --out "$output" >/dev/null 2>&1
		else
			echo "🔄 Converting (no resize needed): $file -> $output"
			sips -s format jpeg -s formatOptions 83 "$file" --out "$output" >/dev/null 2>&1
		fi

		if [ $? -eq 0 ]; then
			echo "✅ Successfully created: $output"
			if rm "$file"; then
				echo "🗑️  Deleted original: $file"
			else
				echo "⚠️  Warning: Failed to delete original file: $file"
			fi
		else
			echo "❌ Error converting: $file"
		fi
	done
}

download_video() {
	local url="$1"
	local output_dir="$HOME/Desktop"

	if ! command -v yt-dlp &>/dev/null; then
		echo "Error: yt-dlp is not installed. Please install it first."
		echo "Install with: pip install yt-dlp"
		echo "Or visit: https://github.com/yt-dlp/yt-dlp#installation"
		return 1
	fi

	if [[ -z "$url" ]]; then
		echo "Error: YouTube URL is required"
		echo "Usage: download_video <youtube_url>"
		echo "Example: download_video 'https://www.youtube.com/watch?v=8MUNWKQ9_9c'"
		return 1
	fi

	mkdir -p "$output_dir"

	echo "🔍 Analyzing video: $url"
	echo "📁 Download location: $output_dir"
	echo "🎯 Target: Max 1080p, optimized for size and compatibility"
	echo ""

	# Show available formats (first 15 lines to avoid clutter)
	echo "Available formats:"
	yt-dlp -F "$url" 2>/dev/null | head -15
	echo ""

	echo "🎬 Starting download..."
	echo ""

	# Download with optimized settings
	yt-dlp \
		--format-sort "res:1080,+size,+br,codec:h264:aac" \
		--format "bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[height<=1080][ext=mp4]/bv*[height<=720][ext=mp4]+ba[ext=m4a]/b[height<=720][ext=mp4]/bv*+ba/b" \
		--merge-output-format mp4 \
		--embed-thumbnail \
		--embed-metadata \
		--output "$output_dir/%(title)s [%(id)s].%(ext)s" \
		--restrict-filenames \
		--no-overwrites \
		--continue \
		--ignore-errors \
		"$url"

	local exit_code=$?

	if [[ $exit_code -eq 0 ]]; then
		echo ""
		echo "✅ Download completed successfully!"
		echo "📁 Video saved to: $output_dir"
		echo ""

		# Show downloaded files with sizes
		echo "📊 Downloaded files:"
		local video_id
		video_id=$(yt-dlp --print id "$url" 2>/dev/null)
		if [[ -n "$video_id" ]]; then
			find "$output_dir" -name "*${video_id}*" -type f -newer /tmp 2>/dev/null | while read -r file; do
				if [[ -f "$file" ]]; then
					local size
					size=$(du -h "$file" 2>/dev/null | cut -f1)
					echo "   📄 $(basename "$file") - $size"
				fi
			done
		else
			# Fallback: show recent files in Desktop
			echo "   Check your Desktop for the downloaded video files"
		fi

		echo
		echo "🎉 Done! The video is optimized for maximum compatibility."

	else
		echo
		echo "❌ Download failed with exit code: $exit_code"
		echo "💡 Try checking the URL or your internet connection"
		return $exit_code
	fi
}

# Convert all mov video files in a directory into mp4's
movtomp4() {
	COUNTER=$(ls -1 *.mov 2>/dev/null | wc -l)
	if [ $COUNTER != 0 ]; then
		for filename in *.mov; do
			ffmpeg -i "$filename" -vcodec h264 -acodec aac -strict -2 "${filename%.mov}.mp4"
			echo "Converted: $filename to ${filename%.mkv}.mp4"
			# Now delete the mov file
			rm "$filename"
		done
	else
		echo 'No mkv files were found in this directory.'
		echo 'mkvtomp4 Usage: "cd" to the directory where the mkv video files are located and run "mkvtomp4" (then go grab a coffee).'
	fi
}
