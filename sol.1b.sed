# Put zero (current count) at the front and the table of numbers at the end.
s/$/!13579@%0123456789@/
s/^/1/

x
s/^/========/
x

:cancel
t resettest
:resettest
# Cancel out the first up and down
s/\([0-9]\)(\([^)]*\))/\1\2/
# If there was no substition, we're done.
t count
b finished

:count
# Increment the one's place
s/\([^(]\)\([()][^%]*\1\(.\)\)/\3\2/


# Carry any overflows...
:carry
s/^\([0-9]*\)\([0-9]\)@\(.*\2\(.\)\)/\1\40\3/
t carry

# Add a new digit if necessary
s/^@/10/

# And promote first digit 0 to 1 if it was carried
s/^\([0-9]*\)0\([()]\)/\11\2/

# And continue if there are any parentheses left, using t to reset the test.
b cancel

:finished
s/[()].*//
