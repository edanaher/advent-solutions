#!/usr/bin/env ruby

lines = File.readlines("input.9").map {|x| x.chomp}

$dists = {}
lines.each do |line|
  line =~ /^([^ ]*) to ([^ ]*) = ([0-9]*)$/
  $dists[$1] ||= {}
  $dists[$1][$2] = $3.to_i
  $dists[$2] ||= {}
  $dists[$2][$1] = $3.to_i
end

$min = 0
def buildRoutes(route)
  if route.length == $dists.size
    dist = 0
    ($dists.size - 1).times do |i|
      dist += $dists[route[i]][route[i+1]]
    end
    if dist > $min
      $min = dist
      puts route.inspect, $min
    end
  end
  $dists.keys.each do |c|
    next if route.include? c
    route << c
    buildRoutes(route)
    route.pop
  end
end

buildRoutes([])
puts $min
