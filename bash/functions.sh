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

# Params: $1 {source}, $2 {destination}
link() {
  rm -f $2
  ln -s $1 $2
  echo "Symlinked $1 to $2"
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

backupeverything() {
  DRYRUN=""

  if [[ $1 = "--dry-run" ]]; then
    DRYRUN="n"
  fi

  EVERYTHINGSHOME="/Volumes/Everything"
  PATRICEHOME="/Volumes/Patrice"

  if ! mount | grep -q $EVERYTHINGSHOME && ! mount | grep -q $PATRICEHOME; then
    echo 'Everything drive or Patrice drive must be mounted before backing up. Exiting...' &&
      return
  fi

  if mount | grep -q $PATRICEHOME; then
    BACKUPDRIVE="$PATRICEHOME/Dropbox Backup"
  fi

  if mount | grep -q $EVERYTHINGSHOME; then
    BACKUPDRIVE="$EVERYTHINGSHOME/Dropbox Backup"
  fi

  mkdir -p "$BACKUPDRIVE"

  rsync -rv$DRYRUN --delete --delete-excluded --size-only \
    --exclude=/.wd_tv \
    --exclude=/.fseventsd \
    --exclude=/.dropbox \
    --exclude=/.dropbox.cache \
    --exclude=/Public/Pickup \
    --exclude=**/node_modules \
    --exclude=/.Spotlight-V100 \
    --exclude=/.TemporaryItems \
    --exclude=/Code/.ssh \
    --exclude=/.Trashes \
    --exclude=._* \
    --exclude=.*.parts \
    --exclude=./.ssh \
    --exclude=/Buckups \
    --exclude=/for\ jeep\ video \
    "$HOME/Dropbox/" "$BACKUPDRIVE/"

  echo
  echo "Done backing up everything to Everything drive ✅"
  echo
}

backupbuckups() {
  DRYRUN=""

  if [[ $1 = "--dry-run" ]]; then
    DRYRUN="n"
  fi

  BUCKUPSDRIVE="/Volumes/BUCKUPS"
  LOCALPHOTOS="$HOME/Dropbox/Photos"

  if ! mount | grep -q $BUCKUPSDRIVE; then
    echo 'Buckups drive not mounted. Exiting...' &&
      return
  fi

  rsync -rv$DRYRUN --delete --delete-excluded --size-only \
    --exclude=/.fseventsd \
    --exclude=/.wd_tv \
    --exclude=/.Spotlight-V100 \
    --exclude=/.TemporaryItems \
    --exclude=/.Trashes \
    --exclude=._* \
    --exclude=.*.parts \
    --exclude=.DS_Store \
    --exclude=.BridgeSort \
    --exclude=.BridgeLabelsAndRatings \
    --exclude=/Instagram \
    --exclude=**/calendar_ideas \
    $LOCALPHOTOS/ $BUCKUPSDRIVE/Photos/

  echo
  echo "Done backing up photos to BUCKUPS drive ✅"
  echo
}

# What is listening on a certain port?
# https://stackoverflow.com/a/30029855/1171790
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
wifi-password() {
  if [ $# -eq 0 ]; then
    echo 'Oops. Please tell me a wifi network name.'
    echo 'Usage: wifi-password <wifi network name>'
  else
    security find-generic-password -ga $1 | grep password:
  fi
}

# Just a quick function to reduce an image's size in order to upload it faster or whatever
shrink-image() {
  if [ $# -eq 0 ]; then
    echo 'Oops. Please give me a filename.'
    echo 'Usage: shrink-image <filename>'
  else
    magick $1 -resize 50% $1
  fi
}

# Quickly resize an image to a given width
resize-image-width() {
  if [ $# -ne 2 ]; then
    echo 'Oops. Please give me a filename and desired width.'
    echo 'Usage: resize-image-width <filename> <width in pixels>'
  else
    magick $1 -resize $2 $1
  fi
}

# Prep high-res images for upload to blog-like things
blogimages() {
  echo 'Converting images to lo-res...'
  for i in *.jpg; do
    printf "Resizing $i\n"
    magick $i -resize 900 $i
  done
  echo 'Done.'
}

# Prep high-res images for upload to the interweb.
webimages() {
  echo 'Converting images to medium-res...'
  for i in *.jpg; do
    printf "Resizing $i\n"
    magick $i -resize 1600 $i
  done
  echo 'Done.'
}

# Download a YouTube video to the Desktop using `yt-dlp`
download-video() {
  local url="$1"
  local output_dir="$HOME/Desktop"

  # Check if yt-dlp is installed
  if ! command -v yt-dlp &>/dev/null; then
    echo "Error: yt-dlp is not installed. Please install it first."
    echo "Install with: pip install yt-dlp"
    echo "Or visit: https://github.com/yt-dlp/yt-dlp#installation"
    return 1
  fi

  # Validate input
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

    echo ""
    echo "🎉 Ready! The video is optimized for maximum compatibility."

  else
    echo ""
    echo "❌ Download failed with exit code: $exit_code"
    echo "💡 Try checking the URL or your internet connection"
    return $exit_code
  fi
}

# Trim video to time parameters
trim-video() {
  if [ $# -ne 3 ]; then
    echo 'Ops. Please pass in the new video start time and the total duration in seconds.'
    echo 'Usage: trim-video <input_movie.mov> <time in seconds from start> <duration of new clip in seconds>'
    echo 'Example: "trim-video myvideo.mov 3 10" Produces a 10 second video begining from 3 seconds inside of the original clip.'
  else
    echo 'Begining to trim video...'
    ffmpeg -i $1 -ss $2 -c copy -t $3 trimmed_$1
    echo 'Complete. Video trimmed.'
    open trimmed_$1
  fi
}

# Convert all mkv video files in a directory into mp4
mkvtomp4() {
  COUNTER=$(ls -1 *.mkv 2>/dev/null | wc -l)
  if [ $COUNTER != 0 ]; then
    for filename in *.mkv; do
      ffmpeg -i "$filename" -c:v libx264 -b:v 2600k -c:a aac -b:a 128k "${filename%.mkv}.mp4"
      # ffmpeg -i "$filename" -c:v libx264 -c:a aac -b:a 128k "${filename%.mkv}.mp4"
      echo "Converted: $filename to ${filename%.mkv}.mp4"
      # Now delete the mkv file.
      rm "$filename"
    done
  else
    echo 'No mkv files were found in this directory.'
    echo 'mkvtomp4 Usage: "cd" to the directory where the mkv video files are located and run "mkvtomp4" (and then go grab a coffee).'
  fi
}

# Convert all mov video files in a directory into mp4's.
movtomp4() {
  COUNTER=$(ls -1 *.mov 2>/dev/null | wc -l)
  if [ $COUNTER != 0 ]; then
    for filename in *.mov; do
      ffmpeg -i "$filename" -vcodec h264 -acodec aac -strict -2 "${filename%.mov}.mp4"
      echo "Converted: $filename to ${filename%.mkv}.mp4"
      # Now delete the mov file.
      rm "$filename"
    done
  else
    echo 'No mkv files were found in this directory.'
    echo 'mkvtomp4 Usage: "cd" to the directory where the mkv video files are located and run "mkvtomp4" (then go grab a coffee).'
  fi
}
