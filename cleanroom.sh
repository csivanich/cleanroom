#!/usr/bin/env bash

# Cleanroom: Copy a repo and open a shell with a clean slate
# Author: Chris Sivanich <csivanich@gmail.com>
# License: MIT
#

DEFAULT_BRANCH="origin/master"
DIR_BASE="$(mktemp -d)"
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

msg(){
    echo "$*"
}

error(){
    default_msg="An unknown error has occured"
    echo "ERROR: ${*:-$default_msg}" >&2
}

fail(){
    error "$*"
    rm $DIR_BASE -rf || error "Failed to clean up dir '$DIR_BASE' on failure"
    exit 1
}

print_help(){
    echo "USAGE: cleanroom [branch=$DEFAULT_BRANCH]"
}

fail_with_help(){
    error "$*"
    print_help
    exit 1
}

repo_root_dir(){
    git rev-parse --show-toplevel
}

run(){
    repo_src="$(repo_root_dir)"
    repo_name="$(basename $repo_src)"
    branch="${1:-$DEFAULT_BRANCH}"

    dest="$repo_name-$(echo $branch | tr '/' '-')"
    dest="$DIR_BASE/$dest"

    msg "Creating cleanroom of '$repo_name' ($branch) at '$dest'"

    cp $repo_src -r "$dest" || fail "Could not copy git repo"
    cd $dest || fail "Could not change directory to '$dest'"
    rm ./* -rf || fail "Could not clear repository"
    git checkout $branch || fail "Could not checkout branch '$branch'"
    git reset --hard
    msg "Completed creating cleanroom of '$repo_name' ($branch) at $dest"
    clear
    msg "In $repo_name ($branch) cleanroom at $dest - exit to destroy"
    (cd $dest; $SHELL)
    rm $dest -rf || fail "Could not remove directory $dest"
}

run $*
