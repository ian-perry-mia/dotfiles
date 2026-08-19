if status is-interactive
    starship init fish | source

        function __start_zellij --on-event fish_prompt
            functions --erase __start_zellij

            if not set -q ZELLIJ
                if set -q SSH_CONNECTION
                    # SSH session
                    exec zellij attach --create
                else
                    # Local terminal
                    zellij attach --create local
                end
            end
        end

    set -gx GIT_SSH_COMMAND "ssh -i $HOME/.ssh/id_ed25519.github -o IdentitiesOnly=yes"

    if test (uname) = Darwin
        set -gx SSH_AUTH_SOCK "$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
    else
        set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"
    end
end



# Replicate bash !!
abbr -a !! --position anywhere --function last_history_item

function last_history_item
    echo $history[1]
end

# User-local binaries
fish_add_path "$HOME/.local/bin"
