#!/bin/bash

pre_commit_hook='#!/bin/bash
max_size=52428800 # 50MB, GitHub warns for anything over 50MB
for file in $(git diff --cached --name-only); do
    if [ -f "$file" ]; then
        file_size=$(stat -c%s "$file")
        if [ "$file_size" -ge "$max_size" ]; then
            printf "Error: Attempting to commit a large file (%s, %d bytes). Use Git LFS or reduce file size.\n" "$file" "$file_size"
            exit 1
        fi
    fi
done
'

pre_push_hook='#!/bin/bash
max_size=52428800 # 50MB

# List the files about to be pushed
git rev-list --objects --all | git cat-file --batch-check="%(objecttype) %(objectname) %(rest)" | awk "{ if (\$1 == \"blob\" && \$3 != \"\") print \$0 }" |
while read objecttype objecthash filename; do
    file_size=$(git cat-file -s $objecthash)
    if [ "$file_size" -ge "$max_size" ]; then
        printf "Error: File '%s' is larger than %d bytes. Please use Git LFS.\n" "$filename" "$max_size"
        exit 1
    fi
done
'

for repo in $(find . -name ".git" -type d); do
    pre_commit_hook_path="$repo/hooks/pre-commit"
    pre_push_hook_path="$repo/hooks/pre-push"

    printf "%s" "$pre_commit_hook" > "$pre_commit_hook_path"
    chmod +x "$pre_commit_hook_path"

    printf "%s" "$pre_push_hook" > "$pre_push_hook_path"
    chmod +x "$pre_push_hook_path"

    printf "KO Hooks have been deployed to %s\n" "$repo"
done
