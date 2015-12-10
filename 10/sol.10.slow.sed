# So, I kind of like this pure sed solution, but it's painfully slow;
# incrementing a counter via regex millions of times takes a while.

s/^/_________________________/
#s/^/________________________________________/
#s/^/__________/
#s/^/___________/
:subst
s/111/ca/g
s/222/cb/g
s/333/cc/g
s/11/ba/g
s/22/bb/g
s/33/bc/g
s/1/aa/g
s/2/ab/g
s/3/ac/g
s/a/1/g
s/b/2/g
s/c/3/g
s/^_//
/^_/ b subst

# Put zero (current count) and table at the front of the string
s/^/0!0123456789@|/

:count
# Increment the one's place
s/\([^!]\)\(![^|]*\1\(.\)\)/\3\2/
# Carry any overflows...
:carry
s/^\([^!]*\)\([^!]\)@\([^|]*\2\(.\)\)/\1\40\3/
t carry
# Add a new digit if necessary
s/^@/10/

# Remove a sequence digit
s/.$//
# And continue if there are any sequence digits left to count
/|./ b count

# Clear out the table so only the answer remains.
s/!.*//
