# Initialize counter and table in hold space on the first line
1 {
  x
  s/^/0!#0123456789@|/
  x
}

# Put the line in hold space, then append to the count/table without the newline.
x; G; s/\n//

# And add one for each character
t countoriglength
:countoriglength
/|$/ b escapestring
# Add one to a positive
s/^\([0-9]*\)\([0-9]\)!\([^|]*\2\(.\)\)/\1\4!\3/
# Add one to a negative
s/^\(-[0-9]*\)\([0-9]\)!\([^|]*\(.\)\2\)/\1\4!\3/
t carryadd
:carryadd
s/^\(-*\)@/\110/
s/^\([^!]*\)\(.\)@\([^!]*![^|]*\2\(.\)\)/\1\40\3/
s/^\([^!]*\)\(.\)#\([^!]*![^|]*\(.\)\2\)/\1\49\3/
s/^-0\([^!]\)/-\1/
s/^-0!/0!/
s/^0\([^!]\)/\1/
t carryadd

s/|./|/
b countoriglength

:escapestring
# Now put the string back and escape it.
G; s/\n//
s/\\\([\\"]\)/_/g
s/\\x[0-9a-f][0-9a-f]/_/g
s/"$//
s/|"/|/

# Now subtract one for each escaped character...
:countescapedlength
/|$/ b nextline
# Subtract one from a positive
s/^\([0-9]*\)\([0-9]\)!\([^|]*\(.\)\2\)/\1\4!\3/
# Subtract one from a negative
s/^\(-[0-9]*\)\([0-9]\)!\([^|]*\2\(.\)\)/\1\4!\3/
t carrysub
:carrysub
s/^\(-*\)@/\110/
s/^\([^!]*\)\(.\)@\([^!]*![^|]*\2\(.\)\)/\1\40\3/
s/^\([^!]*\)\(.\)#\([^!]*![^|]*\(.\)\2\)/\1\49\3/
s/^#/-1/
s/^-0!/0!/
s/^0\([^!]\)/\1/
t carrysub

s/|./|/
b countescapedlength

:nextline
# And finally, save the counter and table back for the next line
x
$! d
# On the last line, print the count
x
s/!.*//
