#!/usr/bin/env ruby


ingredients = File.readlines("input.15").map { |l| l.scan(/-?\d+/).map { |d| d.to_i } }
props = ingredients[0].size

$best = 0

def try(recipe, ingredients, left)
  if ingredients.length == 1
    recipe.size.times { |p| recipe[p] += ingredients[0][p] * left }
    cur = recipe[0..-2].inject { |a,b| a * b }
    if cur > $best && recipe.all? { |x| x > 0 } && recipe[4] == 500
      $best = cur
      puts $best
    end
    recipe.size.times { |p| recipe[p] -= ingredients[0][p] * left }
    return
  end
  left.times do |a|
    try(recipe, ingredients[1..-1], left - a)
    recipe.size.times { |p| recipe[p] += ingredients[0][p] }
  end
  recipe.size.times { |p| recipe[p] -= ingredients[0][p] * left }
end

puts ingredients.inspect
try([0] * props, ingredients, 100)
