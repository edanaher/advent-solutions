#!/usr/bin/env ruby

input = File.readlines("input.19").map { |l| l.chomp }

subs = input[0..-3].map { |s| s =~ /(\w*) => (\w*)/; [$1, $2] }
mol = input[-1]

puts subs.inspect
puts mol.inspect

mols = {}

subs.each do |from, to|
  mol.size.times do |i|
    if mol[i,from.length] == from then
      mol2 = mol.dup
      mol2[i,from.length] = to
      puts mol, mol2
      puts i, from
      mols[mol2] = true
    end
  end
end
puts mols.size
