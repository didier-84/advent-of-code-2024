-- Day 06 - Part 2

local params = {...}
local day    = '06'
local part   = '2'

function run(input)
  local sum  = 0
  local grid = {}

  local build_index = function(i, j)
    return tostring(i) .. '-' .. tostring(j)
  end

  local row_index   = 1
  local start_index = ''
  local visited     = {}

  for line in input:lines() do
    for col_index = 1, #line do
      local index = build_index(row_index, col_index)

      grid[index] = {
        row   = row_index,
        col   = col_index,
        value = line:sub(col_index, col_index)
      }

      if grid[index].value == '^' then
        start_index = index
        grid[index].value = '.'
      end
    end

    row_index = row_index + 1
  end

  local next_direction = {['N'] = 'E', ['E'] = 'S', ['S'] = 'W', ['W'] = 'N'}

  local direction     = 'N'
  local current_index = start_index

  local function next_index(current_cell, obstructions)
    local index = ''

    if direction == 'N' then
      index = build_index(current_cell.row - 1, current_cell.col)
    elseif direction == 'E' then
      index = build_index(current_cell.row, current_cell.col + 1)
    elseif direction == 'S' then
      index = build_index(current_cell.row + 1, current_cell.col)
    elseif direction == 'W' then
      index = build_index(current_cell.row, current_cell.col - 1)
    end

    if grid[index] == nil or grid[index].value == '.' or grid[index].value == 'X' then
      return index, obstructions
    else
      if obstructions ~= nil then
        local ob_key = direction .. index

        if obstructions[ob_key] == nil then
          obstructions[ob_key] = 1
        else
          obstructions = nil
        end
      end

      direction = next_direction[direction]
      return next_index(current_cell, obstructions)
    end
  end

  while grid[current_index] ~= nil do
    if grid[current_index].value == '.' or grid[current_index].value == '^' then
      grid[current_index].value = 'X'
      if current_index ~= start_index then
        table.insert(visited, current_index)
      end
    end

    current_index = next_index(grid[current_index])
  end

  for _, index in ipairs(visited) do
    local obstructions = {}

    grid[index].value = 'O'

    direction     = 'N'
    current_index = start_index

    while grid[current_index] ~= nil do
      if obstructions == nil then
        sum = sum + 1
        break
      end

      current_index, obstructions = next_index(grid[current_index], obstructions)
    end

    grid[index].value = 'X'
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
