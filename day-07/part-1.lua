-- Day 07 - Part 1

grid_helper = require('helpers/grid_helper')

local params = {...}
local day    = '07'
local part   = '1'

function run(input)
  local sum       = 0
  local equations = {}

  for line in input:lines() do
    local result, rest = string.match(line, '(%d+): (.+)')

    local equation = { result = tonumber(result), numbers = {} }

    for number in string.gmatch(rest, '%d+') do
      table.insert(equation.numbers, tonumber(number))
    end

    table.insert(equations, equation)
  end

  for _, equation in ipairs(equations) do
    local add_next      = nil
    local mulitply_next = nil
    local is_solvable   = nil

    add_next = function(numbers)
      local first, numbers = grid_helper.array_shift(numbers)
      numbers[1] = first + numbers[1]

      if #numbers == 1 then
        return (numbers[1] == equation.result)
      else
        return is_solvable(numbers)
      end
    end

    multiply_next = function(numbers)
      local first, numbers = grid_helper.array_shift(numbers)

      numbers[1] = first * numbers[1]

      if #numbers == 1 then
        return (numbers[1] == equation.result)
      else
        return is_solvable(numbers)
      end
    end

    is_solvable = function(numbers)
      return add_next(numbers) or multiply_next(numbers)
    end

    if is_solvable(equation.numbers) then
      sum = sum + equation.result
    end
  end

  return sum
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
