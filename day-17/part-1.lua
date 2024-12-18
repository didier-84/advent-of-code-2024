-- Day 17 - Part 1

local params = {...}
local day    = '17'
local part   = '1'

function run(input)
  local registers = {}
  local program   = {}
  local output    = {}

  for line in input:lines() do
    if string.match(line, 'Register A') then
      registers.a = tonumber(string.match(line, '%d+'))
    elseif string.match(line, 'Register B') then
      registers.b = tonumber(string.match(line, '%d+'))
    elseif string.match(line, 'Register C') then
      registers.c = tonumber(string.match(line, '%d+'))
    elseif string.match(line, 'Program') then
      local pointer = 0
      for number in string.gmatch(line, '%d') do
        program[pointer] = tonumber(number)
        pointer = pointer + 1
      end
    end
  end

  function combo(operand)
    if operand < 4 then
      return operand
    elseif operand == 4 then
      return registers.a
    elseif operand == 5 then
      return registers.b
    elseif operand == 6 then
      return registers.c
    elseif operand == 7 then
      print('Seven is not allowed.')
    end

    return nil
  end

  local pointer = 0

  while program[pointer] ~= nil do
    local jumped        = false
    local opcode        = program[pointer]
    local operand       = program[pointer + 1]
    local combo_operand = combo(operand)

    if opcode == 0 then
      registers.a = registers.a // (2^combo_operand)
    elseif opcode == 1 then
      registers.b = registers.b ~ operand
    elseif opcode == 2 then
      registers.b = combo_operand % 8
    elseif opcode == 3 then
      if registers.a ~= 0 then
        pointer = operand
        jumped  = true
      end
    elseif opcode == 4 then
      registers.b = registers.b ~ registers.c
    elseif opcode == 5 then
      table.insert(output, math.floor(combo_operand % 8))
    elseif opcode == 6 then
      registers.b = math.floor(registers.a / 2^combo_operand)
    elseif opcode == 7 then
      registers.c = math.floor(registers.a / 2^combo_operand)
    end

    pointer = pointer + (jumped and 0 or 2)
  end

  return table.concat(output, ',')
end

function load_input_file()
  -- current script path, because input files are relative to it
  local script_path = debug.getinfo(1,"S").source:sub(2):match("(.*/)") or ''
  local filename = 'part-1.txt'

  if params[1] == 'test' then
    filename = 'part-1-test.txt'
  end

  return io.open(script_path .. 'input/' .. filename, 'r')
end

print('Day ' .. day .. ' - part ' .. part)
print('-----------------\n')

local result = run(load_input_file())
print('Result: ' .. result)
