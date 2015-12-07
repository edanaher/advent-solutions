Blech...  I resorted to Ruby, and this is quick and dirty.  Run it through head -n1000 or so to let it converge.  And for part b, just change the input file to assign it to b, and rerun.

And this was an attempt to be as quick as possible; the problem wasn't quite ugly enough to justify time spent on niceties like mapping names to functions or cleanly handling single-operand operations.

And after another 45 minutes, I've got a cute (but very slow) solution which uses (primarily) sed to convert the input into a form that can be passed directly to awk.
