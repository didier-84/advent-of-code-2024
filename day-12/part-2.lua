-- Day 10 - Part 2

local params = {...}
local day    = '10'
local part   = '2'

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
      { row = row - 1, col = col,     face = 'n' },
      { row = row,     col = col + 1, face = 'e'  },
      { row = row + 1, col = col,     face = 's' },
      { row = row,     col = col - 1, face = 'w'  }
    }
  end

  local group = nil

  for row_index = 1, #grid do
    for col_index, cell in ipairs(grid[row_index]) do
      group = group_helper.build_empty_group(cell.value)

      local next_cells = {{ row = row_index, col = col_index }}

      while #next_cells > 0 do
        local next = table.remove(next_cells, #next_cells)

        if need_visiting(next) and cell_value(next) == group.value then
          mark_as_visited(next)

          group.area = group.area + 1

          for _, cardinal in ipairs(cardinal_cells(next.row, next.col)) do
            if cell_value(cardinal) ~= group.value then
              local face = cardinal.face

              if face == 'n' or face == 's' then
                if group.sides[face][next.row] == nil then group.sides[face][next.row] = {} end

                table.insert(group.sides[face][next.row], next.col)
              elseif face == 'e' or face == 'w' then
                if group.sides[face][next.col] == nil then group.sides[face][next.col] = {} end

                table.insert(group.sides[face][next.col], next.row)
              end
            elseif need_visiting(cardinal) then
              table.insert(next_cells, cardinal)
            end
          end
        end
      end

      sum = sum + (group.area * group_helper.count_all_sides(group))
    end
  end

  return sum
end

group_helper = {}

group_helper.build_empty_group = function(value)
  return {
    value = value,
    area  = 0,
    sides = { n = {}, e  = {}, s = {}, w = {} }
  }
end

group_helper.count_sides_in_row = function(row)
  table.sort(row, function(a, b) return a < b end)

  local count = 0
  local prev = nil

  for _,col in ipairs(row) do
    if prev == nil or col - prev ~= 1 then
      count = count + 1
    end

    prev = col
  end

  return count
end

group_helper.count_all_sides = function(group)
  local count = 0

  for _, rows in pairs(group.sides) do
    for _, row in pairs(rows) do
      count = count + group_helper.count_sides_in_row(row)
    end
  end

  return count
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
