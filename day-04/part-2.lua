-- Day 04 - Part 2

local grid_helper = require('helpers/grid_helper')

local params = {...}
local day    = '04'
local part   = '2'

function run(input)
  local sum  = 0
  local grid = grid_helper.build_grid(input)

  for row_index, row in ipairs(grid) do
    for col_index, cell in ipairs(row) do
      if cell == 'A' then
        local ne_cell = grid_helper.north_east_cell(grid, row_index, col_index)
        local sw_cell = grid_helper.south_west_cell(grid, row_index, col_index)

        if ne_cell .. sw_cell == 'MS' or ne_cell .. sw_cell == 'SM' then
          local nw_cell = grid_helper.north_west_cell(grid, row_index, col_index)
          local se_cell = grid_helper.south_east_cell(grid, row_index, col_index)

          if nw_cell .. se_cell == 'MS' or nw_cell .. se_cell == 'SM' then
            sum = sum + 1
          end
        end
      end
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
