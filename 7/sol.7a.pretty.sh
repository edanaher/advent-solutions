# Idea: use sed to convert the input to awk expressions.  Rather than
# converging, do a (stupid) topological sort so top-to-bottom execution works.
{
  # Add the awk header
  echo 'BEGIN { '
  # Take the input...
  cat input.7 |
    # and convert two-op, NOT, and dumb assignment to awk forms...
    sed 's/\([a-z0-9]*\) \([A-Z]*\) \([a-z0-9]*\) -> \([a-z]*\)/\4=\2(\1,\3)/;
         s/NOT \([0-9a-z]*\) -> \([a-z]*\)/\2=65535-\1/;
         s/\([0-9a-z]*\) -> \([a-z]*\)/\2=\1/' |
    # lowercase everything since awk uses lowercase...
    tr '[A-Z]' '[a-z]' |
    # And awk doesn't like variables called do, if, or in, so append "not" to those.
    sed 's/$/;/; s/\<\(do\|if\|in\)\>/\1not/g'
  # Now add the awk footer to print a.
  echo 'print a}';
} |
# Now take all of that, and topological sort.  Do it stupidly, by looking for variables that are used before they're assigned, and move the assignment before the use.
sed -n 'H; # Append all lines to the hold space
$ { # On the last line...
  g # Pull out the hold space so we have the whole input.
  :loop 
  # Look for a line containing a variable, followed by an assignment to that variable,
  # and put the assignment at the top.
  s/\([^\n]*\<\([a-z]\+\)\>.*\n\)\(\2=[^;]*;\n\)/\3\1/g
  t loop
  p
}' |
# Now we have our full awk script, so just run it.
awk -f -
