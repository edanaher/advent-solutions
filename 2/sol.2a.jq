cat input.2 | sed 's/x/,/g; s/^/[/ ;s/$/]/' | jq '[.[0]*.[1], .[0]*.[2], .[1]*.[2]]' | jq '2*(.[0]+.[1]+.[2])+min' | jq -s add
