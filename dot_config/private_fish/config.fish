if status is-interactive
    if [ -n "$SSH_CLIENT" ]; or [ -n "$SSH_TTY" ]
        eval (zellij setup --generate-auto-start fish | string collect)
    end
    starship init fish | source
end
