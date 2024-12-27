-- Day 18 - Part 1

local params = {...}
local day    = '18'
local part   = '1'

function run(input)
  local min_steps = 70^2
  local grid      = {}

  local grid_size   = 71 + 2
  local bytes_count = 1024

  if is_test() then
    grid_size   = 7 + 2
    bytes_count = 12
  end

  local start = {row = 2, col = 2 }
  local final = {row = grid_size - 2, col = grid_size - 2 }

  do -- build empty grid
    for i = 1, grid_size do
      local row = {}

      for j = 1, grid_size do
        local symbol = '.'

        if j == 1 or i == 1 or i == grid_size or j == grid_size then
          symbol = '#'
        elseif j == 2 and i == 2 then
          symbol = 'S'
        elseif j == grid_size - 1 and i == grid_size -1 then
          symbol = 'E'
        end
        table.insert(row, { val = tostring(symbol), sum = 0 })
      end

      table.insert(grid, row)
    end
  end

  do -- add falling bytes
    local count = 1

    for line in input:lines() do
      if line ~= '' then
        local col = string.match(line, '(%d+),')
        local row = string.match(line, ',(%d+)')
        grid[row + 2][col + 2].val = '#'
      end

      if count == bytes_count then break end

      count = count + 1
    end
  end

  do -- block simple dead ends in grid
    local function cardinal_values(row, col)
      return {
        grid[row - 1][col].val,
        grid[row + 1][col].val,
        grid[row][col - 1].val,
        grid[row][col + 1].val
      }
    end

    local function is_dead_end(row, col)
      local cardinals = cardinal_values(row, col)
      table.sort(cardinals)
      return string.match(table.concat(cardinals), '###') ~= nil
    end

    local function block_dead_ends()
      local any_dead_end = false

      for row = 2, #grid - 1 do
        for col = 2, #grid[1] - 1 do
          if grid[row][col].val == '.' and is_dead_end(row, col) then
            grid[row][col].val = '#'
            any_dead_end = true
          end
        end
      end

      return any_dead_end
    end

    while block_dead_ends() do end
  end

  do -- find best path
    function build_cell(row, col, sum)
      return { row = row, col = col, sum = sum }
    end

    local nexts = { build_cell(start.row, start.col, 0) }

    while #nexts > 0 do
      local cell = table.remove(nexts, #nexts)

      local cardinals = {
        build_cell(cell.row - 1, cell.col,     cell.sum + 1),
        build_cell(cell.row,     cell.col - 1, cell.sum + 1),
        build_cell(cell.row + 1, cell.col,     cell.sum + 1),
        build_cell(cell.row,     cell.col + 1, cell.sum + 1)
      }

      for _, cardinal in ipairs(cardinals) do
        if grid[cardinal.row][cardinal.col].val == 'E' then
          min_steps = math.min(min_steps, cardinal.sum)
        elseif grid[cardinal.row][cardinal.col].val == '.' then
          if grid[cardinal.row][cardinal.col].sum == 0 or grid[cardinal.row][cardinal.col].sum > cardinal.sum then
            grid[cardinal.row][cardinal.col].sum = tonumber(cardinal.sum)
            table.insert(nexts, cardinal)
          end
        end
      end
    end
  end

  return min_steps
end

function is_test()
  return params[1] == 'test'
end

function load_input_file()
  -- current script path, because input files are relative to it
  local script_path = debug.getinfo(1,"S").source:sub(2):match("(.*/)") or ''
  local filename    = is_test() and 'part-1-test.txt' or 'part-1.txt'

  return io.open(script_path .. 'input/' .. filename, 'r')
end

print('Day ' .. day .. ' - part ' .. part)
print('-----------------\n')

local result = run(load_input_file())
print('Result: ' .. result)
