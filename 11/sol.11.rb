#!/usr/bin/env ruby

p = File.read("input.11").chomp
puts p

2.times do
loop do
  p.length.times do |i|
    p[i] = p[i].next if %w{i o l}.include? p[i]
  end
  unless p =~ /(.)\1.*(.)\2/
    p = p.next
    next
  end
  good = false
  (p.length - 2).times do |i|
    good = true if p[i+1] == p[i].next && p[i+2] == p[i+1].next
  end
  if !good
    p = p.next
    next
  end
  puts p
  break
end
p = p.next
end


