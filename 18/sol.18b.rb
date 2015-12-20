#!/usr/bin/env ruby

state = File.readlines("input.18").map {|l| l.chomp}
puts state
puts

100.times do
  state[0][0] = '#'
  state[0][-1] = '#'
  state[-1][0] = '#'
  state[-1][-1] = '#'
  newstate = state.map { |l| l.dup}
  state.size.times do |r|
    state[0].size.times do |c|
      count = 0
      (-1..1).each do |dr|
        (-1..1).each do |dc|
          if r + dr >= 0 && r + dr < state.size &&
             c + dc >= 0 && c + dc < state[0].size &&
             state[r+dr][c+dc] == '#'
            count += 1
          end
        end
      end
      newstate[r][c] = "."
      newstate[r][c] = "#" if count == 3
      newstate[r][c] = "#" if count == 4 && state[r][c] == "#"
    end
  end
  newstate[0][0] = '#'
  newstate[0][-1] = '#'
  newstate[-1][0] = '#'
  newstate[-1][-1] = '#'
  state = newstate
  puts state
  puts
end

puts state.inject(0) { |acc, r| acc + r.scan("#").size }
