# Note: unlike 8a, backquote work here.
echo $((`cat input.8 | sed 's/["\\]/__/g; s/^/"/g; s/$/"/' | wc -c`-`cat input.8 | wc -c`))
