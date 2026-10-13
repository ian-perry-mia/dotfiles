if status is-interactive
    starship init fish | source

    function __start_zellij --on-event fish_prompt
        functions --erase __start_zellij

        set -q ZELLIJ; and return
        set -q CLAUDECODE; and return

        if set -q SSH_CONNECTION
            exec zellij attach --create
        else if test "$TERM_PROGRAM" = ghostty
            zellij attach --create local
    end
end

    set -gx GIT_SSH_COMMAND "ssh -i $HOME/.ssh/id_ed25519.github -o IdentitiesOnly=yes"
end



# Replicate bash !!
abbr -a !! --position anywhere --function last_history_item

function last_history_item
    echo $history[1]
end

# User-local binaries
fish_add_path "$HOME/.local/bin"
