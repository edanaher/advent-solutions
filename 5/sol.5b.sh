cat input.5 | grep '\(..\).*\1' | grep '\(.\).\1' | wc -l
