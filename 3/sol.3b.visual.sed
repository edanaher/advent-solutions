# This is a bit on the slow side; my 8k input now takes about 1.5 minutes on BSD sed, and something like a
# half hour on GNU sed.  Interesting.
# But it's so cute!

# Initialize the board and who moves next
s/$/S!%|___|_$_|___|/

:loop
# Move (robot) Santa left or right.  There are a few cases to handle the two colliding...
/^>/ {
  # When they're currently stacked
  /\$/ s/^\(\([S!]\)\([S!]\)%|[^$]*\)\$./\1\3\2/
  # Right onto an empty cell or present
  /[S!]/ s/^\([^S!]*\([S!]\)\([S!]\)%|.*\)\2[_*]/\1*\2/
  # Right into the other one
  /[S!]/ s/^\([^S!]*\([S!]\)\([S!]\)%|.*\)\2\3/\1*$/
}

# And the same cases for left
/^</ {
  /$/ s/^\([^S!]*\([S!]\)\([S!]\)%|.*\)[^$]\$/\1\2\3/
  /[S!]/ s/^\([^S!]*\([S!]\)\([S!]\)%|.*\)[_*]\2/\1\2*/
  /[S!]/ s/^\([^S!]*\([S!]\)\([S!]\)%|.*\)\3\2/\1$*/
}

## Move (robot) santa down
/^v/ {
  # If they're stacked
  /\$/ s/\(\([S!]\)[S!][^S!]*\)|\([^$]*\)\$\([^|]*\)|/\1|#\3$\4|#/
  # If they're not stacked; no way to say not \2, so two cases
  /S!%/ s/|\([^S|]*\)S\([^|]*\)|/|#\1S\2|#/
  /!S%/ s/|\([^!|]*\)!\([^|]*\)|/|#\1!\2|#/
  t downloop
  :downloop
  # Stacked or not stacked, plus a case for if they stack now
  /#\$/ s/^\(v[^S!]*\([S!]\)\([S!]\)[^#]*\)#\$\([^#]*\)#./\1\3\4\2/
  /#[S!]/ s/^\(v[^S!]*\([S!]\)\([S!]\)[^#]*\)#\2\([^#]*\)#\3/\1*\4$/
  /#[S!]/ s/^\(v[^S!]*\([S!]\)[^#]*\)#\2\([^#]*\)#[^S!]/\1*\3\2/
  t downdone
  s/#\(.\)/\1#/g
  t downloop
  :downdone
}

# Move Santa up; same as down.
/^\^/ {
  /\$/ s/^\(\^[^S!]*\([S!]\)[S!][^S!]*\)|\([^$]*\)\$\([^|]*\)|/\1#|\3$\4#|/
  /S!%/ s/|\([^S|]*\)S\([^|]*\)|/#|\1S\2#|/
  /!S%/ s/|\([^!|]*\)!\([^|]*\)|/#|\1!\2#|/
  t uploop
  :uploop
  /\$#/ s/^\(\^[^S!]*\([S!]\)\([S!]\)[^#]*\).#\([^#]*\)\$#/\1\2\4\3/
  /[S!]#/ s/^\(\^[^S!]*\([S!]\)\([S!]\)[^#]*\)\3#\([^#]*\)\2#/\1$\4*/
  /[S!]#/ s/^\(\^[^S!]*\([S!]\)[^#]*\)[^S!]#\([^#]*\)\2#/\1\2\3*/
  t updone
  s/\(.\)#/#\1/g
  t uploop
  :updone
}

# Print this move
h; s/^\(.\).*/\1/; p; g
# Remove the movement indicator
s/^[v^<>]//

# Add another empty row on the top if necessary
/%|[^|S!$]*[S!$]/ s/%|\([^|S!$]*\)\([S!$]\)\([^|]*\)/%|\1_\3|\1\2\3/

# Add another empty row on the bottom if necessary
/[S!$][^|S!$]*|$/ s/|\([^|S!$]*\)\([S!$]\)\([^|]*|\)$/|\1\2\3\1_\3/

# Add another empty column on the left or right if necessary
/|[S!]/ s/|\(.\)/|_\1/g
/[S!]|/ s/\([_*S!]\)|/\1_|/g

# Save state, remove remaining moves, print board, and restore
h
s/^[v^<>]*[S!][S!]%//
s/|/\
/g
p
g

# Swap who moves next
s/\([S!]\)\([S!]\)%/\2\1%/

/^[v^<>]/ b loop

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
