#!/bin/bash 

cd ~/dotfiles 

for dir in */ ; do
		stow -R "${dir%/}"
done

git add .

echo "Enter commit message: "
read -r msg

git commit -m "$msg"
git push origin main

echo "✅ Dotfiles updated and pushed to GitHub!"
