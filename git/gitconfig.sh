#!/usr/bin/env bash

# Name and email
git config --global user.name "Jonathan Bell"
git config --global user.email "jonathanbell.ca@gmail.com"

# http://stackoverflow.com/q/3206843/1171790
git config --global core.autocrlf input
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
# Don't rebase but merge when doing a pull.
git config --global pull.rebase false

# Accept the auto-generated merge message.
# https://git-scm.com/docs/merge-options#merge-options---no-edit
git config --global core.mergeoptions --no-edit

# Default editor
git config --global core.editor 'code --wait'

# Global gitignore
touch ~/.gitignore
git config --global core.excludesFile '~/.gitignore'
echo ".vscode" >> ~/.gitignore

# Config Meld to be the mergetool
# https://stackoverflow.com/a/34119867
git config --global merge.tool meld
# TODO: You may have to change this to: `'meld "$LOCAL" "$MERGED" "$REMOTE" --output "$MERGED"'` (investigate this)
git config --global mergetool.meld.cmd 'meld $LOCAL $MERGED $REMOTE --output $MERGED'
# https://stackoverflow.com/a/27417871
git config --global merge.conflictStyle diff3

# Config VS Code to be the difftool
# https://stackoverflow.com/questions/44549733/how-to-use-visual-studio-code-as-default-editor-for-git-mergetool
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code -n --wait --diff $LOCAL $REMOTE'
git config --global difftool.prompt false
