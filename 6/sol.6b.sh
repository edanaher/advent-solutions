cat input.6 | sed 's/,/ /g; s/turn//' | awk '{for(r = $2; r <= $5; r++) { for(c = $3; c <= $6; c++) { if($1 == "toggle") { a[r][c] += 2 } else if ($1 == "on") { a[r][c]++ } else if(a[r][c] > 0) { a[r][c]-- }} }} END { for(r = 0; r < 1000; r++) { for(c = 0; c < 1000; c++) { count += a[r][c]} } print count}'