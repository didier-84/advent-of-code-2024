-- Day 19 - Part 2

local params = {...}
local day    = '19'
local part   = '2'

function run(input)
  local sum            = 0
  local towels         = {}
  local max_towel_size = 0
  local designs        = {}
  local cache          = {}

  for line in input:lines() do
    if string.match(line, ',') then
      for towel in string.gmatch(line, '%a+') do
        towels[towel] = true
        max_towel_size = math.max(max_towel_size, #towel)
      end
    elseif line ~= '' then
      table.insert(designs, line)
    end
  end

  local count_valid_arrangements = nil

  count_valid_arrangements = function(design)
    if cache[design] ~= nil then
      return cache[design]
    end

    local count = 0

    for i = 1, max_towel_size, 1 do
      local lead = design:sub(1,i)
      local rest = design:sub(i + 1,#design)

      if towels[lead] == true then
        if #rest == 0 then
          count = count + 1
          break
        else
          count = count + count_valid_arrangements(rest)
        end
      end
    end

    cache[design] = count
    return count
  end

  for _, design in ipairs(designs) do
    sum = sum + count_valid_arrangements(design)
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
