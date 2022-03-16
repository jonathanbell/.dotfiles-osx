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
  while [ $i -lt 99 ] ; do
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
    echo 'Everything drive or Patrice drive must be mounted before backing up. Exiting...' \
    && return
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
    --exclude=**/node_modules \
    --exclude=/.Spotlight-V100 \
    --exclude=/.TemporaryItems \
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
    echo 'Buckups drive not mounted. Exiting...' \
    && return
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
  $LOCALPHOTOS/ $BUCKUPSDRIVE/Photos/

  echo
  echo "Done backing up photos to BUCKUPS drive ✅"
  echo
}

# View log for specific Git branch.
gitbranchlog() {
  git log --graph --abbrev-commit --decorate  --first-parent $(git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /')
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

# Get a known wifi password.
wifi-password() {
  if [ $# -eq 0 ]; then
    echo 'Oops. Please tell me a wifi network name.'
    echo 'Usage: wifi-password <wifi network name>'
  else
    security find-generic-password -ga $1 | grep password:
  fi
}

# Downloads mp3 audio file from YouTube video.
yt-getaudio() {
  if [ $# -eq 0 ]; then
    echo 'Oops. Pass me a url.'
    echo 'Usage: yt-getaudio <youtube-link>'
  else
    echo 'Starting YouTube download. Hit Enter if prompted after metadata is added.'
    # --audio-quality [0-9]; 0 is best, 9 is worst.
    youtube-dl --extract-audio --audio-format mp3 --audio-quality 1 --embed-thumbnail --add-metadata $1
  fi
}

# Just a quick function to reduce an image's size in order to upload it faster or whatever.
shrink-image() {
  if [ $# -eq 0 ]; then
    echo 'Oops. Please give me a filename.'
    echo 'Usage: shrink-image <filename>'
  else
    magick $1 -resize 50% $1
  fi
}

# Quickly resize an image to a given width.
resize-image-width() {
  if [ $# -ne 2 ]; then
    echo 'Oops. Please give me a filename and desired width.'
    echo 'Usage: resize-image-width <filename> <width in pixels>'
  else
    magick $1 -resize $2 $1
  fi
}

# Prep high-res images for upload to blog-like things.
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

# Trim video to time parameters.
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

# Turn that video into webm format and make a poster image for it!
webmify() {
  if [ $# -eq 0 ]; then
    echo 'Oops. Please tell me the filename.'
    echo 'Usage: webmify <filename>'
  else
    ffmpeg -i "$1" -vcodec libvpx -acodec libvorbis -isync -copyts -aq 80 -threads 3 -qmax 30 -y "$1.webm"
    ffmpeg -ss 00:00:15 -i "$1.webm" -vframes 1 -q:v 2 "$1.jpg"
    open $1.webm
  fi
}

# Convert all mkv video files in a directory into mp4's.
mkvtomp4() {
  COUNTER=`ls -1 *.mkv 2>/dev/null | wc -l`
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
  COUNTER=`ls -1 *.mov 2>/dev/null | wc -l`
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

# Make an animated gif from any video file.
# http://gist.github.com/SlexAxton/4989674
# https://eternallybored.org/misc/gifsicle/
# Requires gifsicle.
gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--better' ]]; then
      # gifsicle --optimize=2; Can be 1, 2, or 3. 3 is most aggressive.
      ffmpeg -i "$1" -pix_fmt rgb24 -r 24 -f gif -vf scale=500:-1 - | gifsicle --optimize=2 > "$1.gif"
    elif [[ $2 == '--best' ]]; then
      ffmpeg -i "$1" -pix_fmt rgb24 -f gif -vf scale=700:-1 - | gifsicle > "$1.gif"
    elif [[ $2 == '--tumblr' ]]; then
      ffmpeg -i "$1" -pix_fmt rgb24 -f gif -vf scale=400:-1 - | gifsicle -i --optimize=3 > "$1.gif"
    else
      ffmpeg -i "$1" -pix_fmt rgb24 -r 10 -f gif -vf scale=400:-1 - | gifsicle --optimize=3 --delay=7 > "$1.gif"
    fi
    open $1.gif
  else
    echo 'Ops. Please enter a filename.'
    echo 'Usage: gifify <input_movie.mov> [ --better | --best | --tumblr ]'
  fi
}

# Add a hashtag based on category.
addhashtag() {
  if [ $# -ne 2 ]; then
    echo 'Oops. Please provide a category and value.'
    echo 'Usage: addhashtag <category> <hashtag>'
  else
    touch $HOME/bin/hashtags/data/hashtags/$1.txt
    echo "$2" >> "$HOME/bin/hashtags/data/hashtags/$1.txt"
    echo 'Added.'
  fi
}

# Start a LAMP stack with Docker.
# A helper function to launch docker container using mattrayner/lamp with overrideable parameters
# https://hub.docker.com/r/mattrayner/lamp#introduction
#
# $1 - Apache Port (optional)
# $2 - MySQL Port (optional - no value will cause MySQL not to be mapped)
function launchlamp {
  APACHE_PORT=80
  MYSQL_PORT_COMMAND=""

  if ! [[ -z "$1" ]]; then
    APACHE_PORT=$1
  fi

  if ! [[ -z "$2" ]]; then
    MYSQL_PORT_COMMAND="-p \"$2:3306\""
  fi

  mkdir -p ./lamp
  cd ./lamp

  docker run -i -t -p "$APACHE_PORT:80" $MYSQL_PORT_COMMAND -v ${PWD}/app:/app -v ${PWD}/mysql:/var/lib/mysql mattrayner/lamp:latest-1804

  SET_MYSQL_PORT="3306"

  if ! [[ -z "$2" ]]; then
    SET_MYSQL_PORT="$2"
  fi

  cd -

  echo "LAMP stack running at http://localhost:$1"
  echo "Access guest MySQL on port $SET_MYSQL_PORT (user: 'root' | password: '')"
  echo "Place your PHP code inside 'lamp/app'"
}
