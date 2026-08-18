if test -d "/usr/local/go/bin"
    fish_add_path /usr/local/go/bin
    fish_add_path $HOME/.local/go/bin
    set -gx GOPATH $HOME/.local/go
end
