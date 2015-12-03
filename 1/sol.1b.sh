cat input.1 | grep -o . | awk '/\(/ {x+=1} /\)/ {x-=1; if(x<0)print NR}' | head -n1
