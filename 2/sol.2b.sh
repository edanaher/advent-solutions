cat input.2 | awk -Fx 'function max2(a,b){if(a>b) {return a} else {return b}} function max(a,b,c) { return max2(max2(a,b),c) } {x+=2*($1+$2+$3-max($1,$2,$3))+$1*$2*$3} END {print x}'
