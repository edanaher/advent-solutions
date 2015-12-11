# Build up the addition and multiplication tables before the first line
1 {
  x
  s/^/\&buildaddtable /
}
:begin
1 {
  # TODO(edanaher): This is monolithic so can't use outside functions.  Fix that.
  /^&buildaddtable/ {

    # Save the actual input to the hold buffer
    # Build up a digit addition table
    # Start with increment/decrement table
    s/ / #0123456789@A/
    # And add the current pair we're adding:
    s/ / 00;/

    :compute_digit_sum
    # Copy the pair we're checking...
    s/ \([0-9]\)\([0-9]\);/ \1\2;\1,\2;/

    # If the first one isn't zero, decrement it add one to the second and loop
    :decrement_increment
    /;0/! {
      s/;\([0-9]\)\(,[^;]*;[^A]*\([^A]\)\1\)/;\3\2/
      s/,\([_0-9]*\)\([0-9]\)\(;[^A]*\2\([^A]\)\)/,\1\4\3/
      s/,@;/,_0;/
      b decrement_increment
    }

    # Now save the second one as the sum, and remove the working space
    s/ \([^;]*\);0,\([_0-9]*\);\(.*\)$/ \1;\3\1=\2,/

    # Increment the second number with carry onto the first
    s/\([0-9]\)\(;[^A]*\1\(.\)\)/\3\2/
    s/\([0-9]\)@\(;[^A]*\1\(.\)\)/\30\2/
    # And if we're not just past 99, loop around again.
    / @0/! b compute_digit_sum

    # Clear out working space for building addition table
    s/ [^;]*/ /
    # And set up the next operation
    s/^&buildaddtable /\&buildmulttable 00/
    p
  }

  # If the first digit is 0, save the result and increment the current number
  /&buildmulttable [0-9][0-9] 0,[0-9]*;/ {
    s/\([0-9][0-9]\) 0,\([0-9]*\)\(;.*\)$/\1\3\1=\2,/
    s/ \([0-9][0-9]\)/ \&inc(\1)/
    p
  }

  # If the first digit isn't zero, add another increment of the second digit
  # and decrement the first digit
  /&buildmulttable [0-9][0-9] [^0],[0-9]*;/ {
    s/\([0-9]\)\([0-9]\) \([0-9]\),\([0-9]*\)/\1\2 \&dec(\3),\&add(\4,\2)/
    p
  }

  /&buildmulttable [0-9][0-9];/ {
    # Append the M on the first entry
    /M/! s/$/M/

    # Copy the active digits to the working space
    s/ \([0-9]\)\([0-9]\)/& \1,0/
    p
  }

  # If we're up to 100, we're done building the table; move on!
  /&buildmulttable 100/ {
    # Clean out the header so only the table is left
    s/&buildmulttable 100[^;]*;/\&min(1234,1234)/
    p
  }

}

/&multiplydigits([0-9],[0-9])/ {
  s/&multiplydigits(\([0-9]\),\([0-9]\))\([^M]*M.*\1\2=\([0-9]*\),\)/\4\3/
  p
}

/&multiplydigit([0-9],[0-9]*)/ {
  s/&multiplydigit(\([0-9],[0-9]*\))/\&multiplydigitacc(\1,0)/
  p
}

/&multiplydigitacc([0-9],[0-9][0-9]*,[0-9]*)/ {
  s/&multiplydigitacc(\([0-9]\),\([0-9]\)\([0-9]*\),\([0-9]*\))/\&multiplydigitacc(\1,\3,\&add(\40,\&multiplydigits(\1,\2)))/
}
s/&multiplydigitacc([0-9],,\([0-9]*\))/\1/

/&multiply([0-9]*,[0-9]*)/ {
  s/multiply(\([0-9]*,[0-9]*\))/multiplyacc(\1,0)/
  p
}

/&multiplyacc([0-9][0-9]*,[0-9]*,[0-9]*)/ {
  s/&multiplyacc(\([0-9]\)\([0-9]*\),\([0-9]*\),\([0-9]*\))/\&multiplyacc(\2,\3,\&add(\40,\&multiplydigit(\1,\3)))/
  p
}
s/&multiplyacc(,[0-9]*,0*\([0-9]*\))/\1/

/&add([0-9]*,[0-9]*)/ {
  # Add position markers
  s/&add(\([0-9]*\),\([0-9]*\))/\&add(\1-,\2-)/
  :add_numbers
  /&add(-[_0-9]*,-[_0-9]*)/! {
    # If one number ran out of digits, add a 0
    s/(-/(0-/
    s/,-/,0-/
    # Replace the right active digit with the sum and move both dashes left
    s/\([0-9]\)-\([^-]*\)\([0-9]\)-\([^A]*A[^M]*\1\3=\([^,]*\)\)/-\1\2-\5\4/
    b add_numbers
  }
  s/&add(-[_0-9]*,-\([_0-9]*\))/\&carry(\1)/
  p
}

/&inc([0-9]*)/ {
  s/&inc(\([0-9]*\)\([0-9]\))\([^A]*\2\(.\)\)/\&carry(\1\4)\3/
  p
}

/&dec([0-9]*)/ {
  # TODO: borrow
  s/&dec(\([0-9]*\)\([0-9]\))\([^A]*\(.\)\2\)/\1\4\3/
  p
}

/&carry([_0-9@]*)/ {
  :do_carry
  /&carry([^)]*[_@]/ {
    s/&carry(\([_@]\)/\&carry(0\1/
    s/\(&carry([^)]*\)\(.\)_\([^A]*\2\(.\)\)/\1\4\3/
    s/\(&carry([^)]*\)\(.\)@\([^A]*\2\(.\)\)/\1\40\3/
    b do_carry
  }
  s/&carry(@\([^)]*\))/\&carry(10\1)/
  s/&carry(\([^)]*\))/\1/
  p
}

/&min([0-9]*,[0-9]*)/ {
  # If one side is shorter, choose that one, otherwise go to minaux
  s/&min(\([0-9]*\),\([0-9]*\))/\&min(\1-,\2-)/
  :count_digits_min
  /-/ {
    s/\(.\)-/-\1/g
    s/\&min(-\([0-9]*\),-\([0-9]*\))/\&minaux(\1,\2,\1,\2)/
    s/\&min(-\([0-9]*\),[^)]*)/\1/
    s/\&min([^,]*,-\([0-9]*\))/\1/
    b count_digits_min
  }
  p
}

# The inputs are both the same length at this point. \1,\2 are the working set,
# \3,\4 are the original numbers
/&minaux([0-9]*,[0-9]*,[0-9]*,[0-9]*)/ {
  s/&minaux(0\([0-9]*\),0\([0-9]*\)\([^)]*)\)/\&minaux(\1,\2\3/
  # If both sides have leading zeros, trim and continue
  s/&minaux(0\([0-9]*\),0\([0-9]*\)\([^)]*)\)/\&minaux(\1,\2\3/
  # If both sides are empty, they're equal, so just pick one.
  s/&minaux(,,\([0-9]*\),[0-9]*)/\1/
  # If only one side has a leading zero, it's smaller
  s/&minaux(0[0-9]*,[^0][0-9]*,\([0-9]*\),[0-9]*)/\1/
  s/&minaux([^0][0-9]*,0[0-9]*,[0-9]*,\([0-9]*\))/\1/
  # Otherwise, decrement both first digits
  s/&minaux(\([0-9]\)\([0-9]*\),\([0-9]\)\([^)]*)\)/\&minaux(\&dec(\1)\2,\&dec(\3)\4/
  p
}

# If we changed anything, iterate again
t begin
p
