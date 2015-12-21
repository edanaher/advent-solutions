#!/usr/bin/env ruby

shop = File.readlines("shop.21").map { |l| l.scan(/ [0-9]+/).map { |i| i.to_i } }.select { |l| !l.empty? }
weapons = shop[0..4]
armor = shop[5..9] + [[0, 0, 0]]
rings = shop[10..16] + [[0, 0, 0], [0, 0, 0]]

puts weapons.inspect
puts armor.inspect
puts rings.inspect

enemy = File.readlines("input.21").map { |l| l.scan(/[0-9]+/)[0].to_i }

puts enemy.inspect

best = 0

weapons.each do |w|
  armor.each do |a|
    rings.size.times do |r1|
      rings.size.times do |r2|
        next if r1 == r2
        items = [w, a, rings[r1], rings[r2]]
        stats = items.inject { |a, b| [a[0] + b[0], a[1] + b[1], a[2] + b[2]] }
        turns = (100 / [enemy[1] - stats[2], 1].max).floor
        damage = turns * ([stats[1] - enemy[2], 1].max)
        puts "#{stats.join(" ")} #{w.inspect} #{a.inspect} #{r1} #{r2} #{items.inspect} #{turns} #{damage}"
        if damage < enemy[0]
          if stats[0] > best
            best = stats[0]
          end
        end
      end
    end
  end
end
puts best
