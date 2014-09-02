# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f /etc/bashrc ]; then
  . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

# Define alias
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias hq='hg qseries -v -s'
alias hpush='hg push -f -rtip ssh://cku@mozilla.com@hg.mozilla.org/try'

export CLICOLOR=YES

# Add PATHs...
# http://unix.stackexchange.com/a/4973
add_path () {
  for d; do
    case ":$PATH:" in
      *":$d:"*) :;;
      *) PATH=$d:$PATH;;
    esac
  done
}

add_path ~/adt-bundle/sdk/platform-tools
add_path ~/adt-bundle/sdk/tools
add_path /usr/local/bin
add_path ~/repository/moz-git-tools
add_path ~/repository/Utility

# Print the value of $PATH
function print_path () {
  echo $PATH | tr ':' '\n' | awk '{print "["NR"]"$0}'
}

# Color definition
OFF="\[\e[0m\]"
BOLD="\[\e[1m\]"
BLACK="\[\e[30m\]"
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
WHITE="\[\e[37m\]"

# Add git branch information into prompt
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git\/\1)/'
}

# Add hg queue information into prompt
function parse_hg_queue {
  # Display the name of active queue
  hg qqueue --active 2> /dev/null | sed -e 's/\(.*\)/(hg\/\1/' | awk 'BEGIN { ORS=""; } { print $1; }'

  # Display the number of applied and unapplied patches.
  hg qseries -v 2> /dev/null | awk  \
  '
    BEGIN {
      A = 0;  # A = applied patches
      U = 0;  # U = unapplied patches
      ORS=""; # Change ORS to "" to prevent newline in PS1
    }

    $2 ~ /A/ { A++; } # 1 A patch_name
    $2 ~ /U/ { U++; } # 0 U patch_name

    END {
      if (A != 0 || U != 0)
        print "/a-" A "/u-" U ")"
    }
  '
}

source ~/.git-prompt.sh  
export GIT_PS1_SHOWUPSTREAM="verbose name"
export PS1="\u@${GREEN}\w${BLUE}\$(__git_ps1 \" (git/%s)\")\$(parse_hg_queue)"
PS1+="${OFF}\$ "

# brew
if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
fi

# Toggle hidden files shown/hidden on Mac OS X
if [ "$(uname)" == "Darwin" ]; then
  function toggle_hidden()
  {
    if [ "$(defaults read com.apple.finder AppleShowAllFiles)" == "TRUE" ]; then
      echo "Hidden files have been hidden."
      defaults write com.apple.finder AppleShowAllFiles FALSE
    else
      echo "Hidden files have been shown."
      defaults write com.apple.finder AppleShowAllFiles TRUE
    fi
    killall Finder
  }
fi


function active_marrionete_env() {
  source ~/mariotnette_env/bin/activate
  adb forward tcp:2828 tcp:2828
}

function run_touch_testcase() {
  adb forward tcp:2828 tcp:2828
  python testing/marionette/client/marionette/runtests.py --address=localhost:2828 layout/base/tests/marionette/test_touchcaret.py
}

function reset_b2g() {
  adb shell stop b2g
  adb shell start b2g
  adb forward tcp:2828 tcp:2828
}

GAIA_PATH="~/repository/gaia"

function reset_gaia() {
  cd $GAIA_PATH
  DEVICE_DEBUG=1 NOFTU=1 make reset-gaia
}

function reset_gaia_app() {
  if [ -z $1]; then
    echo 'reset_gaia_app app name undefined.'
  fi

  cd $GAIA_PATH
  DEVICE_DEBUG=1 NOFTU=1 make install-gaia APP="$1"
}
