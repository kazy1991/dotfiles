# 文字コードの設定
export LC_CTYPE=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
export JLESSCHARSET=japanese-sjis
export OUTPUT_CHARSET=utf-8
export PGDATA=/opt/brew/var/postgres

#----------------------------------------------------------
# エイリアス
#----------------------------------------------------------

alias ls='ls -hF'
alias ll='ls -l'
alias la='ls -A'
alias refresh='exec $SHELL -l'
alias gs='git status -s'
alias gd='git diff'
alias re='cd $(ghq list -p | peco)'
alias gco='git checkout `git branch | peco | sed -e "s/^\*[ ]*//g"`'
alias ip='ipconfig getifaddr en0'
alias ai='find ./ -name "*.apk" | peco | xargs adb-peco install -r'
alias au='adbp shell pm list package | sed -e s/package:// | peco | xargs adb-peco uninstall'
alias refresh-adb='adb kill-server; adb start-server'
alias adbp='adb-peco'
alias g='git'
alias gclean='git checkout master && git pull --rebase origin master && git branch --merged origin/master | grep -v "^\s*master" | grep -v "^*" | xargs git branch -D'
alias gback='git reset HEAD~'
alias remote-push='git push kazuki-yoshida `git rev-parse --abbrev-ref HEAD`'
alias origin-push='git push origin `git rev-parse --abbrev-ref HEAD`'
alias emu='emulator -list-avds | peco | xargs ~/Library/Android/sdk/emulator/emulator -avd'
alias yrn='yarn run $(package_json_scripts | peco)'

#----------------------------------------------------------
# 基本
#----------------------------------------------------------
# 補完される前にオリジナルのコマンドまで展開してチェックする
setopt complete_aliases
# 色を使う
autoload -U colors; colors
# ビープを鳴らさない
setopt nobeep
# エスケープシーケンスを使う
setopt prompt_subst
# コマンドラインでも#以降をコメントと見なす
setopt interactive_comments
# emacs風のキーバインド
bindkey -e
# C-s, C-qを無効にする
setopt no_flow_control
# 日本語のファイル名を表示可能
setopt print_eight_bit
# C-wで直前の/までを削除する
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# ディレクトリを水色にする
export LS_COLORS='di=01;36'
#----------------------------------------------------------
# 補完関連
#----------------------------------------------------------
# 補完機能を強化
autoload -Uz compinit; compinit
# URLを自動エスケープ
autoload -Uz url-quote-magic; zle -N self-insert url-quote-magic

# TABで順に補完候補を切り替える
setopt auto_menu
# 補完候補を一覧表示
setopt auto_list
# 補完候補をEmacsのキーバインドで動けるように
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
# --prefix=/usrなどの=以降も補間
setopt magic_equal_subst
# ディレクトリ名の補間で末尾の/を自動的に付加し、次の補間に備える
setopt auto_param_slash
## 補完候補の色付け
#eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧でファイルの種別をマーク表示
setopt list_types
# 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash
# スペルチェック
setopt correct
# killコマンドでプロセスを補完
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

#----------------------------------------------------------
# 移動関連
#----------------------------------------------------------
# ディレクトリ名でもcd
setopt auto_cd
# cdのタイミングで自動的にpushd.直前と同じ場合は無視
setopt auto_pushd
setopt pushd_ignore_dups
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

#----------------------------------------------------------
# 履歴関連
#----------------------------------------------------------
# 履歴の保存先
HISTFILE=$HOME/.zsh-history
# メモリに展開する履歴の数
HISTSIZE=10000
# 保存する履歴の数
SAVEHIST=10000
# ヒストリファイルにコマンドラインだけではなく実行時刻と実行時間も保存する。
setopt extended_history
# ヒストリ全体でのコマンドの重複を禁止する
setopt hist_ignore_dups
# コマンドの空白をけずる
setopt hist_reduce_blanks
# historyコマンドはログに記述しない
setopt hist_no_store
# 先頭が空白だった場合はログに残さない
setopt hist_ignore_space
# 履歴ファイルに時刻を記録
setopt extended_history
# シェルのプロセスごとに履歴を共有
setopt share_history
# 複数のzshを同時に使うときなどhistoryファイルに上書きせず追加
setopt append_history
# 履歴をインクリメンタルに追加
setopt inc_append_history
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 履歴検索機能のショートカット設定
autoload history-search-end
function history-all { history -E 1 }

#----------------------------------------------------------
# プロンプト表示関連
#----------------------------------------------------------
function precmd() {
PROMPT="%{${fg[yellow]}%}%n%{${fg[red]}%} %~%{${reset_color}%}"
color=`get-branch-status`
PROMPT+=" %{$color%}$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /')%b%{${reset_color}%}
"
}

function get-branch-status {
    local res color
        output=`git status --short 2> /dev/null`
        if [ -z "$output" ]; then
            res=':' # status Clean
            color='%{'${fg[green]}'%}'
        elif [[ $output =~ "[\n]?\?\? " ]]; then
            res='?:' # Untracked
            color='%{'${fg[yellow]}'%}'
        elif [[ $output =~ "[\n]? M " ]]; then
            res='M:' # Modified
            color='%{'${fg[red]}'%}'
        else
            res='A:' # Added to commit
            color='%{'${fg[cyan]}'%}'
        fi
        echo ${color}
}

#----------------------------------------------------------
# その他
#----------------------------------------------------------
# ログアウト時にバックグラウンドジョブをkillしない
setopt no_hup
# ログアウト時にバックグラウンドジョブを確認しない
setopt no_checkjobs
# バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる
setopt notify

# $EDITORの設定
if [ -s $(brew --prefix)/bin/vim ]; then
  export EDITOR=$(brew --prefix)/bin/vim
else
  export EDITOR=/usr/bin/vim
fi

#----------------------------------------------------------
# 便利関数
#----------------------------------------------------------
function mk () { mkdir -p "$@" && eval cd "\"\$$#\""; }

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function remote-checkout() {
  git fetch $1 $2 && git checkout -b $2 $1/$2
}

function pero() {
  ag "$@" . | peco --exec 'awk -F : '"'"'{print "+" $2 " " $1}'"'"' | xargs less -R -N '
}

function package_json_scripts () {
  cat package.json | jq -r '.scripts | keys[]'
}

#----------------------------------------------------------
# 開発で利用するPATH
#----------------------------------------------------------
ANDROID_HOME=~/Library/Android/sdk
export JAVA_HOME=`/usr/libexec/java_home`
export ANDROID_HOME=~/Library/Android/sdk
export JDK_HOME=$JAVA_HOME
export GROOVY_HOME=/usr/local/opt/groovy/libexec
JAVA8_HOME=`/usr/libexec/java_home -v "1.8" -F`
if [ $? -eq 0 ]; then
    export JAVA8_HOME
fi
PATH=~/.rbenv/shims:$ANDROID_HOME/platform-tools/:$ANDROID_HOME/tools/bin/:$ANDROID_HOME/tools:$PATH
PATH=$JAVA_HOME/bin:$PATH
PATH=~/Library/Python/2.7/bin:$PATH #for powerline
PATH=/opt/brew/heroku/bin:$PATH
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export PATH=$HOME/.nodebrew/current/bin:$PATH

eval "$(direnv hook zsh)"
