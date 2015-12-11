# Add alphabet for checking three in a row and incrementing.
s/$/|abcdefghijklmnopqrstuvwxyz@/

:loop

s/\(.\)\(|.*\1\(.\)\)/\3\2/
:carry
s/\(.\)@\(.*\1\(.\)\)/\3a\2/
t carry

# Increment bad characters straight off the bat
:killambiguous
s/\([iol]\)\([^|]*|.*\1\(.\)\)/\3\2/
t killambiguous

# Loop if there are no double characters
/\(.\)\1[^|]*\(.\)\2/! b loop

# Loop if there are no consecutive characters
/\(...\)[^|]*|.*\1/! b loop
s/|.*//
