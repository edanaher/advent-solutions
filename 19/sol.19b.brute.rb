#!/usr/bin/env ruby

input = File.readlines("input.19").map { |l| l.chomp }

subs = input[0..-3].map { |s| s =~ /(\w*) => (\w*)/; [$1, $2] }.group_by {|x| x[0]}.map { |k, v| [k, v.map { |x| x[1] }]}
subs = Hash[subs]
puts subs.inspect
target = input[-1]
targetsize = target.size

queue = ["e"]
nextqueue = []
mols = {}
count = 1

loop do
  mol = queue.shift
  mol.size.times do |i|
    if subs[mol[i]] then
      match = mol[i]
    elsif subs[mol[i,2]] then
      match = mol[i,2]
    else
      next
    end
    subs[match].each do |repl|
      mol2 = mol.dup
      mol2[i,match.length] = repl
      next if mols[mol2]
      if mol2 == target
        puts count
        exit
      end
      next if mol2.size >= targetsize
      nextqueue << mol2
      mols[mol2] = true
#puts mol2
    end
  end
  if queue.empty?
    count += 1
    puts count
    queue = nextqueue
    nextqueue = []
  end
end
