#!/usr/bin/env ruby

$bosshp, $bossdamage  = File.read("input.22").scan(/\d+/).map(&:to_i)


def runspells(spells, debug = false)
  bosshp, bossdamage = $bosshp, $bossdamage
  hp = 50
  mana = 500
  manaspent = 0
  tick = 0
  timers = []

#  bosshp, bossdamage = 14, 8
#  hp = 10
#  mana = 250

  puts "hp: #{hp}; mana: #{mana}; bosshp: #{bosshp}; effects: #{timers[2..4].inspect}" if debug
  spells.each do |spell|
  puts "Using #{spell}" if debug

    hp -= 1
    return false if hp <= 0

    timers.size.times do | t|
      next unless timers[t]
      timers[t] -= 1
      armor = 7 if t == 2
      bosshp -= 3 if t == 3
      mana += 101 if t == 4
      timers[t] = nil if timers[t] == 0
    end
    return false if timers[spell]

    return manaspent if bosshp <= 0

    cost = [53, 73, 113, 173, 229][spell]
    mana -= cost
    manaspent += cost
    case spell
    when 0
      bosshp -= 4 
    when 1
      bosshp -= 2
      hp += 2
    when 2
      timers[2] = 6
    when 3
      timers[3] = 6
    when 4
      timers[4] = 5
    end

    puts "hp: #{hp}; mana: #{mana}; bosshp: #{bosshp}; effects: #{timers[2..4].inspect}" if debug
    return false if mana < 0
    return manaspent if bosshp <= 0

    armor = 0
    timers.size.times do | t|
      next unless timers[t]
      timers[t] -= 1
      armor = 7 if t == 2
      bosshp -= 3 if t == 3
      mana += 101 if t == 4
      timers[t] = nil if timers[t] == 0
    end

    return false if hp <= 0
    return manaspent if bosshp <= 0

    hp -= (bossdamage - armor)
    puts "hp: #{hp}; mana: #{mana}; bosshp: #{bosshp}; effects: #{timers[2..4].inspect}" if debug
    return false if hp <= 0
    return manaspent if bosshp <= 0

  end
  return :timeout
end

$best = 99999
def buildspells(sofar, len)
  res = runspells(sofar, false)
#puts "#{sofar.inspect}: #{res}"
  if len == 0
    if res && res != :timeout
#res = runspells(sofar, true)
      $best = res if res < $best
      puts "Success: #{sofar.join(" ")} => #{res} (#$best)"
#      exit
    end
    return false
  end
  return unless res == :timeout
  sofar << 0
  5.times do |i|
    sofar[-1] = i
#    preceding = sofar[-6..-2] || sofar[0..-2]
#    preceding5 = preceding.size == 6 ? preceding[2..-1] : preceding
#    next if i == 2 && preceding.include?(i)
#    next if i == 3 && preceding.include?(i)
#    next if i == 4 && preceding.include?(i)
    buildspells(sofar, len-1)
  end
  sofar.pop
end

40.times { |i| buildspells([], i); puts i }
