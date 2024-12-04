local helper = {}

function helper.build_grid(input)
  local grid = {}

  for line in input:lines() do
    local row = {}

    for i = 1, #line do
      table.insert(row, line:sub(i, i))
    end

    table.insert(grid, row)
  end

  return grid
end

function helper.horizontal_lines(grid)
  local lines = {}

  for row_index, row in ipairs(grid) do
    local line = ''

    for col_index, cell in ipairs(row) do
      line = line .. cell
    end

    table.insert(lines, line)
  end

  return lines
end

function helper.vertical_lines(grid)
  local lines = {}

  for col_index, col in ipairs(grid[1]) do
    local line = ''

    for row_index, row in ipairs(grid) do
      line = line .. row[col_index]
    end

    table.insert(lines, line)
  end

  return lines
end

function helper.diagonal_lines(grid)
  local lines = {}

  for row_index, row in ipairs(grid) do
    for col_index, cell in ipairs(row) do
      -- Diagonals going from North-West to South-East
      if row_index == 1 or col_index == 1 then
        local line = tostring(cell)
        local next = { row = row_index + 1, col = col_index + 1 }

        while grid[next.row] ~= nil and grid[next.row][next.col] ~= nil do
          line = line .. tostring(grid[next.row][next.col])

          next.row = next.row + 1
          next.col = next.col + 1
        end

        table.insert(lines, line)
      end

      -- Diagonals going from North-East to South-West
      if row_index == 1 or col_index == #grid[1] then
        local line = tostring(grid[row_index][col_index])
        local prev = { row = row_index + 1, col = col_index - 1 }

        while grid[prev.row] ~= nil and grid[prev.row][prev.col] ~= nil do
          line = line .. tostring(grid[prev.row][prev.col])

          prev.row = prev.row + 1
          prev.col = prev.col - 1
        end

        table.insert(lines, line)
      end
    end
  end

  return lines
end

function helper.cell_value(grid, row_index, col_index)
  if grid[row_index] ~= nil and grid[row_index][col_index] ~= nil then
    return grid[row_index][col_index]
  else
    return ''
  end
end

function helper.north_east_cell(grid, row_index, col_index)
  return helper.cell_value(grid, row_index - 1, col_index - 1)
end

function helper.south_west_cell(grid, row_index, col_index)
  return helper.cell_value(grid, row_index + 1, col_index + 1)
end

function helper.north_west_cell(grid, row_index, col_index)
  return helper.cell_value(grid, row_index + 1, col_index - 1)
end

function helper.south_east_cell(grid, row_index, col_index)
  return helper.cell_value(grid, row_index - 1, col_index + 1)
end

function helper.array_to_string(array)
  local string = ''

  for i=1, #array do
    string = string .. array[i]
  end

  return string
end

function helper.print_grid(grid)
  for i = 1, #grid do
    print(helper.array_to_string(grid[i]))
  end
end

return helper
