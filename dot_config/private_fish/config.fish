if status is-interactive
    # Starship
    starship init fish | source

    set -gx ZELLIJ_AUTO_EXIT true
    set -gx ZELLIJ_AUTO_ATTACH true

    if not set -q ZELLIJ
        if test (uname) = Darwin
            zellij attach --create local
            set zellij_status $status
            if test $zellij_status -eq 0
                if test "$ZELLIJ_AUTO_EXIT" = true
                    exit
                end
            else
                echo "Zelij failed to start; remaining in Fish."
            end
        else
            eval (zellij setup --generate-auto-start fish | string collect)
        end
    end

    set -gx GIT_SSH_COMMAND "ssh -i $HOME/.ssh/id_ed25519.github -o IdentitiesOnly=yes"

    # Bitwarden SSH agent
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
