# ~/.config/fish/conf.d/zellij-plugins.fish

set -l plugin_dir "$HOME/.config/zellij/plugins"
mkdir -p "$plugin_dir"

function __update_zellij_plugin \
    --argument-names repo asset output version_file

    set -l latest (
        curl -fsSL "https://api.github.com/repos/$repo/releases/latest" 2>/dev/null |
        jq -r '.tag_name // empty'
    )

    if test -z "$latest"
        echo "Unable to determine latest $repo release" >&2
        return 1
    end

    set -l installed ""

    if test -f "$version_file"
        set installed (string trim < "$version_file")
    end

    if test -f "$output"; and test "$installed" = "$latest"
        return 0
    end

    echo "Updating $repo: $installed -> $latest"

    set -l tmp "$output.tmp"

    if curl -fL \
        "https://github.com/$repo/releases/latest/download/$asset" \
        -o "$tmp"

        mv "$tmp" "$output"
        printf '%s\n' "$latest" > "$version_file"

        echo "Installed $repo $latest"
    else
        echo "Failed to download $repo $latest" >&2
        rm -f "$tmp"
        return 1
    end
end


__update_zellij_plugin \
    "dj95/zjstatus" \
    "zjstatus.wasm" \
    "$plugin_dir/zjstatus.wasm" \
    "$plugin_dir/zjstatus.version"

__update_zellij_plugin \
    "b0o/zjstatus-hints" \
    "zjstatus-hints.wasm" \
    "$plugin_dir/zjstatus-hints.wasm" \
    "$plugin_dir/zjstatus-hints.version"

functions --erase __update_zellij_plugin
