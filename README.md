Advent of Code Solutions for Speed and Sed (and more!)
======================================================

These are some fun solutions to [advent of code](http://adventofcode.com/).  So far (day 11), the .sh or .rb ones are my initial solutions (shell script "one-liners").  These are meant to be quick and dirty, using whatever tool seems easiest.  Notably, on day 5 some quick grepping got me the fastest time of 1:59, and some judiciously applied sed, wc -c, and bash arithmetic got me the day 8 best time of 4:34.

Then, since these are just the right level of difficulty, I'm doing some in pure sed.  This is particularly interesting because sed doesn't have any notion of numbers, so arithmetic is interesting.  If you want to run them, use something along the lines of
```bash
sed -f sol.__.sed input_file
```

In particular, day 2 is a pure arithmetic problem, implemented using some clever ideas (more or less stolen from things I've seen over the past few years).  If you think that sed is only good for `s/old/new/`, I highly recommend taking a look at it.

The sed solutions have generally been tested with BSD sed and GNU sed on OS X, as well as GNU sed on Linux.

Day 2 also now has a (mostly) [jq](https://stedolan.github.io/jq/) solution, using sed to convert to Javascript, and jq to do the math.  Hopefully more are coming...
