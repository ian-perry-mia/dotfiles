set -l plugin_dir "$HOME/.config/zellij/plugins"
set -l plugin_file "$plugin_dir/zjstatus.wasm"
set -l version_file "$plugin_dir/zjstatus.version"

mkdir -p "$plugin_dir"

set -l latest_version (curl -fsSL https://api.github.com/repos/dj95/zjstatus/releases/latest | jq -r '.tag_name')

set -l installed_version ""
if test -f "$version_file"
    set installed_version (string trim < "$version_file")
end

if not test -f "$plugin_file"; or test "$installed_version" != "$latest_version"
    echo "Updating zjstatus to $latest_version..."

    curl -fL \
        https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm \
        -o "$plugin_file"

    if test $status -eq 0
        echo "$latest_version" > "$version_file"
        echo "zjstatus updated to $latest_version"
    else
        echo "Failed to download zjstatus"
        rm -f "$plugin_file"
    end
end
