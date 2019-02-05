#!/usr/bin/env bash

# Name and email
git config --global user.name "Jonathan Bell"
git config --global user.email "jonathanbell.ca@gmail.com"

# Default editor
git config --global core.editor "code --wait"

# Fetch all branches:
# https://team.benevity.org/pages/viewpage.action?pageId=37562785#SettingupaDrupal8&BonfireEnvironment-Donotchangethisdocumentlightly!
git config --global remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

# http://stackoverflow.com/q/3206843/1171790
git config --global core.autocrlf input
# Fix whitespace isssues. http://stackoverflow.com/a/2948167/1171790
git config --global core.whitespace fix
# But don't warn about whitespace, thanks.
git config --global apply.whitespace nowarn
# Allow all Git commands to use colored output.
git config --global color.ui true
# https://gist.github.com/trey/2722934
git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto
git config --global color.interactive auto
git config --global color.ui true
git config --global color.pager true
# Push only the current branch to remote (same as what a `git pull` would use).
# Note that the remote branch *could* possibly have a different name than your local branch.
# https://git-scm.com/docs/git-config.html#git-config-branchltnamegtremote
git config --global push.default current
# Accept the auto-generated merge message.
# https://git-scm.com/docs/merge-options#merge-options---no-edit
git config --global core.mergeoptions --no-edit
