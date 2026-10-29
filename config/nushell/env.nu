# Nushell Environment Config File
#
# version = "0.99.1"

def create_left_prompt [] {
    let dir = match (do { $env.PWD | path relative-to $nu.home-dir }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

export def get-secret [
  ref: string, # the reference to the secret in 1Password
  cache_file: string # the name of the cache file to store the secret
] {
  let cache_path = ($env.XDG_CACHE_HOME | path join $cache_file)
  if ($cache_path | path exists) {
    open $cache_path | str trim
  } else {
    let value = (/opt/homebrew/bin/op read $ref | str trim)
    $value | save --force $cache_path
    $value
  }
}

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

$env.LS_COLORS = 'di=01;34:ln=36:ex=32:*.zip=31:*.tar=31:*.gz=31'

$env.config.buffer_editor = 'nvim'
$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'

$env.LDFLAGS = '-L/opt/homebrew/lib/pkgconfig'
$env.CPPFLAGS = '-I/opt/homebrew/include'
$env.PKG_CONFIG_PATH = '/opt/homebrew/lib/pkgconfig'

$env.PNPM_HOME = $env.HOME + '/.local/share/pnpm'

$env.XDG_DATA_HOME = $env.HOME + '/.local/share'
$env.XDG_CONFIG_HOME = $env.HOME + '/.config'
$env.XDG_STATE_HOME = $env.HOME + '/.local/state'
$env.XDG_CACHE_HOME = $env.HOME + '/.cache'
$env.XDG_RUNTIME_DIR = '/tmp/runtime-' + $env.USER

$env.GOPATH = $env.HOME + '/go'
$env.CARGO_HOME = $env.XDG_DATA_HOME + '/cargo'
$env.GHCUP_USE_XDG_DIRS = true
$env.GOPATH = $env.XDG_DATA_HOME + '/go'
$env.GNUPGHOME = $env.XDG_DATA_HOME + '/gnupg'
$env.GPG_TTY = ^tty
$env.ANDROID_HOME = $env.HOME + '/Library/Android/sdk'

$env.NIX_CONF_DIR = $env.HOME + '/.config/nix'
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional

$env.DOTNET_ROOT = $env.HOME + '/.dotnet'

# LLM API keys
$env.GEMINI_API_KEY = (get-secret "op://Development/Gemini API key/password" "gemini_api_key.cache")

use std 'path add'

path add $env.PNPM_HOME

path add ($env.HOME | path join 'go' 'bin')
path add ($env.HOME | path join '.local' 'share' 'go' 'bin')

path add ($env.HOME | path join '.local' 'bin')

path add ($env.HOME | path join '.orbstack' 'bin')

path add '/cmd'

path add '/run/current-system/sw/bin'

path add '/opt/homebrew/bin'
path add '/opt/homebrew/sbin'
path add '/opt/homebrew/bin/flutter'
path add '/opt/homebrew/opt/ruby/bin'
path add '/opt/homebrew/opt/openjdk/bin'

path add '/nix/var/nix/profiles/default/bin'

path add '~/projects/third-party/flutter/bin'
# home-manager's home.packages (includes the Android SDK tools)
path add $'/etc/profiles/per-user/($env.USER)/bin'

path add ($env.HOME | path join '.bun' 'bin')
path add ($env.HOME | path join '.cache' '.bun' 'bin')

path add ($env.HOME | path join 'bin')

path add ($env.HOME | path join '.local' 'share' 'gem' 'ruby' '3.0.0' 'bin')

path add ($env.HOME | path join 'Applications' 'depot_tools')

path add ($env.HOME | path join '.npm' 'bin')

path add ($env.CARGO_HOME | path join 'bin')

path add '~/.dotnet/tools'
path add $env.DOTNET_ROOT

path add ~/Library/Python/3.9/bin

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
