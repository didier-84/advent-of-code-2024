-- Day 12 - Part 1

local params = {...}
local day    = '12'
local part   = '1'

function run(input)
  local sum    = 0
  local grid   = {}

  do -- Build grid and
    local row_index = 1

    for line in input:lines() do
      local row = {}

      for col_index = 1, #line do
        local value = line:sub(col_index, col_index)
        table.insert(row, { visited = false, value = value })
      end

      table.insert(grid, row)

      row_index = row_index + 1
    end
  end

  -- Helper functions

  function is_in_grid (cell)
    return grid[cell.row] ~= nil and grid[cell.row][cell.col] ~= nil
  end

  function cell_value(cell)
    return is_in_grid(cell) and grid[cell.row][cell.col].value or nil
  end

  function need_visiting(cell)
    return is_in_grid(cell) and grid[cell.row][cell.col].visited == false
  end

  function mark_as_visited(cell)
    grid[cell.row][cell.col].visited = true
  end

  function cardinal_cells(row, col)
    return {
      { row = row - 1, col = col     }, -- N
      { row = row,     col = col + 1 }, -- E
      { row = row + 1, col = col     }, -- S
      { row = row,     col = col - 1 }  -- W
    }
  end

  local group = nil

  for row_index = 1, #grid do
    for col_index, cell in ipairs(grid[row_index]) do
      group = { value = cell.value, area = 0, perimeter = 0 }

      local next_cells = { { row = row_index, col = col_index } }

      while #next_cells > 0 do
        local next = table.remove(next_cells, #next_cells)

        if need_visiting(next) and cell_value(next) == group.value then
          mark_as_visited(next)

          group.area = group.area + 1

          for _, cardinal in ipairs(cardinal_cells(next.row, next.col)) do
            if cell_value(cardinal) ~= group.value then
              group.perimeter = group.perimeter + 1
            elseif need_visiting(cardinal) then
              table.insert(next_cells, cardinal)
            end
          end
        end
      end

      sum = sum + (group.area * group.perimeter)
    end
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
