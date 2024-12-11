-- Day 11 - Part 2

local params = {...}
local day    = '11'
local part   = '2'

local blinks = 75

function run(input, blinks)
  local sum    = 0
  local stones = {}

  for line in input:lines() do
    for number in string.gmatch(line, '%d+') do
      stones[number] = 1
    end
  end

  for i = 1, blinks do
    local next_stones = {}

    for stone, count in pairs(stones) do
      local key = ''

      if stone == '0' then
        next_stones['1'] = count + (next_stones['1'] or 0 )
      elseif #stone % 2 == 0 then
        key = tostring(tonumber(string.sub(stone, 1, #stone / 2)))
        next_stones[key] = count + (next_stones[key] or 0 )

        key = tostring(tonumber(string.sub(stone, #stone / 2 + 1, #stone)))
        next_stones[key] = count + (next_stones[key] or 0 )
      else
        key = tostring(2024 * tonumber(stone))
        next_stones[key] = count + (next_stones[key] or 0 )
      end
    end

    stones = next_stones
  end

  for _,count in pairs(stones) do
    sum = sum + count
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

local result = run(load_input_file(), blinks)
print('Result: ' .. result)
