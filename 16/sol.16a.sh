eval "cat input.16 | `cat tape.16 | sed 's#\([^:]*\): \([0-9]*\)#sed -n '"'"'/\1: \2/ p; /\1/! p'"'"' | #'` cat"
