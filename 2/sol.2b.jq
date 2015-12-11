cat input.2 | sed 's/x/,/g; s/^/[/ ;s/$/]/' | jq '.[0]*.[1]*.[2] + 2*(.[0]+.[1]+.[2] - max)' | jq -s add
