# This is a bit on the slow side; a bit over 2 minutes for my 8k input.
# But so cute!

# Initialize the board and who moves next
s/$/S!%|___|_$_|___|/

:loop
# Move (robot) Santa left or right.  There are a few cases to handle the two colliding...
# Right when they're currently stacked
s/^\(>[^S!]*\([S!]\)\([S!]\)%|.*\)\$./\1\3\2/
# Right onto an empty cell or present
s/^\(>[^S!]*\([S!]\)\([S!]\)%|.*\)\2[_*]/\1*\2/
# Right into the other one
s/^\(>[^S!]*\([S!]\)\([S!]\)%|.*\)\2\3/\1*$/

# And the same cases for left
s/^\(<[^S!]*\([S!]\)\([S!]\)%|.*\)[_*]\2/\1\2*/
s/^\(<[^S!]*\([S!]\)\([S!]\)%|.*\).\$/\1\2\3/
s/^\(<[^S!]*\([S!]\)\([S!]\)%|.*\)\3\2/\1$*/



## Move (robot) santa down
# If they're stacked
s/^\(v[^S!]*\([S!]\)[S!][^S!]*\)|\([^$]*\)\$\([^|]*\)|/\1|#\3$\4|#/
# If they're not stacked; no way to say not \2, so two cases
s/^\(v[^S!]*\([S]\)[S!]%[^S]*\)|\([^S]*\)S\([^|]*\)|/\1|#\3S\4|#/
s/^\(v[^S!]*\([!]\)[S!]%[^!]*\)|\([^!]*\)!\([^|]*\)|/\1|#\3!\4|#/
t downloop
:downloop
# Stacked or not stacked, plus a case for if they stack now
s/^\(v[^S!]*\([S!]\)\([S!]\)[^#]*\)#\$\([^#]*\)#./\1\3\4\2/
s/^\(v[^S!]*\([S!]\)\([S!]\)[^#]*\)#\2\([^#]*\)#\3/\1*\4$/
s/^\(v[^S!]*\([S!]\)[^#]*\)#\2\([^#]*\)#[^S!]/\1*\3\2/
t downdone
s/#\(.\)/\1#/g
t downloop
:downdone

# Move Santa up; same as down.
s/^\(\^[^S!]*\([S!]\)[S!][^S!]*\)|\([^$]*\)\$\([^|]*\)|/\1#|\3$\4#|/
s/^\(\^[^S!]*\([S]\)[S!][^S]*\)|\([^S|]*\)S\([^|]*\)|/\1#|\3S\4#|/
s/^\(\^[^S!]*\([!]\)[S!][^!]*\)|\([^!|]*\)!\([^|]*\)|/\1#|\3!\4#|/
t uploop
:uploop
s/^\(\^[^S!]*\([S!]\)\([S!]\)[^#]*\).#\([^#]*\)\$#/\1\2\4\3/
s/^\(\^[^S!]*\([S!]\)\([S!]\)[^#]*\)\3#\([^#]*\)\2#/\1$\4*/
s/^\(\^[^S!]*\([S!]\)[^#]*\)[^S!]#\([^#]*\)\2#/\1\2\3*/
t updone
s/\(.\)#/#\1/g
t uploop
:updone

# Print this move
h; s/^\(.\).*/\1/; p; g
# Remove the movement indicator
s/^[v^<>]//

# Add another empty row on the top if necessary
s/^\([^|]*\)|\([^|S!$]*\)\([S!$]\)\([^|]*\)/\1|\2_\4|\2\3\4/

# Add another empty row on the bottom if necessary
s/^\(.*|\)\([^|S!$]*\)\([S!$]\)\([^|]*|\)$/\1\2\3\4\2_\4/

# Add another empty column on the left or right if necessary
t resetcondleft
:resetcondleft
s/|[S!]/&/
t addleft
b checkright
:addleft
s/|\(.\)/|_\1/g

:checkright
t resetcondright
:resetcondright
s/[S!]|/&/
t addright
b noright
:addright
s/\([_*S!]\)|/\1_|/g
:noright

# Save state, remove remaining moves, print board, and restore
h
s/^[v^<>]*[S!][S!]%//
s/|/\
/g
p
g

# Swap who moves next
s/^\([^S!]*\)\([S!]\)\([S!]\)/\1\3\2/
t resetcondfinish
:resetcondfinish

s/^[v^<>]/&/
t loop

# And now it's time to count the gifts.
# Clear out all non-gifts, and make both Santas a gift for convenience
s/^[S!][S!]%//
s/[$S!]/*/g
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
