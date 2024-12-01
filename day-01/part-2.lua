-- Day 01 - Part 2

local params = {...}
local day    = '01'
local part   = '2'

function run(input)
  local sum = 0
  local list_1 = {}
  local list_2 = {}

  for line in input:lines() do
    table.insert(list_1, string.match(line, "^(%d+)"))

    local id_2 = string.match(line, "(%d+)$")
    if list_2[id_2] == nil then
      list_2[id_2] = 1
    else
      list_2[id_2] = list_2[id_2] + 1
    end
  end

  for i = 1, (#list_1), 1 do
    sum = sum + (list_1[i] * (list_2[list_1[i]] or 0))
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
print('Similarity score is: ' .. result)
