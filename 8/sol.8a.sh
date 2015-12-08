# Note: backquotes require extra escaping of \; $() doesn't.
echo $((`cat input.8 | wc -c`-$(cat input.8 | sed 's/^"//; s/"$//; s/\\[\\"]/_/g; s/\\x[0-9a-f][0-9a-f]/_/g' | wc -c)))
