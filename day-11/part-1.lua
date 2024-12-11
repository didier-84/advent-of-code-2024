-- Day 11 - Part 1

local params = {...}
local day    = '11'
local part   = '1'

local blinks = 25

function run(input, blinks)
  local stones = {}

  for line in input:lines() do
    for number in string.gmatch(line, '%d+') do
      table.insert(stones, number)
    end
  end

  for i = 1, blinks do
    local new_stones = {}

    for _, stone in ipairs(stones) do
      if stone == '0' then
        table.insert(new_stones, '1')
      elseif #stone % 2 == 0 then
        table.insert(new_stones, tostring(tonumber(string.sub(stone, 1, #stone / 2))))
        table.insert(new_stones, tostring(tonumber(string.sub(stone, #stone / 2 + 1, #stone))))
      else
        new_stone = tostring(2024 * tonumber(stone))
        table.insert(new_stones, new_stone)
      end
    end

    stones = new_stones
  end

  return #stones
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
