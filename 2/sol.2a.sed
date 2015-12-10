# Build up the addition and multiplication tables before the first line
1 {
# Save the actual input to the hold buffer
x
# Build up a digit addition table
# Start with increment/decrement table
s/^/#0123456789@a/
# And add the current pair we're adding:
s/^/00|/

:compute_digit_sum
# Copy the pair we're checking...
s/^\([0-9]\)\([0-9]\)|/\1\2|\1,\2|/

# If the first one isn't zero, decrement it add one to the second and loop
:decrement_increment
/|0/! {
  s/|\([0-9]\)\(,[^|]*|[^a]*\([^a]\)\1\)/|\3\2/
  s/,\([_0-9]*\)\([0-9]\)\(|[^a]*\2\([^a]\)\)/,\1\4\3/
  s/,@|/,_0|/
  b decrement_increment
}

# Now save the second one as the sum, and remove the working space
s/^\([^|]*\)|0,\([_0-9]*\)|\(.*\)$/\1|\3\1=\2,/

# Increment the second number with carry onto the first
s/\([0-9]\)\(|[^a]*\1\(.\)\)/\3\2/
s/\([0-9]\)@\(|[^a]*\1\(.\)\)/\30\2/

}
# And if we're not just past 99, loop around again.
/^@0/! b compute_digit_sum

# Clear out working space for building addition table
s/^[^|]*//

# Demo adding two numbers
s/^/5,1999995/

# Pad the numbers to the same length
s/^\([0-9]*\),\([0-9]*\)/\1-,\2-/

:add_numbers
/^-[0-9]*,-/! {
  # If one number ran out of digits, add a 0
  s/^-/0-/
  s/,-/,0-/
  # Replace the right active digit with the sum and move both dashes left
  s/\([0-9]\)-\([^-]*\)\([0-9]\)-\([^a]*a.*\1\3=\([^,]*\)\)/-\1\2-\5\4/
  b add_numbers
}
s/-//g
:do_carry
p
/^[0-9]*,[^|]*[_@]/ {
  s/^\([^|]*\)\(.\)_\([^|]*|[^a]*\2\(.\)\)/\1\4\3/
  s/^\([^|]*\)\(.\)@\([^|]*|[^a]*\2\(.\)\)/\1\40\3/
  b do_carry
}


p
d
# And add a negative sign if appropriate...
