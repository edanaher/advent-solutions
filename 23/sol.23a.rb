#!/usr/bin/env/ruby


instructions = File.readlines("input.23").map { |l| l.chomp.scan(/[-\w]+/) }

registers = Hash.new(0)
pc = 0

while pc < instructions.size
  instr = instructions[pc]
  reg = instr[1]
  off = instr[2]
  puts instr.inspect
  case instr[0]
  when "hlf"
    registers[reg] /= 2
  when "tpl"
    registers[reg] *= 3
  when "inc"
    registers[reg] += 1
  when "jmp"
    pc = pc + reg.to_i - 1
  when "jie"
    pc = pc + off.to_i - 1 if registers[reg] % 2 == 0
  when "jio"
    pc = pc + off.to_i - 1 if registers[reg] == 1
  end
  pc += 1
  puts "#{pc}; #{registers["a"]}, #{registers["b"]}"
end
puts registers.inspect
