#!/usr/bin/env ruby

input = File.readlines("input.19").map { |l| l.chomp }

subs = input[0..-3].map { |s| s =~ /(\w*) => (\w*)/; [$2, $1] }
subs = Hash[subs]
puts subs.inspect
longestsub = subs.map { |k,v| k.length}.max
target = input[-1]
targetsize = target.size

queue = [target]
nextqueue = []
mols = {}
count = 1

loop do
  mol = queue.shift
  [mol.size, 2*longestsub].min.times do |i|
    (1..longestsub).each do |l|
      if subs[mol[i,l]]
        mol2 = mol.dup
        mol2[i,l] = subs[mol[i,l]]
        next if mols[mol2]
        if mol2 == "e"
          puts count
          exit
        end
        possible = (0..longestsub).any? do |before|
          (1..longestsub).any? do |len|
            subs[mol[i-before,len]]
          end
        end
        next unless possible
        nextqueue << mol2
        mols[mol2] = true
      end
    end
  end
  if queue.empty?
    count += 1
    puts nextqueue
    puts "#{count}: #{nextqueue.size}"
    queue = nextqueue
    nextqueue = []
  end
end
