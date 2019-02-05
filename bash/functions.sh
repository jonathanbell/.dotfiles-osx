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
    open chrome trimmed_$1
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
    open chrome $1.webm
  fi
}

# Convert all mkv video files in a directory into mp4's.
mkvtomp4() {
  COUNTER=`ls -1 *.mkv 2>/dev/null | wc -l`
  if [ $COUNTER != 0 ]; then
    for filename in *.mkv; do
      ffmpeg -i "$filename" -c:v libx264 -c:a libvo_aacenc -b:a 128k "${filename%.mkv}.mp4"
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
    open chrome $1.gif
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
    open chrome https://s3-us-west-2.amazonaws.com/static-jonathanbell-ca/$1
  fi
}
