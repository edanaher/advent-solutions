cat input.3 | grep -o . | awk 'BEGIN { dx[">"] = 1; dx["<"] = -1; dy["v"] = 1; dy["^"] = -1; x=0; y=0; print x","y } { x+=dx[$1]; y+=dy[$1]; print x","y}' | sort | uniq | wc -l
