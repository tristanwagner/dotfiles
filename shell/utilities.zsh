## awk advanced search example
# awk -v RS="\n\n" '/L337/ {if ($0 ~ /Blue/ && $0 ~ /Honda/) print $0}' mystery/vehicles
# it means : search in mystery/vehicles for L337, take the whole paragraph (RS="\n\n")
# and then take only paragraphs that contains Blue and Honda, and print the results

function cd() {
  builtin cd "$@" || return
  if [[ -f ".envrc" ]]; then
    source .envrc
  fi
}

function serve() {
  local port="${1:-8000}"
  python3 -m http.server "$port"
  echo "Serving at http://localhost:$port"
}

function validateYaml() {
  python -c 'import yaml,sys;yaml.safe_load(sys.stdin)' < $1
}

function vgst () {
  vim $(git status --porcelain | awk '{print $2}')
}

function opc() {
  vim `git diff --name-only --diff-filter=U  | uniq`
}

function gitopen() {
  COMMAND=diff
  REV=HEAD
  PATTERN=""

  if [ "$#" -gt 3 ]; then
    echo "Usage: gitopen [command] [revision] [pattern]"
    echo "gitopen -- opens all added files that have changed since HEAD"
    echo "gitopen diff HEAD -- these are the default parameters"
    echo "gitopen diff master -- opens files that have changed from master"
    echo "gitopen show -- opens files that were changed in the last revision (HEAD)"
    echo "gitopen show HEAD -- default param, does the same"
    echo "gitopen show 4b3ca34 -- opens a particular REV"
    echo 'gitopen <command> <rev> ".txt" - use grep to filter filename results'
    return 1
  fi

  if [ "$#" -gt 0 ]; then
    COMMAND=$1
    shift
  fi

  if [ "$#" -gt 0 ]; then
    REV=$1
    shift
  fi

  if [ "$#" -gt 0 ]; then
    PATTERN=$1
    shift
  fi

  if [ "$COMMAND" = "show" ]; then
    PARAMS=(--pretty=format: --name-only --relative)
  else
    PARAMS=(--name-only --relative)
  fi

  if git rev-parse --verify "$REV" >/dev/null 2>&1; then
    CMD=("git" "$COMMAND" "$REV" "${PARAMS[@]}")
    if [ -n "$PATTERN" ]; then
      echo "Running: ${CMD[*]} | grep "$PATTERN" | xargs -o $EDITOR"$'\n'
      "${CMD[@]}" | grep "$PATTERN" | xargs -o $EDITOR
    else
      echo "Running: ${CMD[*]} | xargs -o $EDITOR"$'\n'
      "${CMD[@]}" | xargs -o $EDITOR
    fi
  else
    echo "Error: '$REV' is not a valid revision"
    return 1
  fi
}

# send hexadecimal value in binary format over udp to remote adress and port
# usage :
#  udp <hex> <host> <port>
function udp () {
  echo -n $1 | xxd -r -p | nc -u $2 $3
}

# send hexadecimal value in binary format over udp to remote adress and port
#  usage :
#  udp <hex> <host> <port>
function tcp () {
  echo -n $1 | xxd -r -p | nc $2 $3
}
# send data over tls protocol
# example
# tls 'GET / HTTP/1.1\r\nHost: test.com\r\n\r\n' test.com 443
# we can go through proxy by adding for example -proxy proxy.auchan.com:80
# not all openssl version has the proxy option
function tls () {
  printf $1 | openssl s_client -ign_eof -connect $2:$3
}

# funny conversion back and forth of a file
#  hextoascii $(xxd -p install | tr -d '\n')
function hextoascii () {
  echo -n $1 | xxd -p -r
}

function asciitohex () {
  echo -n $1 | xxd -p
}

function filter () {
  echo -n $1 | tr -d $2
}

function replace () {
  echo -n $1 | tr $2 $3
}

# retrieve cheatsheet from cheat.sh
function cheat {
  if [ $# -ne 1 ]; then
    echo "Usage: cheat <query>"
    return
  fi

  curl cheat.sh/$1
}

# Get weather
function weather {
  if [ $# -ne 1 ]; then
    echo "Usage: weather <location | zipcode | query>"
    return
  fi

  curl http://wttr.in/$1
}

function gpass() {
    if [ $# -eq 0 ]; then
      LC_ALL=C tr -dc 'A-Za-z0-9-_.$#@' < /dev/urandom | head -c 16
    elif [ $# -eq 1 ]; then
      LC_ALL=C tr -dc 'A-Za-z0-9-_.$#@' < /dev/urandom | head -c $1
    else
        echo "Usage: gpass [character number]"
    fi
}

function get_file_line() {
    if [ $# -eq 2 ]; then
        head -n $2 $1 | tail -1
    else
        echo "Usage: get_file_line <file> <line>"
    fi
}

# easy encryption
function encrypt {
  if [ $# -ne 3 ]; then
    echo "Usage: encrypt <e | d> <input-file> <output-file>"
    return
  fi

  echo $@

  if [ $1 '==' "e" ]; then
    echo "Encrypting $1..."
    openssl enc -aes-256-cbc -salt -a -in $2 -out $3 || { echo "File not found"; return 1; }
    echo "Successfully Encrypted"
  elif [ $1 '==' 'd' ]; then
      echo "Decrypting $1..."
      openssl enc -aes-256-cbc -d -a -in $2 -out $3 || { echo "File not found"; return 1; }
      echo "Successfully Decrypted"
  fi
}

# display csv files
function csv {
    if [ $# -ne 1 ]; then
    echo "Usage: csv <filename>"
    return
  fi

    less $1 | sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S
}

# Create vue components
function vcomp {
  if [ $# -ne 1 ]; then
    echo "Usage: vcomp <component-name>"
    return
  fi

  # Create basic files
  mkdir ./src/components/$1
  touch ./src/components/$1/$1.tsx
  touch ./src/components/$1/$1.stories.tsx
  touch ./src/components/$1/$1.stories.scss
  touch ./src/components/$1/$1.types.ts
  touch ./src/components/$1/$1.module.scss;

  echo "export interface $1Props {
};" > ./src/components/$1/$1.types.ts

  echo "import { Meta, StoryFn } from '@storybook/vue3';
import $1 from './$1';
import './$1.stories.scss';

export default {
    title: '$1',
    component: $1,
    argTypes: {
    },
} as Meta;

const Template: StoryFn = (args) => <$1 {...args} />;

export const Default = Template.bind({});

Default.args = {
};" > ./src/components/$1/$1.stories.tsx

  echo "import { defineComponent } from 'vue';
import CSS from './$1.module.scss';
import { $1Props } from './$1.types';

const $1 = defineComponent<$1Props>({
    name: 'v-$(echo $1 | awk '{print tolower($0)}')',
    props: [
        /* eslint-disable @typescript-eslint/no-explicit-any */
    ] as any,
    setup({
        ...props
      },
      { attrs, slots, expose }
    ) {
      return () => (
         <>
         </>
      );
    },
});

export default $1;" > ./src/components/$1/$1.tsx
}

# Create vue functional components
function vfcomp {
  if [ $# -ne 1 ]; then
    echo "Usage: vfcomp <component-name>"
    return
  fi

  # Create basic files
  mkdir ./src/components/$1
  touch ./src/components/$1/$1.tsx
  touch ./src/components/$1/$1.stories.tsx
  touch ./src/components/$1/$1.stories.scss
  touch ./src/components/$1/$1.types.ts
  touch ./src/components/$1/$1.module.scss;

  echo "export interface $1Props {
};" > ./src/components/$1/$1.types.ts

  echo "import { Meta, StoryFn } from '@storybook/vue3';
import $1 from './$1';
import './$1.stories.scss';

export default {
    title: '$1',
    component: $1,
    argTypes: {
    },
} as Meta;

const Template: StoryFn = (args) => <$1 {...args} />;

export const Default = Template.bind({});

Default.args = {
};" > ./src/components/$1/$1.stories.tsx

  echo "import { FunctionalComponent } from 'vue';
import CSS from './$1.module.scss';
import { $1Props } from './$1.types';

const $1: FunctionalComponent<$1Props> = ({
    ...props
}, { attrs, slots, expose }) => {
    return (
        <>
        </>
    );
};

export default $1;" > ./src/components/$1/$1.tsx
}

# Create react native components
function rn-comp {
  if [ $# -ne 1 ]; then
    echo "Usage: rn-comp <component-name>"
    return
  fi

  # Create basic files
  mkdir ./app/components/$1
  touch ./app/components/$1/index.js
  touch ./app/components/$1/$1.js
  touch ./app/components/$1/styles.js;

  # Add boilerplate
  echo "import $1 from \"./$1\";
import styles from \"./styles\";

export { $1, styles };" > ./app/components/$1/index.js;

  echo "import EStyleSheet from \"react-native-extended-stylesheet\";

export default EStyleSheet.create({});" > ./app/components/$1/styles.js

  echo "import React from \"react\";
import propTypes from \"prop-types\";
import { View, Text } from \"react-native\";

import styles from \"./styles\";

const $1 = () => (
  <View>
    <Text>$1 Component</Text>
  </View>
);

$1.propTypes = {};

export default $1;" > ./app/components/$1/$1.js
}

# Boost audio of video file by x dB, can be negative
function boost {
  if [ $# -ne 3 ]; then
    echo "Usage: boost <inputfile> <outputfile> <boostvalue>"
    return
  fi

  ffmpeg -i $1 -vcodec copy -af "volume=$3dB" $2
}

# make directory and change working directory to it
function mcd {
    if [ $# -ne 1 ]; then
      echo "Usage: mcd <directory-name>"
      return
    fi

    mkdir $1
    cd $1
}

# Always use correct program to extract files
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ./$1    ;;
          *.tar.gz)    tar xvzf ./$1    ;;
          *.tar.xz)    tar xvJf ./$1    ;;
          *.lzma)      unlzma ./$1      ;;
          *.bz2)       bunzip2 ./$1     ;;
          *.rar)       unrar x -ad ./$1 ;;
          *.gz)        gunzip ./$1      ;;
          *.tar)       tar xvf ./$1     ;;
          *.tbz2)      tar xvjf ./$1    ;;
          *.tgz)       tar xvzf ./$1    ;;
          *.zip)       unzip ./$1       ;;
          *.Z)         uncompress ./$1  ;;
          *.7z)        7z x ./$1        ;;
          *.xz)        unxz ./$1        ;;
          *.exe)       cabextract ./$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
  fi
}

# color man pages
function man {
  env LESS_TERMCAP_md=$'\033[1;34m' \
    LESS_TERMCAP_us=$'\033[0;36m' \
    LESS_TERMCAP_so=$'\033[1;31m' \
    LESS_TERMCAP_mb=$'\033[0m' \
    LESS_TERMCAP_me=$'\033[0m' \
    LESS_TERMCAP_se=$'\033[0m' \
    LESS_TERMCAP_ue=$'\033[0m' \
    man "$@"
}

# Show how much memory is used by a command
function mem() {
  if [ $1 ]
  then
    echo "$1 mem usage:\n"

    ps -eo "rss,cmd" | sed -e 's/^[ \t]*//' | cut -d ' ' -f -2 | grep "$1" | while read data
  do
    mem=$(echo $data | cut -d ' ' -f 1)
    bin=$(echo $data | cut -d ' ' -f 2)
    if [ $sum ]; then echo -n '+'; fi
    echo "$(($mem/1024)) Mio ($bin)"
    sum=$((sum+mem))
  done

  echo "\nTotal $1 mem usage: $((sum/1024)) Mio"
  unset sum
fi
}

# kills process running on specific port
# not tested on macos
# TODO: handle if no process to kill
function killp () {
  kill $(sudo lsof -t -i:$1)
}

# display process listening on port
# macos
function listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# with fzf you can do something like vim **<TAB> or cd **<TAB> to enable fzf
# CTRL-T is also available to select dir or files

# search files and open with vim
function vims() {
  vim $(fzf --preview 'bat --color=always --style=numbers {}')
}

# vf - fuzzy open with vim from anywhere
# ex: vf word1 word2 ... (even part of a file name)
# zsh autoload function
# you can also multi select results by pressing tab/shift tab in fzf
# it'll open the selected files in vim with files in buffers
function vf() {
  local files

  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf -x --read0 -0 -1 -m)"})

  if [[ -n $files ]]
  then
     vim -- $files
     print -l $files[1]
  fi
}

# fuzzy grep open via ag with line number
# you can also multi select results by pressing tab/shift tab in fzf
# it'll open the selected files in vim with files in buffers
# you need file:line plugin or it won't work
# https://www.vim.org/scripts/script.php?script_id=2184
function vg() {
  local files

  read -r -d "\n" files <<<"$(ag --nobreak --noheading $@ | fzf --preview 'bat --style=numbers --color=always' -0 -1 -m | awk -F: '{print $1 ":" $2}')"

  echo $files

  if [[ -n $files ]]
  then
    #version maison
    #vim $(replace $files '^@' ' ')
    #version sed
    vim $(echo $files | sed -e 's/\^@/ /')
  fi
}

# naviguate through commits
function gcshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# checkout commit
function gcco() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# checkout branches
function gbco() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# find history
# and run select command(s)
# you can specify a separator, for example fh ";" or fh "&&"
function fh () {
  local cmds
  cmds=$(history | fzf --tac +s +m -e -m | sed "s/[^\d]* //")
  if [ $1 ]
  then
    cmds=${cmds/$'\n'/ $1}
    echo $cmds
    eval $cmds
  else
    if [[ ! -z "$cmds" ]]
    then
      echo $cmds
      eval $cmds
    fi
  fi
}

# browse mans
function fman() {
    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | sed 's/([^()*])//' | xargs -r man
}

function stopwatch () {
  date1=`date +%s`; while true; do
   echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
  done
}

# if not linux
if [ "$(uname 2> /dev/null)" != "Linux" ]; then
    function vf() {
      local files

      files=(${(f)"$(mdfind $@ | grep -vE '~$' | fzf -0 -1 -m)"})

      if [[ -n $files ]]
      then
         vim -- $files
         print -l $files[1]
      fi
    }

    #disable ipv6 mac
    function disable-ipv6() {
      #sudo networksetup -setv6off Ethernet
      sudo networksetup -setv6off Wi-Fi
      networksetup -setv6off Wi-Fi
    }

    #enable ipv6 mac
    function enable-ipv6() {
      #sudo networksetup -setv6automatic Ethernet
      sudo networksetup -setv6automatic Wi-Fi
    }
fi

# prettify json with node
#cat file.json | node <<< "var o = $(cat); console.log(JSON.stringify(o, null, 4));"
#with python
#cat file.json | python -m json.tool

# allow fzf to show hidden files
#export FZF_DEFAULT_COMMAND="find -L"


