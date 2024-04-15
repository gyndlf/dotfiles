autoload -U zmv

# Path to your oh-my-zsh installation.
export ZSH=$HOME"/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dieter"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"


# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi



ZSH_DISABLE_COMPFIX=true
# As according to https://github.com/ohmyzsh/ohmyzsh/issues/6835

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Custom java command to change java version. Use as `jhome -v 1.8` etc. https://stackoverflow.com/questions/21964709/how-to-set-or-change-the-default-java-jdk-version-on-macos
jhome () {
  export JAVA_HOME=`/usr/libexec/java_home $@`
  echo "JAVA_HOME:" $JAVA_HOME
  echo "java -version:"
  java -version
}


# Get FZF to use ripgrep (fzf use rg)
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m'
fi

# Mock if you make a mistake
function command_not_found_handler() { echo "lol, $1 doesn't exist" }

# So that we can run binaries installed as sudo
export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:/Users/james/.local/bin	# So that we can run lunarvim


# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/james/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<


# Simplify arduino cli stuff
alias  arduino=arduino-cli

fif() {
    ##
    # Interactive search.
    # Usage: `fif` or `fif <folder>`.
    #
    [[ -n $1 ]] && cd $1 # go to provided folder or noop
    RG_DEFAULT_COMMAND="rg -i -l --hidden --no-ignore-vcs"

    selected=$(
    FZF_DEFAULT_COMMAND="rg --files" fzf \
      -m \
      -e \
      --ansi \
      --disabled \
      --reverse \
      --bind "ctrl-a:select-all" \
      --bind "f12:execute-silent:(subl -b {})" \
      --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
      --preview "rg -i --pretty --context 2 {q} {}" | cut -d":" -f1,2
    )

    [[ -n $selected ]] && nvim $selected # open multiple files in editor
}



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/james/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/james/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/james/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/james/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(zoxide init zsh)"
alias cd=z
