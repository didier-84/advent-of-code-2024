-- Day 16 - Part 1

grid_helper = require('helpers/grid_helper')

local params = {...}
local day    = '16'
local part   = '1'

function run(input)
  local grid      = {}
  local start     = {}
  local final     = {}
  local start_dir = 'e'

  do -- build grid
    for line in input:lines() do
      local row = {}

      for i = 1, #line do
        local val = line:sub(i, i)
        table.insert(row, { row = #grid + 1, col = i, val = val, sum = nil })

        if val == 'S' then start = { row = #grid + 1, col = i } end
        if val == 'E' then final = { row = #grid + 1, col = i } end
      end

      table.insert(grid, row)
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

  do -- find the best path
    local function turn_left(dir)
      return ({ n = 'w', s = 'e', e = 'n', w = 's' })[dir]
    end

    local function turn_right(dir)
      return ({ n = 'e', s = 'w', e = 's', w = 'n' })[dir]
    end

    local function get_cell(row, col, dir)
      if dir == 'n' then return grid[row - 1][col] end
      if dir == 's' then return grid[row + 1][col] end
      if dir == 'e' then return grid[row][col + 1] end
      if dir == 'w' then return grid[row][col - 1] end
    end

    local function set_sum(row, col, sum)
      if grid[row][col].sum == nil then
        grid[row][col].sum = sum
      elseif sum >= grid[row][col].sum then
        return false
      end

      return true
    end

    lowest = 2^1000

    local nexts = { { row = start.row, col = start.col, dir = start_dir, sum = 0 } }

    local function get_lowest_from_nexts()
      local index  = 0
      local lowest = nil

      for i, next in ipairs(nexts) do
        if index == 0 or next.sum < lowest then
          index  = i
          lowest = next.sum
        end
      end

      return table.remove(nexts, index)
    end

    local function find_path(row, col, dir, sum)
      if grid[row][col].val == 'E' then
        lowest = math.min(lowest, grid[row][col].sum)
        return
      end

      local new_sum = sum + 1

      local front = get_cell(row, col, dir)
      local left  = get_cell(row, col, turn_left(dir))
      local right = get_cell(row, col, turn_right(dir))

      if front.val ~= '#' then
        if set_sum(front.row, front.col, new_sum) then
          table.insert(nexts, { row = front.row, col = front.col, dir = dir, sum = new_sum })
        end
      end

      if left.val ~= '#' then
        if set_sum(left.row, left.col, new_sum + 1000) then
          table.insert(nexts, { row = left.row, col = left.col, dir = turn_left(dir), sum = new_sum + 1000 })
        end
      end

      if right.val ~= '#' then
        if set_sum(right.row, right.col, new_sum + 1000) then
          table.insert(nexts, { row = right.row, col = right.col, dir = turn_right(dir), sum = new_sum + 1000 })
        end
      end
    end

    while #nexts > 0 do
      local next = get_lowest_from_nexts()
      find_path(next.row, next.col, next.dir, next.sum)
    end
  end

  return lowest
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
