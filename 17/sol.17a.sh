cat input.17 | awk 'BEGIN { a[0] = 1 } {for(i=150; i >= $1; i--) {a[i] += a[i-$1]}} {print a[150]}'
