# remove background from an image
def rmbg [
  file: path # image file
] {
  if ((not ($file | path exists)) or ($file | path type) != "file") {
    return "please provide a valid image file" | echo
  }

  removebg --api-key (op read "op://Development/remove.bg/credential") $file
}

# change the current working directory to the one specified in the yazi config
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# uncompress any compressed file without any hazzle
def ex [
  file: path # the compressed file
] {
  if ((not ($file | path exists)) or ($file | path type) != "file") {
    return "please provide a valid compressed file to extract" | echo
  }

  let name = ($file | path basename)

  match $name {
  $n if ($n | str ends-with [".tar.bz2" ".tbz2" ".tbz" ".tb2"]) => {
    run-external "tar" "-xjf" $file
  }
  $n if ($n | str ends-with [".tar.gz" ".tgz"]) => {
    run-external "tar" "-xzf" $file
  }
  $n if ($n | str ends-with [".tar.xz" ".tar"]) => {
    run-external "tar" "-xf" $file
  }
  $n if ($n | str ends-with ".zip") => { run-external "unzip" $file }
  $n if ($n | str ends-with ".rar") => { run-external "unrar" $file }
  $n if ($n | str ends-with ".7z")  => { run-external "7z" "x" $file }
  $n if ($n | str ends-with ".xz")  => { run-external "unxz" $file }
  $n if ($n | str ends-with ".bz2") => { run-external "bunzip2" $file }
  $n if ($n | str ends-with ".gz")  => { run-external "gunzip" $file }
  _ => {
    return "unsupported file format" | echo
  }
 }
}

# download the audio from a youtube video
def music [
  link: string # the link of the youtube video
] {
  youtube-dl -x -f bestaudio --no-playlist --external-downloader aria2c --external-downloader-args '-c -j 3 -x 3 -s 3 -k 1M' $link
}


# convert m4a file to mp3 format
#
# if a file is provided explicitly, it will convert that file to mp3 format.
# if no file is provided, it will convert all m4a files in the current directory to mp3 format.
def convert.m4a.mp3 [
  file?: path # provide the file name if you want to convert a specific file
] {
  if ($file != null) {
    if (not ($file | path exists)) or ($file | path type) != "file" {
      return $"($file) is not a valid file" | echo
    }

    if not ($file | path basename | str ends-with ".m4a") {
      return $"($file) is not an m4a file" | echo
    }

    let input = ($file | path basename)
    echo $"Converting ($input)"
    let output = ($input | str replace '.m4a' '.mp3')
    run-external "ffmpeg" "-i" $input "-acodec" "libmp3lame" "-ab" "128k" $output
    rm $input
    return
  }

  # If no file provided, convert all m4a files in current directory
  let m4a_files = (ls *.m4a)
  if ($m4a_files | is-empty) {
    echo "No m4a files found in current directory"
    return
  }

  $m4a_files | each { |file|
    let input = $file.name
    echo $"Converting ($input)"
    let output = ($input | str replace '.m4a' '.mp3')
    run-external "ffmpeg" "-i" $input "-acodec" "libmp3lame" "-ab" "128k" $output
    rm $input
  }
}

# convert mkv file to mp4 format
#
# if a file is provided explicitly, it will convert that file to mp4 format
# if no file is provided, it will convert all mkv files in the current directory to mp4 format
def convert.mkv.mp4 [
  file?: path # provide the file name if you want to convert a specific file
] {
    if ($file != null) {
        if (not ($file | path exists)) or ($file | path type) != "file" {
            return $"($file) is not a valid file" | echo
        }

        if not ($file | path basename | str ends-with ".mkv") {
            return $"($file) is not an mkv file" | echo
        }

        let input = ($file | path basename)
        echo $"Converting ($input)"
        let output = ($input | str replace '.mkv' '.mp4')
        run-external "ffmpeg" "-i" $file "-c:v" "libx264" "-c:a" "aac" "-strict" "experimental" $output
        rm $file
        return
    }

    # If no file provided, convert all mkv files in current directory
    let mkv_files = (ls *.mkv)
    if ($mkv_files | is-empty) {
        echo "No mkv files found in current directory"
        return
    }

    $mkv_files | each { |file|
        let input = $file.name
        echo $"Converting ($input)"
        let output = ($input | str replace '.mkv' '.mp4')
        run-external "ffmpeg" "-i" $file "-c:v" "libx264" "-c:a" "aac" "-strict" "experimental" $output
        rm $file
    }
}

# convert a svg file to industry accpeted favicon sizes
def favicon [
  input: path, # input svg file
  output: string # output file name
] {
  if (not ($input | path exists)) or ($input | path type) != "file" {
    return $"($input) is not a valid file" | echo
  }

  run-external "convert" "-background" "transparent" "-define" "icon:auto-resize=192" $input $output
}

# preview the markdown file that you are editing right in your terminal
def markdown.preview [
  file: path # the markdown file
] {
  if (not ($file | path exists)) or ($file | path type) != "file" {
    return $"($file) is not a valid file" | echo
  }

  run-external "pandoc" $file | run-external "lynx" "-stdin"
}

# generate a dependecy graph for a go project using godepgraph
def godep [
  src_dir: path # the source directory of the go project
] {
  if (not ($src_dir | path exists)) {
    return "directory does not exist"
  }

  run-external "godepgraph" "-s" $src_dir | run-external "dot" "-Tpng" "-o" "godepgraph.png"
}

# view the ipfs content in the browser
def ipfs.view [
  cid: string # the content id of the ipfs
] {
  open $"https://cloudflare-ipfs.com/ipfs/($cid)"
}

# list the latest n files in the current directory
def latest [
  n: int = 10 # number of files to list
] {
  if ($n <= 0) {
    return "please provide a valid number of files to list" | echo
  }

  ls | sort-by modified --reverse | first ($n)
}

# encrypt a file using gpg
def encrypt [
  file: path # the file to encrypt
] {
  if (not ($file | path exists)) or ($file | path type) != "file" {
    return $"($file) is not a valid file" | echo
  }

  let email = (op read "op://Development/kgm55waeojbqzr3yzl3iuh56ci/Identification/email")
  let output = $"($file).gpg"
  run-external "gpg" "--encrypt" "--output" $output "--recipient" $email $file
}

# decrypt a file using gpg
def decrypt [
  file: path # the file to decrypt
] {
  if (not ($file | path exists)) or ($file | path type) != "file" or (not ($file | str ends-with ".gpg"))  {
    return "please provide a valid encrypted file" | echo
  }

  let output = ($file | str replace ".gpg" "")
  run-external "gpg" "--decrypt" "--output" $output $file
}

# copypath: copy the current directory path to clipboard
def copypath [] {
  pwd | tr -d '\n' | pbcopy
}

# get the droplet id from the name
def doctl.getid [name: string] {
  doctl compute droplet get $name --format ID | sed 's/[^0-9]//g' | tr -d '\n'
}

# get the IP address of the dropplet from the droplet name
def doctl.getip [
  name: string # the name of the droplet
] {
  doctl compute droplet get (doctl.getid $name) --format PublicIPv4 | sed -n 2p | sed 's/[^0-9.]*//g' | tr -d '\n'
}

# create a new tmux session with the given configurations
def session [
  name: string # the name of the session
] {
  let editor = ($name | append ":editor" | str join )

  tmux new-session -d -s $name -n editor nvim

  tmux new-window -t $name -n terminal
  tmux new-window -t $name -n server
  tmux new-window -t $name -n database

  tmux select-window -t $editor
  tmux attach-session -t $name
}

# create a new zellij session with the given configurations
def zs [
  name: string # the name of the session
] {
  zellij --layout ~/.config/zellij/layouts/session/session.kdl -s $name
}

# create a new arduino project
def arduino.new [
  name: string # the name of the arduino project
] {
  mkdir $name
  cd $name
  touch main.cpp
  echo "-I/Users/vinukakodituwakku/Library/Arduino15/packages/esp32/hardware/esp32/3.0.3/cores/esp32" > compile_flags.txt
  touch ($name | append ".ino" | str join )
}


def random.string [] {
  let vinuka = (xxd -l32 -ps /dev/urandom | xxd -r -ps | base64 | tr -d '=' | tr + - | tr / _)
  echo $vinuka | pbcopy
  print $vinuka
}

# upload a file to a presigned URL
def upload_to_presigned [
  file: path, # the file to upload
  url: string # the presigned URL to upload to
] {
  if (not ($file | path exists)) or ($file | path type) != "file" {
    return $"($file) is not a valid file" | echo
  }

  curl -X PUT -T $file $url --header "Content-Type: application/octet-stream" --silent --show-error --fail
}

def create_session [
  name: string, # the name of the session
  advanced: bool = false # whether to create an advanced session with database, redis connections
] {
  tmux new-session -d -s $name -n editor nvim
  tmux new-window -t $name -n terminal
  tmux new-window -t $name -n server

  if $advanced {
    tmux new-window -t $name -n database
    tmux new-window -t $name -n redis
  }

  tmux select-window -t $"($name):editor"
  tmux attach-session -t $name
}

def --env add_op_srv [] {
  $env.OP_SERVICE_ACCOUNT_TOKEN = (op read "op://Development/tgx56upbpeiegx7f75xitqyl3m/credential")
}

# Backdates the last git commit to a specified date.
def backdate_commit [
  date: string, # The date to set the commit to (e.g., "Jan 02 15:04:05 2006")
] {
  if $date == "" {
    error make { msg: "Please provide a valid date string." }
    return
  }

  let modified_date = $"($date) +0530"

  with-env { GIT_COMMITTER_DATE: $modified_date } {
    ^git commit --amend --no-edit --date $modified_date
  }
}

def video_resolution [
  file: path # video file
] {
  if ((not ($file | path exists)) or ($file | path type) != "file") {
    "please provide a valid video file"
  } else {
    ^ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 $file
  }
}

def notify [
  message: string # the message to display in the notification
] {
  let secret = (op read "op://Development/3ehhu3n4cwknvnbyjgfxynji5m/password")
  curl -s -o /dev/null -d ($message) $"ntfy.sh/($secret)"
}

# run Claude Code through the local CLIProxyAPI (127.0.0.1:8317); args pass through to claude.
# No auth token is set, so the claude.ai login (and its connectors) stays active; the proxy
# ignores that login's bearer only while access.api-keys is empty in the cliproxyapi config.
# Tool search is off for non-Anthropic base URLs, which would inline every MCP tool schema.
def --wrapped claude-proxy [...args] {
  with-env { ANTHROPIC_BASE_URL: "http://127.0.0.1:8317", ENABLE_TOOL_SEARCH: "true" } {
    ^claude ...$args
  }
}
