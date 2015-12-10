#!/usr/bin/env ruby

str = STDIN.read.chomp

40.times do
  # Why is scan braindead?  If you don't have any matches, it returns the whole
  # string.  If you have any matches, it *stops returning the whole string* and
  # instead returns only the matches.  So you have to have a match over the whole
  # string for Ruby in order to get it.
  # Or you can give up trying to figure this out after about two minutes and
  # use sed to preprocess it, and just accept that you'll get an embarrassingly
  # slow time.
  splitted = str.scan(/((.)\2*)/)
  str = splitted.map { |s,_| "#{s.length}#{s[0]}" }.join ""
end
puts str.length

