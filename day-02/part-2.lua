-- Day 02 - Part 2

local params = {...}
local day    = '02'
local part   = '2'

function run(input)
  local sum = 0

  for line in input:lines() do
    local numbers = {}

    for number in string.gmatch(line, "(%d+)") do
      table.insert(numbers, number)
    end

    if Helpers:is_safe_report(numbers) then
      sum = sum + 1
    else
      for index, value in ipairs(numbers) do
        local new_numbers = Helpers:copy_array(numbers)
        table.remove(new_numbers, index)

        if Helpers:is_safe_report(new_numbers) then
          sum = sum + 1
          break
        end
      end
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

function Helpers:copy_array(array)
  local new_array = {}

  for index, value in ipairs(array) do
    table.insert(new_array, value)
  end

  return new_array
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
