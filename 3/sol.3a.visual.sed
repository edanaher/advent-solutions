# This is a bit on the slow side; a bit over 2 minutes for my 8k input.
# But so cute!

# Initialize the board
s/$/|___|_@_|___|/

:loop
# Move Santa left or right
s/^\(>[^@]*\)@./\1*@/
s/^\(<[^@]*\).@/\1@*/

# Move Santa down
s/^\(v[^@]*\)|\([^|@]*\)@\([^|]*\)|/\1|#\2@\3|#/
t downloop
:downloop
s/^\(v[^#]*\)#@\([^#]*\)#./\1*\2@/
t downdone
s/#\(.\)/\1#/g
t downloop
:downdone

# Move Santa up
s/^\(\^[^@]*\)|\([^|@]*\)@\([^|]*\)|/\1#|\2@\3#|/
t uploop
:uploop
s/^\(\^[^#]*\).#\([^@]*\)@#/\1@\2*/
t updone
s/\(.\)#/#\1/g
t uploop
:updone

# Print this move
h; s/^\(.\).*/\1/; p; g
# Remove the movement indicator
s/^[v^<>]//

# Add another empty row on the top if necessary
s/^\([^|]*\)|\([^|@]*\)@\([^|]*\)/\1|\2_\3|\2@\3/

# Add another empty row on the bottom if necessary
s/^\(.*|\)\([^|@]*\)@\([^|]*|\)$/\1\2@\3\2_\3/

# Add another empty column on the left or right if necessary
t resetcondleft
:resetcondleft
s/|@/&/
t addleft
b checkright
:addleft
s/|\(.\)/|_\1/g

:checkright
t resetcondright
:resetcondright
s/@|/&/
t addright
b noright
:addright
s/\([_*@]\)|/\1_|/g
:noright

# Save state, remove remaining moves, print board, and restore
h
s/^[v^<>]*//
s/|/\
/g
p
g

t resetcondfinish
:resetcondfinish

s/^[v^<>]/&/
t loop

# And now it's time to count the gifts.
# Clear out all non-gifts, and make Santa a gift for convenience
s/@/*/
s/[^*]//g

# Put zero (current count) at the front and the table of numbers at the end.
s/$/!0123456789@/
s/^/0/

:count
# Increment the one's place
s/\([^*]\)\*\(.*\1\(.\)\)/\3\2/

# Carry any overflows...

:carry
s/\(.\)@\(.*\1\(.\)\)/\30\2/
t carry

# Add a new digit if necessary
s/^@/10/

# And continue if there are any presents left.
s/\*/&/
t count
s/!.*//
