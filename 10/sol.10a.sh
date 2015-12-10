i=`cat input.10`; echo $i; for c in {1..40}; do i=`echo $i | sed 's/\(.\)\1*/&_/g' | ruby -e 'puts STDIN.read.split("_")[0..-2].map { |s| "#{s.length}#{s[0]}" }.join("")'`; echo -n $i | wc -c; done
