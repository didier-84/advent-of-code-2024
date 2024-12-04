-- Day 04 - Part 1

local grid_helper = require('helpers/grid_helper')

local params = {...}
local day    = '04'
local part   = '1'

function run(input)
  local sum  = 0
  local grid = grid_helper.build_grid(input)

  local function count_xmas_occurrences_in(line)
    local _, xmas_count = string.gsub(line, 'XMAS', '')
    local _, samx_count = string.gsub(line, 'SAMX', '')

    return xmas_count + samx_count
  end

  for _, line in ipairs(grid_helper.horizontal_lines(grid)) do
    sum = sum + count_xmas_occurrences_in(line)
  end

  for _, line in ipairs(grid_helper.vertical_lines(grid)) do
    sum = sum + count_xmas_occurrences_in(line)
  end

  for _, line in ipairs(grid_helper.diagonal_lines(grid)) do
    sum = sum + count_xmas_occurrences_in(line)
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
