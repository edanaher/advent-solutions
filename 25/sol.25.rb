#!/usr/bin/env ruby


row, col = File.readlines("input.25")[0].scan(/\d+/).map { |i| i.to_i }
puts row, col

#row = 800
#col = 800
diagonal = row + col - 2
diagstart = diagonal * (diagonal + 1) / 2
item = diagstart + col - 1
puts diagonal, diagstart, item

base = 20151125
multiplier = 252533
modulo = 33554393

n = base
item.times do |d|
  n = (n * multiplier) % modulo
end
puts n
