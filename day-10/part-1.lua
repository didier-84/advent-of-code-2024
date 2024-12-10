-- Day 10 - Part 1

local params = {...}
local day    = '10'
local part   = '1'

function run(input)
  local sum        = 0
  local grid       = {}
  local trailheads = {}
  local summits    = {}

  do -- Build grid and registrer trailheads
    local row_index = 1

    for line in input:lines() do
      local row = {}

      for col_index = 1, #line do
        local value = tonumber(line:sub(col_index, col_index))
        table.insert(row, value)

        if value == 0 then
          table.insert(trailheads, { row = row_index, col = col_index })
        end
      end

      table.insert(grid, row)

      row_index = row_index + 1
    end
  end

  -- Helper functions
  local is_in_grid        = nil
  local cardinal_cells    = nil
  local find_summits_from = nil

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

  find_summits_from = function(row, col, value)
    if value == 9 then
      local key = row .. '-' .. col

      if summits[key] == nil then
        summits[key] = true

        sum = sum + 1
      end
    else
      for _, cell in ipairs(cardinal_cells(row, col)) do
        next_value = grid[cell.row][cell.col]

        if next_value == value + 1 then
          find_summits_from(cell.row, cell.col, next_value)
        end
      end
    end
  end

  for _, trailhead in ipairs(trailheads) do
    summits = {}

    find_summits_from(trailhead.row, trailhead.col, 0)
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
