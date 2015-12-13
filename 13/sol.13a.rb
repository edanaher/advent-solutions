#!/usr/bin/env ruby


lines = File.readlines("input.13")

people = {}
lines.map do |line|
  comps = line.split " "
  p1, pm, val, p2 = comps[0], comps[2], comps[3], comps[10]
  next unless p1
  val = val.to_i
  val = -val if pm == "lose"
  p2 = p2[0..p2.size - 2]
  people[p1] ||= {}
  people[p1][p2] = val
end
puts people["Alice"].inspect

$people = people

$best = -9999999
def buildTable(table)
  people = $people
  if table.size == people.size
    happiness = 0
    (people.size-1).times do |i|
      happiness += people[table[i]][table[i+1]]
      happiness += people[table[i+1]][table[i]]
    end
    happiness += people[table[table.size-1]][table[0]]
    happiness += people[table[0]][table[table.size-1]]
    if happiness > $best
      $best = happiness
      puts table.inspect
    end
    return
  end
  people.keys.each do |p|
    next if table.include?(p)
    table << p
    buildTable(table)
    table.pop
  end
end

buildTable([])
  puts $best
