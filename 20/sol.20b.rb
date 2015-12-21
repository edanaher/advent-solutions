#!/usr/bin/env ruby

target = ARGV[0].to_i / 11

MAX = 1000000
presents = []
(1..MAX).each do |i|
  50.times do |j|
    break if i*j > MAX
    presents[i*j] ||= 0
    presents[i*j] += i
  end
  if presents[i] >= target
    puts "#{i} #{presents[i]}" 
    exit 
  end
end


