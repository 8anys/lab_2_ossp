#!/bin/bash

read -p "Введіть шлях до каталогу: " DIR
read -p "Введіть URL віддаленого репозиторію: " REMOTE
read -p "Введіть ім'я гілки[default: master]: " BRANCH


case "$DIR" in
    /*) ;;
    *) DIR="$(pwd)/$DIR" ;;
esac

if ! [ -d "$DIR" ]; then
    echo "Помилка: не має такої директорії"
    exit 2
fi

cd "$DIR" || exit 2

git init --initial-branch="$BRANCH"
git remote add origin "$REMOTE"
git add .
git commit -m "Initial commit"
git push --set-upstream origin "$BRANCH"


exit 0

