s/^/________________________________________/
# Uncomment the following to add ten more iterations for part b
#s/^/__________/

# Use letters in the substitutions to avoid double-substitutes in a single
# iteration (e.g., ...3111... => ...331... => ...231...)
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
# Subtract one from the unary counter
s/^_//
# And loop if the counter is nonempty
/^_/ b subst

# This is a much simpler and incredibly faster way to count; just divide by 10,
# convert the remainder to a number, and repeat until it converges.
s/./_/g

:count
# Divide by 10 (- is the unary quotient; _ is the unary remainder)
s/__________/-/g
# Now replace the remainder with its decimal digit.
s/_________/9/
s/________/8/
s/_______/7/
s/______/6/
s/_____/5/
s/____/4/
s/___/3/
s/__/2/
s/_/1/
# If there is no remainder, add a zero.
s/-$/-0/
# And swap the quotient in as the new dividend.
s/-/_/g
# If there are any unary digits left, repeat.
/_/ b count
