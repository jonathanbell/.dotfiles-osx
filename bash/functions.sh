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

# Mount specific external drives as readable
mnteverything() {
  EVERYTHINGSHOME="$HOME/mnt/Everything"
  EVERYTHINGSDEFAULTHOME="/Volumes/Everything"

  # First unmount the drive, if it was already mounted.
  # `mount` would probably give us a string like this:
  # "/dev/disk2s1 on /Users/jbell/mnt/Everything"
  # So, look for that string. If it's inside of `mount`'s output, then it's
  # likely that the drive is already mounted.
  if mount | grep -q "mnt/Everything" || mount | grep -q $EVERYTHINGSDEFAULTHOME; then
    if ! sudo diskutil unmount $EVERYTHINGSHOME >/dev/null && ! sudo diskutil unmount $EVERYTHINGSDEFAULTHOME >/dev/null; then
        echo 'Unable to unmount Everything! Maybe try force unmounting.' \
        && return
    else
      echo 'Everything was already mounted, re-mounting...'
    fi
  fi

  AVAILABLEDISK=$(getavailabledisk)

  mkdir -p $EVERYTHINGSHOME \
  && chmod -R 775 $EVERYTHINGSHOME \
  && sudo mount -wt exfat $AVAILABLEDISK $EVERYTHINGSHOME \
  && echo "Everything is now mounted on ${EVERYTHINGSHOME}" \
  && open $EVERYTHINGSHOME;
}

mntpatrice() {
  PATRICEHOME="$HOME/mnt/Patrice"
  PATRICEDEFAULTHOME="/Volumes/Patrice"

  if mount | grep -q $PATRICEHOME || mount | grep -q $PATRICEDEFAULTHOME; then
    if ! sudo diskutil unmount $PATRICEHOME >/dev/null && ! sudo diskutil unmount $PATRICEDEFAULTHOME >/dev/null; then
        echo 'Unable to unmount Patrice! Maybe try force unmounting.' \
        && return
    else
      echo 'Patrice was already mounted, re-mounting...'
    fi
  fi

  AVAILABLEDISK=$(getavailabledisk)

  mkdir -p $PATRICEHOME \
  && chmod -R 775 $PATRICEHOME \
  && sudo mount -wt exfat $AVAILABLEDISK $PATRICEHOME \
  && echo "Patrice is now mounted on ${PATRICEHOME}" \
  && open $PATRICEHOME;
}

mntbuckups() {
  BUCKUPSHOME="$HOME/mnt/Buckups"
  BUCKUPSDEFAULTHOME="/Volumes/BUCKUPS"

  if mount | grep -q $BUCKUPSHOME || mount | grep -q $BUCKUPSDEFAULTHOME; then
    if ! sudo diskutil unmount $BUCKUPSHOME >/dev/null && ! sudo diskutil unmount $BUCKUPSDEFAULTHOME >/dev/null; then
        echo 'Unable to unmount Buckups drive! Maybe try force unmounting.' \
        && return
    else
      echo 'Buckups drive was already mounted, re-mounting...'
    fi
  fi

  AVAILABLEDISK=$(getavailabledisk)

  mkdir -p $BUCKUPSHOME \
  && chmod -R 775 $BUCKUPSHOME \
  && sudo mount -wt msdos $AVAILABLEDISK $BUCKUPSHOME \
  && echo "Buckups drive is now mounted on ${BUCKUPSHOME}" \
  && open $BUCKUPSHOME;
}

mntbub() {
  BUBSHOME="$HOME/mnt/Bub"
  BUBSDEFAULTHOME="/Volumes/BUB"

  if mount | grep -q $BUBSHOME || mount | grep -q $BUBSDEFAULTHOME; then
    if ! sudo diskutil unmount $BUBSHOME >/dev/null && ! sudo diskutil unmount $BUBSDEFAULTHOME >/dev/null; then
        echo 'Unable to unmount Bub drive! Maybe try force unmounting.' \
        && return
    else
      echo 'Bub drive was already mounted, re-mounting...'
    fi
  fi

  AVAILABLEDISK=$(getavailabledisk)

  mkdir -p $BUBSHOME \
  && chmod -R 775 $BUBSHOME \
  && sudo mount -wt msdos $AVAILABLEDISK $BUBSHOME \
  && echo "Bub drive is now mounted on ${BUBSHOME}" \
  && open $BUBSHOME;
}

mntdrive() {
  DRIVEMOUNTLOCATION=''
  PS3='Select a drive to mount: '
  options=("Buckups" "Everything" "Patrice" "Bub" "Other" "Quit")
  select opt in "${options[@]}"
  do
    case $opt in
        "Buckups")
            echo "you chose choice 1"
            break
            ;;
        "Everything")
            echo "you chose choice 2"
            break
            ;;
        "Patrice")
            echo "you chose choice $REPLY which is $opt"
            break
            ;;
        "Bub")
            echo "you chose choice $REPLY which is $opt"
            break
            ;;
        "Other")
            echo "you chose choice $REPLY which is $opt"
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
  done
  echo "all done!"
}

backupeverything() {

  DRYRUN=""

  if [[ $1 = "--dry-run" ]]; then
    DRYRUN="n"
  fi

  EVERYTHINGSHOME="$HOME/mnt/Everything"
  PATRICEHOME="$HOME/mnt/Patrice"

  if ! mount | grep -q $EVERYTHINGSHOME || ! mount | grep -q $PATRICEHOME; then
    echo 'Everything drive and Patrice drive have to be mounted first. Exiting...' \
    && return
  fi

  rsync -rv$DRYRUN --delete --delete-excluded --size-only \
    --exclude=/.wd_tv \
    --exclude=/.fseventsd \
    --exclude=/.Spotlight-V100 \
    --exclude=/.TemporaryItems \
    --exclude=/.Trashes \
    --exclude=._* \
    --exclude=.*.parts \
    --exclude=.DS_Store \
    --exclude=.BridgeSort \
    --exclude=.BridgeLabelsAndRatings \
  $EVERYTHINGSHOME/ $PATRICEHOME/Everything\ Backup

  mkdir -p $PATRICEHOME/Everything\ Backup/Video/_Davinci\ Backup
  rsync -rv$DRYRUN --delete --delete-excluded --size-only \
    --exclude=.DS_Store \
  $HOME/Movies/Projects/ $PATRICEHOME/Everything\ Backup/Video/_Davinci\ Backup/
}

# View log for specific Git branch
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

# Get a known wifi password
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

# Prep high-res images for upload to log.jonathanbell.ca or other blog-like things.
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

# Upload that file to https://s3-us-west-2.amazonaws.com/static-jonathanbell-ca/<filename>
# Requires awscli be setup and configured.
static() {
  if [ $# -eq 0 ]; then
    echo 'Oops. Please give me a filename.'
    echo 'Usage: static <filename>'
  else
    aws s3 cp $1 s3://static-jonathanbell-ca --acl public-read --cache-control max-age=7776000
    printf "https://s3-us-west-2.amazonaws.com/static-jonathanbell-ca/$1" > /dev/clipboard
    echo "File available at: https://s3-us-west-2.amazonaws.com/static-jonathanbell-ca/$1 (copied to clipboard)"
    open https://s3-us-west-2.amazonaws.com/static-jonathanbell-ca/$1
  fi
}

# Start a LAMP stack with Docker
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
