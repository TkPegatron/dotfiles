if command -v nvim >/dev/null; then
    
    if [[ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ]]; then
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    fi

    alias vim="nvim"
    alias vi="nvim"
    alias vimdiff="nvim -d"
    
    export EDITOR=nvim
elif command -v vi >/dev/null && [[ $(vi --version | head -n 1 | awk '{print $1}') == "VIM" ]]\
  || command -v vim >/dev/null ; then

    if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    command -v vi >/dev/null && export EDITOR=vim \
    || command -v vim >/dev/null && export EDITOR=vim

elif command -v vi >/dev/null; then
    export EDITOR=vi
fi
