#!/usr/bin/env ruby

def toint(s)
  return s.to_i if s=~/^[0-9]*$/
  return s
end

gates = STDIN.each_line.map { |s|
  parts = s.split(" ")
  if parts[0] == "NOT"
    next [parts[3], ["NOT", toint(parts[1])]]
  end
  if parts[1] == "->"
    next [parts[2], ["GET", toint(parts[0])]]
  end
  [parts[4], [parts[1], toint(parts[0]), toint(parts[2])]]
}

gates = Hash[gates]
puts gates.inspect

results = {}
loop do
  gates.each do |v, e|
    next unless e.is_a? Array
    if e[0] == "NOT" || e[0] == "GET"
      if e[1].is_a? Integer
        gates[v] = e[1]
        gates[v] = (1<<16) - 1 - e[1] if e[0] == "NOT"
      elsif gates[e[1]].is_a? Integer
        gates[v] = gates[e[1]]
        gates[v] = (1<<16) - 1 - gates[e[1]] if e[0] == "NOT"
      end
      next
    end
    if (e[1].is_a?(String) && gates[e[1]].is_a?(Array)) ||
       (e[2].is_a?(String) && gates[e[2]].is_a?(Array))
      next
    end
    if e[1].is_a?(Integer)
      v1 = e[1]
    else
      v1 = gates[e[1]]
    end
    if e[2].is_a? Integer
      v2 = e[2]
    else
      v2 = gates[e[2]]
    end

    case e[0]
    when "AND"
      gates[v] = v1 & v2
    when "OR"
      gates[v] = v1 | v2
    when "LSHIFT"
      gates[v] = (v1 << v2) & 0xFFFF
    when "RSHIFT"
      gates[v] = (v1 >> v2) & 0xFFFF
    end
  end
  puts gates["a"].inspect
end
