Day 19: A fun problem
=====================
So, part b of this one is actually interesting.  I first tried naive brute force since it only took a couple minutes to write, but it'll clearly never actually finish.  Next up was reversing the process; deconstructing the string by reversing substitutions.  Sadly, this will still incredibly infeasible, even with some simple optimizations.

More thoughts around "forced" substitutions didn't come up with anything I felt like implementing, and I can't convince myself they're correct.  Then ordering turned up in my head - there must always be a substitution in the first 10 characters or so.  But that's false; there could be a prefix whose last element needs to be substituted in.  But sure enough, doubling this length resulted in a solution that finished quickly and gave the right answer on my input (and indeed, it should work on nearly all generated input; it would take a rather antagonistic chain to block this.

This makes me sad, because I'd like to sit down with some good techniques (e.g., simplifications that can't need backtracking, combining multiple steps into a single one to decrease depth at the expense of fanout), but now it's slightly harder to justify the time.

So overall time to completion (without time pressure, since I'm back on the east coast and don't want to stay up until midnight) was just under an hour and fourteen minutes, good for roughly 40th place on the leaderboard.

