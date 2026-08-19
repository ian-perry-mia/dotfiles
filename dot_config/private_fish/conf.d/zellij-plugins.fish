# Keep Zellij plugins up to date.
#
# Plugins:
#   dj95/zjstatus
#   b0o/zjstatus-hints

set -l plugin_dir "$HOME/.config/zellij/plugins"

mkdir -p "$plugin_dir"


# ============================================================
# zjstatus
# ============================================================

set -l zjstatus_file "$plugin_dir/zjstatus.wasm"
set -l zjstatus_version_file "$plugin_dir/zjstatus.version"

set -l zjstatus_latest (
    curl -fsSL https://api.github.com/repos/dj95/zjstatus/releases/latest 2>/dev/null |
    jq -r '.tag_name'
)

if test $pipestatus[1] -eq 0; and test -n "$zjstatus_latest"; and test "$zjstatus_latest" != "null"

    set -l zjstatus_installed ""

    if test -f "$zjstatus_version_file"
        set zjstatus_installed (string trim < "$zjstatus_version_file")
    end

    if not test -f "$zjstatus_file"; or test "$zjstatus_installed" != "$zjstatus_latest"

        curl -fsSL \
            https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm \
            -o "$zjstatus_file"

        if test $status -eq 0
            echo "$zjstatus_latest" > "$zjstatus_version_file"
        else
            rm -f "$zjstatus_file"
        end
    end
end


# ============================================================
# zjstatus-hints
# ============================================================

set -l hints_file "$plugin_dir/zjstatus-hints.wasm"
set -l hints_version_file "$plugin_dir/zjstatus-hints.version"

set -l hints_latest (
    curl -fsSL https://api.github.com/repos/b0o/zjstatus-hints/releases/latest 2>/dev/null |
    jq -r '.tag_name'
)

if test $pipestatus[1] -eq 0; and test -n "$hints_latest"; and test "$hints_latest" != "null"

    set -l hints_installed ""

    if test -f "$hints_version_file"
        set hints_installed (string trim < "$hints_version_file")
    end

    if not test -f "$hints_file"; or test "$hints_installed" != "$hints_latest"

        curl -fsSL \
            https://github.com/b0o/zjstatus-hints/releases/latest/download/zjstatus-hints.wasm \
            -o "$hints_file"

        if test $status -eq 0
            echo "$hints_latest" > "$hints_version_file"
        else
            rm -f "$hints_file"
        end
    end
end
