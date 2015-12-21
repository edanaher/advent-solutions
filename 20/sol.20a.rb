#!/usr/bin/env ruby

target = ARGV[0].to_i / 10

(1..1000000).each do |i|
  presents = 0 
  sqrt = Math.sqrt(i).floor
  (1..sqrt).each do |f|
    next unless i % f == 0
    presents += f + i / f
  end
  presents -= sqrt if i == sqrt * sqrt
  if presents >= target
    puts "#{i} #{presents}" 
    exit 
  end
end
