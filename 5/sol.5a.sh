cat input.5 | grep '[aeiou].*[aeiou].*[aeiou]' | grep '\(.\)\1' | grep -v 'ab\|cd\|pq\|xy' | wc -l
