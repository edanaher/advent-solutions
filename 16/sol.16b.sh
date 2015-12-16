# Edit the tape to do ranges.
eval "cat input.16 | `cat tape.16b | sed 's#\([^:]*\): \(.*\)#sed -n '"'"'/\1: \2/ p; /\1/! p'"'"' | #'` cat"
