if status is-interactive
    if [ -n "$SSH_CLIENT" ]; or [ -n "$SSH_TTY" ]
        set -gx ZELLIJ_AUTO_EXIT    "true"
        set -gx ZELLIJ_AUTO_ATTACH  "true"
        eval (zellij setup --generate-auto-start fish | string collect)
    end
    starship init fish | source
end

# Replicate bash !!
abbr -a !! --position anywhere --function last_history_item

function last_history_item
    echo $history[1]
end
