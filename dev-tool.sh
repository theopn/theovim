#!/bin/bash

#
# @requires fzf for picking commits
#
generate_commit_list() {
  prev_commit=$(git log --oneline | \
    grep -m 5 -i 'mErGe' | \
    fzf --reverse --border=rounded --cycle --height=30% --header='Pick the Merge Commit Before the New Version' | \
    cut -d' ' -f1)
  echo "Generating the list of commits since ${prev_commit}..."
  git log ${prev_commit}.. --pretty="- [%h] %s"

}

generate_commit_list
