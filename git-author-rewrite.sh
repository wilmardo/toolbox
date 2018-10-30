#!/bin/sh
# Usage:
# git-author-rewrite.sh --old_email=wilmaro@intermax.nl --new_email=w.denouden@intermax.nl --new_name="Wilmar den Ouden"

while [ $# -gt 0 ]; do
    case "$1" in
        --old_email=*)
        export old_email="${1#*=}"
        ;;
        --new_email=*)
        export new_email="${1#*=}"
        ;;
        --new_name=*)
        export new_name="${1#*=}"
        ;;
    *)
     printf "***************************\n"
     printf "* Error: Invalid argument.*\n"
     printf "***************************\n"
     exit 1
    esac
    shift
done

git filter-branch --env-filter '
if [ "$GIT_COMMITTER_EMAIL" = "$old_email" ]
then
    export GIT_COMMITTER_NAME="$new_name"
    export GIT_COMMITTER_EMAIL="$new_email"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$old_email" ]
then
    export GIT_AUTHOR_NAME="$new_name"
    export GIT_AUTHOR_EMAIL="$new_email"
fi
' --tag-name-filter cat -- --branches --tags
