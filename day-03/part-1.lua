-- Day 03 - Part 1

local params = {...}
local day    = '03'
local part   = '1'

function run(input)
  local sum = 0

  for line in input:lines() do
    for instruction in string.gmatch(line, "mul%((%d+,%d+)%)") do
      local product = 1

      for number in string.gmatch(instruction, "(%d+)") do
        if #(tostring(number)) < 4 then
          product = product * number
        end
      end

      sum = sum + product
    end
  end

  return sum
end

Helpers = {}

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
