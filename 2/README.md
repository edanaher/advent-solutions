Day 2 - real programming in sed!
================================

My other sed solutions so far have been vaguely reasonable; do some string munging, and maybe some counting.  The string munging makes sense, and the counting isn't too hidous.

But sed has no notion of numbers, and this problem is pure arithmetic.  So I effectively implemented a language that implements arithmetic with two main tricks: tables and "functions".

Arithmetic tables
-----------------
Incrementing uses a simple table: `#0123456789@`.  To increment a number, do a regex match on the ones digit with its occurrence later in the table, and grab the next digit; using a pipe as a delimiter between the number and table, the result is something along the lines of `s/\(.)\(|.*\1\(.\)\)/\3\2/`.  Then, to handle carries, replace a digit followed by @ with its own next digit: `s/\(.\)@\(.*|\1\(.\))/\30\1/`, and use the t (test) sed function to loop this as long as substitutions are occurring.

Of course, this is is slightly more complicated if there are other things in the string beyond the number to increment and the table, but it's just a matter of being careful (e.g., instead of .* after the pipe, use [^@]* to ensure that the match comes from the table, not something later).

Now we could do addition by repeated increment/decrement, but that would be slow.  So instead, we build the addition table over the digits, along the lines of `00=0,01=1,02=2,...,56=_1,57=_2,...`, using _ for the ones place to simplify carries.  This table is built up programmatically, by iterating over each pair, and using the increment/decrement approach on a copy of the pair until one of them is zero, then saving the result.

To use this table, for multi-digit addition, we iterate over each corresponding pair of digits in the inputs using a rolling cursor: adding 123,458 goes as follows:

```
123-,458-
12-3,45-_1
1-23,4-7_1
-123,-57_1
123,57_1
```

Now we just have to deal with the carries, which is fundamentally the same as carrying @ in increment above, except no additional 0 is added.

Multiplication is similar; we build a table for each pair of digits.  This is more complex, since it's a double loop.  So we first implement multiplication of a number by a digit.  This is slightly nontraditional, going left to right, and multiplying the result so far by 10.  But if you stare at the code, it's reasonably straightforward.

Finally, with digit by number multiplication done, multiplying two numbers is just a matter of multiplying one number by each digit of the first, and multiplying by ten at each step.  Shockingly simple.

Functions
---------

Clearly, implementing all of this as straight-line code is a nightmare, let alone the fact that each line of input requires several multiplies and adds.  However, I remembered the idea behind [SedChess](https://github.com/bolknote/SedChess) of using a marker to indicate the next operation to take, effectively building a state machine which can be used to chain operations together.

While trying to figure out the best way to handle arguments, I realized that would effectively be building a stack machine; why not just use ordinary functions instead to keep things easy to reason about?  Sure enough, function reduction is straightforward in sed: just check to see if there's an occurrence of the function whose arguments are numbers, and if so, reduce it.  For example, the increment function:
```
/&inc([0-9]*)/ {
  s/&inc(\([0-9]*\)\([0-9]\))\([^A]*\2\(.\)\)/\&carry(\1\4)\3/
  #p
}
```
If it finds an occurrence of `&inc([0-9])`,it uses the basic idea from above (using [^A]* to ensure that we don't go past the increment table, since A is used to delimit the start of the addition table) to replace the units digit of its argument with that value plus one, then it replaces its whole expression with a call to &carry with the incremented number.  Then, later in the program, &carry will match this subexpression and ripple-carry until no more @'s remain, and replace its own call with the final carried number.

And then, as long as any substitution occurs, the `t begin` at the end of the program will loop back to the beginning of the program, and search for more reductions.  Note that this means that we can't use any other `t` commands in the program, since they would reset the test condition, potentially resulting in early termination if no other substitutions occur in the remainder of that iteration.  Fortunately, we can loop by branching at the end of the loop to a label just before the start of the loop, with the body of the loop in a conditional:

```
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
  #p
}
```

If there are any @'s or _'s in carry's argument, this will do a round of carrying, and then branch back to do_carry and check again.

Things that Just Work
---------------------
One concern might be that multiple reductions can happen in a single iteration, and they might stomp on each other.  But by being careful to complete each reduction in this block, that's fine!  All reductions are fully local referentially transparent, only affecting themselves, so order doesn't matter.

Also, it's very convenient to have a p at the end of each block.  In fact, several blocks could be run unconditionally, but printing after each reduction makes it very clear what's going on and how we got to the current state.  This made debugging much easier, and there was an annoying amount of that.

Tricky bits
-----------
We do have to be careful to only reduce functions whose arguments are fully evaluated; trying to evaluate the `min` in `&min(&add(1,2),3)` would fail.  So the checks for evalution need to be careful that their arguments are numbers (or numbers with @ and _, in the case of carrying).

Also, since there can be multiple occurrences of an operator, we need to carefully match the arguments to avoid picking up the wrong one.  For example, checking if the second argument is shorter in min might be done as `s/\&min([^-][^,]*,-\([0-9]*\))/\2` (that is, if the cursor on the second argument hit the start and the first one didn't, replace the min expression with the second argument).  But consider its effect on `\&min(\&min(1,2),3)`.  The *outer* min matches this expression, so we end up reducing it to `1,3)`, which will cause havok down the line.  A solution is to be more precise on the first argument: s/\&min([^-][^0-9-]*,-\([0-9]*\))/\2`.

Finally, we need to be careful to keep branches within a function exclusive.  The final bug I had was on minaux, which repeatedly decrements the first digit of each number until either one of them has a leading zero or they're both empty, and dropping the leading digit if they're both zero.

Unfortunately, I figured that since I'd already checked for both having a leading zero at the top of the function, I could assume that at most one of them had a leading zero below.  In particular, if one has a leading zero, the min immediately reduces to that, so any minaux left at the end can unconditionally decrement the first two digits.  This fails if both numbers have *two* leading zeros; only one will be trimmed.  So again we have to be careful to only decrement them if they're both non-zero.

Conclusion
----------
Writing real programs in sed is clearly silly, but a good exercise in lateral thinking.  While it was designed for the sole purpose of string manipulation, not arithmetic, I find that trying to bend it to solve problems outside that domain is far more fun that writing yet another brainf\*ck or Intercal program.  Those were designed to be weird to write in; with sed, doing arithmetic wasn't even considered, so it's even more satisfying.

And shockingly, this isn't too painfully slow!  There's probably room for optimization, but as is it takes under 30 seconds for 1000 lines of input, which isn't terrible.
