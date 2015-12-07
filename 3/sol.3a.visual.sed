# This is a bit on the slow side; about a minute for my 8k input.
# But so cute!

# Initialize the board
s/$/|___|_@_|___|/

:loop
# Move Santa left or right
s/^\(>[^@]*\)@./\1*@/
s/^\(<[^@]*\).@/\1@*/

# Move Santa down
/^v/ {
  s/|\([^|@]*\)@\([^|]*\)|/|#\1@\2|#/
  :downloop
  /#@/ b downfound
  s/#\(.\)/\1#/g
  b downloop
  :downfound
  s/#@\([^#]*\)#./*\1@/
}

# Move Santa up
/^\^/ {
  s/|\([^|@]*\)@\([^|]*\)|/#|\1@\2#|/
  :uploop
  /@#/ b upfound
  s/\(.\)#/#\1/g
  b uploop
  :upfound
  s/.#\([^@]*\)@#/@\1*/
}

# Print this move
h; s/^\(.\).*/\1/; p; g
# Remove the movement indicator
s/^[v^<>]//

# Add another empty row on the top if necessary
s/^\([^|]*\)|\([^|@]*\)@\([^|]*\)/\1|\2_\3|\2@\3/

# Add another empty row on the bottom if necessary
s/^\(.*|\)\([^|@]*\)@\([^|]*|\)$/\1\2@\3\2_\3/

# Add another empty column on the left or right if necessary
/|@/ s/|\(.\)/|_\1/g
/@|/ s/\([_*@]\)|/\1_|/g

# Save state, remove remaining moves, print board, and restore
h
s/^[v^<>]*//
s/|/\
/g
p
g

/^[v^<>]/ b loop

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
