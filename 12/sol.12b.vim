" So, I was playing with jq today, but it was faster to do this "manually" in
" vim by entering the following keystrokes:
qq/:"red"<RETURN>F{d}q1000@q
" This works as follows:
" qq               Record a macro q which:
" /:"red"<RETURN>   - searches for :"red" (a value "red")
" F{                - moves the cursor to the preceeding { (beginning of object)
" d%                - and deletes from the { to its matching }, including nesting
" q                Finish recording the macro
" 1000q            And run the macro 1000 times; when the search fails, it aborts

" After running these keystrokes, we have a file in which all objects
" containing a red key have been deleted; passing it back to sol.12.sh solves
" part b
