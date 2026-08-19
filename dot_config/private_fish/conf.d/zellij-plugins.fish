# Zellij plugin manager
#
# Manages:
#   dj95/zjstatus
#   b0o/zjstatus-hints
#
# Missing plugins are downloaded immediately.
# Update checks are performed at most once per day.

set -l plugin_dir "$HOME/.config/zellij/plugins"
set -l cache_dir "$HOME/.cache/zellij"
set -l check_file "$cache_dir/plugin-update-check"

mkdir -p "$plugin_dir"
mkdir -p "$cache_dir"


function __zellij_plugin_latest --argument-names repo
    curl -fsSL \
        -H 'Accept: application/vnd.github+json' \
        "https://api.github.com/repos/$repo/releases/latest" \
        2>/dev/null |
        jq -r '.tag_name // empty'
end


function __zellij_plugin_update \
    --argument-names repo asset output version_file force_check

    # ------------------------------------------------------------
    # Determine whether we need to contact GitHub.
    # ------------------------------------------------------------

    set -l must_check false

    if not test -f "$output"
        set must_check true
    else if test "$force_check" = true
        set must_check true
    end

    if test "$must_check" != true
        return 0
    end


    # ------------------------------------------------------------
    # Get latest release
    # ------------------------------------------------------------

    set -l latest (__zellij_plugin_latest "$repo")

    if test -z "$latest"
        echo "Unable to determine latest release for $repo" >&2
        return 1
    end


    # ------------------------------------------------------------
    # Determine installed version
    # ------------------------------------------------------------

    set -l installed ""

    if test -f "$version_file"
        set installed (string trim < "$version_file")
    end


    # Already current.
    if test -f "$output"; and test "$installed" = "$latest"
        return 0
    end


    # ------------------------------------------------------------
    # Download
    # ------------------------------------------------------------

    set -l tmp "$output.tmp"

    if curl -fL \
        "https://github.com/$repo/releases/download/$latest/$asset" \
        -o "$tmp"

        mv "$tmp" "$output"
        printf '%s\n' "$latest" > "$version_file"

        echo "Updated $repo to $latest"
    else
        echo "Failed to download $repo $latest" >&2
        rm -f "$tmp"
        return 1
    end
end


# ================================================================
# Decide whether today's update check has already happened
# ================================================================

set -l today (date '+%Y-%m-%d')
set -l last_check ""

if test -f "$check_file"
    set last_check (string trim < "$check_file")
end

set -l force_check false

if test "$today" != "$last_check"
    set force_check true
end


# ================================================================
# zjstatus
# ================================================================

__zellij_plugin_update \
    "dj95/zjstatus" \
    "zjstatus.wasm" \
    "$plugin_dir/zjstatus.wasm" \
    "$plugin_dir/zjstatus.version" \
    "$force_check"


# ================================================================
# zjstatus-hints
# ================================================================

__zellij_plugin_update \
    "b0o/zjstatus-hints" \
    "zjstatus-hints.wasm" \
    "$plugin_dir/zjstatus-hints.wasm" \
    "$plugin_dir/zjstatus-hints.version" \
    "$force_check"


# ================================================================
# Mark today's check complete
# ================================================================

if test "$force_check" = true
    printf '%s\n' "$today" > "$check_file"
end


# Don't pollute the global Fish function namespace.
functions --erase __zellij_plugin_latest
functions --erase __zellij_plugin_update
