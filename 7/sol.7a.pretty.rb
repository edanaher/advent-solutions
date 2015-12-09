#!/usr/bin/env ruby

gates = STDIN.each_line.map do |s|
  parts = s.split(" ")
  if parts[0] == "NOT"
    next [parts[3], "NOT", parts[1]]
  elsif parts[1] == "->"
    next [parts[2], "GET", parts[0]]
  end
  [parts[4], parts[1], parts[0], parts[2]]
end

values = {}
# Annoyingly, locals aren't available inside functions, so alias it globally.
$values = values

# Convert an int or register to value; if the register is unknown,
# conveniently return nil.
def toint(s)
  return s.to_i if s=~/^[0-9]*$/
  return $values[s]
end

# Table of operations
# Unary operations take two arguments for convenience.
ops = {
  "NOT" => ->(v, _) { 0xFFFF - v },
  "GET" => ->(v, _) { v },
  "AND" => ->(v1, v2) { v1 & v2 },
  "OR" => ->(v1, v2) { v1 | v2 },
  "LSHIFT" => ->(v1, v2) { v1 << v2 },
  "RSHIFT" => ->(v1, v2) { v1 >> v2 },
}

# Now keep updating more and more values until we figure out a.
results = {}
until values["a"]
  gates.each do |v, op, e1, e2|
    next if values[v]  # Skip ones we've already done.
    v1 = toint(e1)
    v2 = toint(e2)
    next unless v1 && (!e2 || v2) # Skip ones whose arguments aren't done yet.

    values[v] = ops[op][v1, v2]
  end
end
puts values["a"]
