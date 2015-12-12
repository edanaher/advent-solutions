# Note the use of input.12.1, because I initially mis copy/pasted and had bad
# input.  What a waste of six minutes or so.
cat input.12.1 | grep -o -- '-\?[0-9]\+' | awk '{x+=$1} END {print x}'
