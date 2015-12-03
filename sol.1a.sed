# Clear out matched pairs
:b
s/()//g
s/)(//g
t b

# Put zero (current count) at the front and the table of numbers at the end.
s/$/!0123456789@/
s/^/0/

# And add a negative sign if appropriate...
s/0)/-&/


:count
# Increment the one's place
s/\([^()]\)[()]\(.*\1\(.\)\)/\3\2/

# Carry any overflows...

:carry
s/\(.\)@\(.*\1\(.\)\)/\30\2/
t carry

# Add a new digit if necessary
s/^\(-\{0,1\}\)@/\110/

# And continue if there are any parentheses left.
s/[()]/&/
t count
s/!.*//
