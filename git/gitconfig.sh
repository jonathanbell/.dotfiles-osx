#!/usr/bin/env bash

# Name and email
git config --global user.name "Jonathan Bell"
git config --global user.email "jonathanbell.ca@gmail.com"

# Change the name of the main branch
git config --global init.defaultBranch main

# http://stackoverflow.com/q/3206843/1171790
git config --global core.autocrlf false
# Fix whitespace isssues. http://stackoverflow.com/a/2948167/1171790
git config --global core.whitespace fix
# But don't warn about whitespace, thanks.
git config --global apply.whitespace nowarn

# Don't keep files after a merge
git config --global mergetool.keepBackup false

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

# Default behaviour for a pull.
# Rebase when pulling.
git config --global pull.rebase true

# Accept the auto-generated merge message.
# https://git-scm.com/docs/merge-options#merge-options---no-edit
git config --global core.mergeoptions --no-edit

# Default editor
git config --global core.editor 'code --wait'

# Global gitignore
touch ~/.gitignore
git config --global core.excludesFile '~/.gitignore'

# Config VS Code to be the mergetool
# https://stackoverflow.com/a/34119867
git config --global merge.tool code
git config --global mergetool.code.cmd 'code --wait --merge $REMOTE $LOCAL $BASE $MERGED'

# Config VS Code to be the difftool
# https://stackoverflow.com/questions/44549733/how-to-use-visual-studio-code-as-default-editor-for-git-mergetool
git config --global diff.tool code
git config --global difftool.code.cmd 'code -n --wait --diff $LOCAL $REMOTE'
git config --global difftool.prompt false
