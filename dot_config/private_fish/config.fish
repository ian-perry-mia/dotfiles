if status is-interactive
    starship init fish | source

    # zellij auto-attach to session "local", only for a human at a real terminal.
    function __start_zellij --on-event fish_prompt
        functions --erase __start_zellij

        set -q ZELLIJ; and return                       # already inside zellij
        isatty stdin; and isatty stdout; or return      # no tty: scp/rsync/ansible/pipes
        test "$TERM" = dumb; and return
        # Claude (desktop app / Claude Code) and editor terminals; a second client
        # on the shared "local" session also shrinks it to the smaller window.
        set -q CLAUDECODE; and return
        contains -- "$TERM_PROGRAM" claude-desktop vscode; and return
        type -q zellij; or return

        if set -q SSH_CONNECTION
            set -q SSH_TTY; or return                   # ssh without a pty (`ssh host cmd`)
            exec zellij attach --create local
        else
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
