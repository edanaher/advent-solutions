{ cat input.1 | sed 's/)//g' | wc -c; cat input.1 | sed 's/(//g' | wc -c; echo -p; } | dc
