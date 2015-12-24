#!/usr/bin/env ruby

packages = File.readlines("input.24").map(&:to_i)

puts packages.inspect
$maxweight = packages.max
$targetweight = packages.inject {|a,b| a + b} / 3
puts $targetweight

arr = [packages.size + 2] * ($targetweight + $maxweight + 5)
arr[0] = 0
packages.each do |p|
  $targetweight.downto(0) do |w|
    arr[w + p] = [arr[w+p], arr[w] + 1].min
  end
end

puts arr.inspect
$group1size = arr[$targetweight]
puts $group1size
$packages = packages

def buildpackages(sofar, sum, w)
  if sofar.size == $group1size
    return unless sum == $targetweight

    packages = $packages - sofar
    arr = [packages.size + 2] * ($targetweight + $maxweight + 5)
    arr[0] = 0
    packages.each do |p|
      $targetweight.downto(0) do |w|
        arr[w + p] = [arr[w+p], arr[w] + 1].min
      end
    end
    #puts arr[$targetweight]
    return if arr[$targetweight] > packages.size

    quantum = sofar.inject {|a,b| a * b}
    puts "#{quantum}: #{sofar.inspect}"
  end
  
  (w..$packages.size-1).each do |p|
    sofar << $packages[p]
    buildpackages(sofar, sum + $packages[p], p+1)
    sofar.pop
  end
end

buildpackages([], 0, 0)
