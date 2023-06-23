#!/bin/bash

cd ~/code/localhost

# Make sure `gerrit` resolves to localhost in /etc/hosts

rm -rf ~/code/localhost/{zuul-config,test1}

git clone "http://gerrit:9280/zuul-config" && (cd "zuul-config" && mkdir -p `git rev-parse --git-dir`/hooks/ && curl -Lo `git rev-parse --git-dir`/hooks/commit-msg http://gerrit:9280/tools/hooks/commit-msg && chmod +x `git rev-parse --git-dir`/hooks/commit-msg)

git clone "http://gerrit:9280/test1" && (cd "test1" && mkdir -p `git rev-parse --git-dir`/hooks/ && curl -Lo `git rev-parse --git-dir`/hooks/commit-msg http://gerrit:9280/tools/hooks/commit-msg && chmod +x `git rev-parse --git-dir`/hooks/commit-msg)

cp -r ~/code/github.com/dzintars/zuul/zuul-config ~/code/localhost
cp -r ~/code/github.com/dzintars/zuul/test1 ~/code/localhost

# cd ./zuul-config
# Edit .gerritconfig
# git add -A
# git commit
