#!/usr/bin/fish

function check_fish_version
    set version_string (fish --version)
    set test_collect (echo "1\n2" | string collect )
    or begin; echo $version_string; error "Too old. This script requires ^3.1.0"; exit 1; end
end

# Print on stderr to not pollute function return echo
function error -a "message" -d "Git style error message"
    echo "::error::\t$message" >& 2
end

function warning -a "message" -d "Git style warning message"
    echo "::warning::$message" >& 2
end

function inform -a "message"
    # Simply pipe to stderr
    echo "$message" >& 2
end

function set_output -a "name" "output"
    if test \( -z "$name" -o -z "$output" \)
        error "Missing arguments for set_output!"
        exit 1
    end
    # Should be single line otherwise would need to esape chars for output
    # Tried https://github.community/t5/GitHub-Actions/set-output-Truncates-Multiline-Strings/td-p/37870
    echo "::set-output name=$name""::$output"
end

function mask -a "secret" -d "Git style of hiding output"
    echo "::add-mask::$secret" >& 2
end

function help
    set scriptname (status -f)
    echo "$scriptname [OPTION] ... 

This script is a wrapper around rsync and git.
It will copy the specified files into the given repo and push the changes.
Designed for use as a GitHub Action but the script could also be used locally.
The variable GitHub access token called \$GH_ACCESS_TOKEN has to be set!

 Options:
  --source-directory    The source directory which is the root for the actions. (Required)
  --include-patterns    Define which file patterns should be included. If used others are excluded
  --exclude-patterns    Define whcih file patterns should be excluded. Can be combined with `include-patterns`
  --repository          Set which repo will be used. Defaults to the wiki of current repo
  --user                Set the user name for git. Default to current user
  --mail                Set the email address for git. Defaults to current user @users.noreply.github.com
  --commit-message      Set the commit-message for the push. Default is `Action Bot pushing.`
  --branch              Set which branch should be checkout out. Default is master
  --help                Display this help and exit

"
end

function help_exit
    help
    exit 1
end

function load_repo -a "repo"
    if test -z "$repo"
        inform "Trying to infer wiki url of current repo"
        if test -z "$GITHUB_REPOSITORY"
            error "Couldn't infer wiki of current repo. \$GITHUB_REPOSITORY isn't set!"
            exit 1
        end
        set repo "$GITHUB_REPOSITORY"".wiki"
    end
    echo "$repo"
end

# Load from environment variable
function load_github_token
    set token $GH_ACCESS_TOKEN
    mask $token
    if test -z "$token"
        error "Token has to be set over environment variable: \$GH_ACCESS_TOKEN!"
        help_exit
    end
    echo "$token"
end

function load_source -a "source"
    if test -z "$source"
        error "Source needs to be specified."
        exit 1
    end
    echo "$source"
end

function load_user -a "user"
    if test -z "$user"
        inform "Trying to infer user from \$GITHUB_ACTOR"
        if test -z "$GITHUB_ACTOR"
            set user "bot"
            inform "Failed; setting user to default name: $user"
        else
            set user $GITHUB_ACTOR
        end
    end
    echo "$user"
end

function load_email -a "email"
    if test -z "$email"
        inform "Trying to infer default email from \$GITHUB_ACTOR"
        if test -z "$GITHUB_ACTOR"
            set email "bot@users.noreply.github.com"
            inform "Failed; setting email to default email: $email"
        else
            set email "$GITHUB_ACTOR""@users.noreply.github.com"
        end
    end
    echo $email
end

function load_commit_message -a "commit_message"
    if test -z "$commit_message"
        set commit_message "Action Bot is pushing"
        inform "Using default commit message: $commit_message"
    end
    echo "$commit_message"
end

function load_branch -a "branch"
    if test -z "$branch"
        set branch "master"
        inform "Using master branch by default"
    end
    echo "$branch"
end

function parse_url -a "repo" "token"
    if test \( -z "$repo" -o -z "$token" \)
        error "parse_url function failed!"
        exit 1
    end
    set url "https://$token@github.com/$repo.git"
    echo "$url"
end

# Simply prefix --exclude= to each exclude pattern
function build_exclude_option -a "exclude_patterns"
    if test -z "$exclude_patterns"
        set exclude_option ""
    else
        set exclude_option (string replace -r -a '(?:^|\\s)+(\\S+)' ' --exclude="$1"' $exclude_patterns)
    end
    # always ignore .git folders!
    set exclude_option "$exclude_option"" --exclude=.git/"
    echo "$exclude_option"
end

# If include was set, everything else should be ignored by default
# only matching files should be considered
# First make sure all directories are included
# Then include all of these specified files
# Finally exclude all other files
function build_include_option -a "include_patterns"
    if test -z "$include_patterns"
        echo ""
        return
    end
    set include_prefix ' --include="*/"'
    set include_pattern (string replace -r -a '(?:^|\\s)+(\\S+)' ' --include="$1"' "$include_patterns")
    set include_suffix ' --exclude="*"'
    set include_option "$include_prefix""$include_pattern""$include_suffix"
    echo "$include_option"
end

function end_path_with_slash -a "path"
    if test -z "$path"
        error "No path provided"
        exit 1
    end
    echo (string replace -r '(.*?)/?\\s*$' '$1/' "$path")
end

# Register tmp_dir variable to be deleted on exit
# Used for the temporarily created directory
function delete_on_exit --on-event "fish_exit"
    if test -n "$tmp_dir"
        echo "Automatically deleting tmp dir"
        rm -rf $tmp_dir
    end
end

function git_pull_to_dir -a "user" "email" "repo_url" "branch" "target_dir"
    if test \( -z "$user" -o -z "$email" -o -z "$repo_url" -o -z "$branch" -o -z "$target_dir" \)
        error "Missing arguments in git_pull_to_dir function"
        exit 1
    end
    pushd "$tmp_dir"; or begin; error "Couldn't switch to dir: $tmp_dir"; exit 1; end
    git clone -b "$branch" "$repo_url" --depth=1 .
    and git config user.email "$email"
    and git config user.name "$user"
    or begin; error "Error during pulling"; exit 1; end
    popd; or begin; error "Couldn't pop from directory stack"; exit 1; end
end

function git_push_dir -a "git_dir" "commit_message" "repo_url" "dry_run"
    if test \( -z "$git_dir" -o -z "$commit_message" -o -z "$repo_url" \)
        error "Missing arguments in git_push_dir function!"
        exit 1
    end
    echo "$repo_url"
    pushd "$git_dir"; or begin; error "Couldn't switch to dir: $git_dir"; exit 1; end
    git branch -a
    git add .
    git commit -m "$commit_message"  # Allow git to reject commit if nothing has changed
    if test -z "$dry_run"
        git push "$repo_url"
        or begin; error "Error during pushing to git!"; exit 1; end
    else
        warning "dry-run option used! Won't push!" 
    end
    set sync_result (find . -type d -path '*/.git' -prune -o -name '*' -type f -print0 | sort -z | xargs -0)
    echo $sync_result
    set_output sync_result $sync_result
    popd; or begin; error "Couldn't pop from directory stack"; exit 1; end
end

function rsync_wrapper -a "exclude_option" "include_option" "source_dir" "target_dir"
    set rsync_cmd "rsync -av --prune-empty-dirs"
    set rsync_cmd "$rsync_cmd""$exclude_option""$include_option"" $source_dir"" $target_dir"
    echo $rsync_cmd
    eval $rsync_cmd
    or begin; error "Problem occured in rsync command! This should not happen."; exit 1; end
end

# =====================================================================================================================================

check_fish_version
# make sure to use LF ending and not CLRF, otherwise this doesn't work!
set args "h-help=?" "s-source-dir=?" "i-include-patterns=?" "\
e-exclude-patterns=?" "r-repository=?" "b-branch=?" "u-user=?" "\
m-mail=?" "c-commit-message=?" "d-dry-run=?"
argparse --name=copy_action $args -- $argv
or help_exit

if set -q _flag_help
    help
    exit 0
end

set token (load_github_token)
set repo (load_repo "$_flag_repository")
set source (load_source "$_flag_source_dir")
set formatted_source (end_path_with_slash "$source")
set user (load_user "$_flag_user")
set email (load_email "$_flag_mail")
set commit_message (load_commit_message "$_flag_commit_message")
set branch (load_branch "$_flag_branch")
set repo_url (parse_url "$repo" "$token")

set tmp_dir (mktemp -d)
git_pull_to_dir "$user" "$email" "$repo_url" "$branch" "$tmp_dir"
set exclude_option (build_exclude_option "$_flag_exclude_patterns")
set include_option (build_include_option "$_flag_include_patterns")

rsync_wrapper "$exclude_option" "$include_option" "$formatted_source" "$tmp_dir"
git_push_dir "$tmp_dir" "$commit_message" "$repo_url" "$_flag_dry_run"
