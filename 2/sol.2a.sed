# Build up the addition and multiplication tables before the first line
1 {
  x
  s/^/\&buildaddtable ^/
}
:begin
1 {
  /^&buildaddtable/ {

    # Save the actual input to the hold buffer
    # Build up a digit addition table
    # Start with increment/decrement table
    s/\^/^#0123456789@A/
    # And add the current pair we're adding:
    s/\^/^00;/

    :compute_digit_sum
    # Copy the pair we're checking...
    s/\^\([0-9]\)\([0-9]\);/^\1\2;\1,\2;/

    # If the first one isn't zero, decrement it add one to the second and loop
    :decrement_increment
    /;0/! {
      s/;\([0-9]\)\(,[^;]*;[^A]*\([^A]\)\1\)/;\3\2/
      s/,\([_0-9]*\)\([0-9]\)\(;[^A]*\2\([^A]\)\)/,\1\4\3/
      s/,@;/,_0;/
      b decrement_increment
    }

    # Now save the second one as the sum, and remove the working space
    s/\^\([^;]*\);0,\([_0-9]*\);\(.*\)$/^\1;\3\1=\2,/

    # Increment the second number with carry onto the first
    s/\([0-9]\)\(;[^A]*\1\(.\)\)/\3\2/
    s/\([0-9]\)@\(;[^A]*\1\(.\)\)/\30\2/
    # And if we're not just past 99, loop around again.
    /\^@0/! b compute_digit_sum

    # Clear out working space for building addition table
    s/\^[^;]*/^/
    # And set up the next operation
    s/^&buildaddtable \^/\&add(\&add(76,19123),\&add(1001,2))/
    p
  }
}

/&add([0-9]*,[0-9]*)/ {
  # Add position markers
  s/&add(\([0-9]*\),\([0-9]*\))/\&add(\1-,\2-)/
  :add_numbers
  /&add(-[_0-9]*,-[_0-9]*)/! {
    # If one number ran out of digits, add a 0
    s/(-/(0-/
    s/,-/,0-/
    # Replace the right active digit with the sum and move both dashes left
    s/\([0-9]\)-\([^-]*\)\([0-9]\)-\([^A]*A.*\1\3=\([^,]*\)\)/-\1\2-\5\4/
    b add_numbers
  }
  s/&add(-[_0-9]*,-\([_0-9]*\))/\&carry(\1)/
  p
}


/&carry([_0-9]*)/ {
  :do_carry
  /&carry([^)]*_/ {
    s/\(&carry([^)]*\)\(.\)_\([^A]*\2\(.\)\)/\1\4\3/
    s/\(&carry([^)]*\)\(.\)@\([^A]*\2\(.\)\)/\1\40\3/
    b do_carry
  }
  s/&carry(\([^)]*\))/\1/
  p
}

# If we changed anything, iterate again
t begin
p
d
# And add a negative sign if appropriate...
