-- Day 10 - Part 2

local params = {...}
local day    = '10'
local part   = '2'

function run(input)
  local sum        = 0
  local grid       = {}
  local summits    = {}
  local trailheads = {}

  do -- Build grid and registrer summits
    local row_index = 1

    for line in input:lines() do
      local row = {}

      for col_index = 1, #line do
        local value = tonumber(line:sub(col_index, col_index))
        table.insert(row, value)

        if value == 9 then
          table.insert(summits, { row = row_index, col = col_index })
        end
      end

      table.insert(grid, row)

      row_index = row_index + 1
    end
  end

  -- Helper functions
  local is_in_grid        = nil
  local cardinal_cells    = nil
  local find_trailheads_from = nil

  is_in_grid = function(cell)
    return grid[cell.row] ~= nil and grid[cell.row][cell.col] ~= nil
  end

  cardinal_cells = function(row, col)
    local valid_cells = {}

    local potential_cells = {
      { row = row - 1, col = col     },
      { row = row + 1, col = col     },
      { row = row,     col = col + 1 },
      { row = row,     col = col - 1 }
    }

    for _, cell in ipairs(potential_cells) do
      if is_in_grid(cell) then
        table.insert(valid_cells, cell)
      end
    end

    return valid_cells
  end

  find_trailheads_from = function(row, col, value)
    if value == 0 then
      local key = row .. '-' .. col

      if trailheads[key] == nil then
        sum = sum + 1
      end
    else
      for _, cell in ipairs(cardinal_cells(row, col)) do
        next_value = grid[cell.row][cell.col]

        if next_value == value - 1 then
          find_trailheads_from(cell.row, cell.col, next_value)
        end
      end
    end
  end

  for _, summit in ipairs(summits) do
    trailheads = {}

    find_trailheads_from(summit.row, summit.col, 9)
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
