#!/usr/bin/env bash

# Cleanroom: Copy a repo and open a shell with a clean slate
# Author: Chris Sivanich <csivanich@gmail.com>
# License: MIT
#

SHELL=bash #${SHELL:-sh}
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

set_verbose(){
    if [[ "$VERBOSE" == "1" ]];then
        V="-v"
    else
        V=""
    fi
}

run(){
    set_verbose

    repo_src="$(repo_root_dir)"
    repo_name="$(basename $repo_src)"
    branch="${1:-$DEFAULT_BRANCH}"

    dest="$repo_name-$(echo $branch | tr '/' '-')"
    dest="$DIR_BASE/$dest"

    msg "Creating cleanroom of '$repo_name' ($branch) at '$dest'"

    cp $repo_src $V -r "$dest" || fail "Could not copy git repo"
    cd $dest || fail "Could not change directory to '$dest'"
    rm ./* $V -rf || fail "Could not clear repository"
    git checkout $branch || fail "Could not checkout branch '$branch'"
    git reset --hard
    msg "Completed creating cleanroom of '$repo_name' ($branch) at $dest"
    clear
    msg "In $repo_name ($branch) cleanroom at $dest - exit to destroy"
    (cd $dest;export CLEANROOM=1;$SHELL)
    rm $DIR_BASE -rf $V || fail "Could not remove directory $dest"
}

run $*
