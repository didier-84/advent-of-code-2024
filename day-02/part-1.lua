-- Day 02 - Part 1

local params = {...}
local day    = '02'
local part   = '1'

function run(input)
  local sum = 0

  for line in input:lines() do
    local numbers = {}

    for number in string.gmatch(line, "(%d+)") do
      table.insert(numbers, number)
    end

    if Helpers:is_safe_report(numbers) then
      sum = sum + 1
    end
  end

  return sum
end

Helpers = {}

function Helpers:is_safe_report(numbers)
  local is_safe    = true
  local levels_are = ''

  for i = 2, (#numbers), 1 do
    local delta  = numbers[i-1] - numbers[i]

    if delta == 0 or delta > 3 or delta < -3 then
      is_safe = false
      break
    end

    if levels_are == '' then
      levels_are = (delta < 0) and 'increasing' or 'decreasing'
    else
      if (delta < 0 and levels_are == 'decreasing') or (delta > 0 and levels_are == 'increasing') then
        is_safe = false
        break
      end
    end
  end

  return is_safe
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
