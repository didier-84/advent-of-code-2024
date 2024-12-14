-- Day 14 - Part 2

local params = {...}
local day    = '14'
local part   = '2'

function run(input)
  local area      = { cols = 101, rows = 103 }
  local robots    = {}
  local seconds   = 20000
  local mid_col   = (area.cols - 1) / 2
  local mid_row   = (area.rows - 1) / 2

  do -- create robots
    for line in input:lines() do
      local robot = { p = {}, v = {} }

      robot.p.col = tonumber(line:match('p=(%d+),'))
      robot.p.row = tonumber(line:match('p=%d+,(%d+)'))
      robot.v.col = tonumber(line:match('v=(-?%d+),'))
      robot.v.row = tonumber(line:match('v=.+,(-?%d+)'))

      table.insert(robots, robot)
    end
  end

  local grid = {}

  for i = 1, seconds do
    local positions = {}
    local has_triangle = false

    for row_index = 0, area.rows do
      grid[row_index] = {}

      for col_index = 0, area.cols do
        grid[row_index][col_index] = '.'
      end
    end

    for _, robot in ipairs(robots) do
      local final_row = (robot.p.row + (robot.v.row * i)) % area.rows
      local final_col = (robot.p.col + (robot.v.col * i)) % area.cols

      table.insert(positions, { row = final_row, col = final_col })

      grid[final_row][final_col] = 'X'
    end

    for _, pos in ipairs(positions) do
      if grid[pos.row + 3] ~= nil then
        if grid[pos.row + 1][pos.col - 1] == 'X' and grid[pos.row + 1][pos.col + 1] == 'X' then
          if grid[pos.row + 2][pos.col - 2] == 'X' and grid[pos.row + 2][pos.col + 2] == 'X' then
            if grid[pos.row + 3][pos.col - 3] == 'X' and grid[pos.row + 3][pos.col + 3] == 'X' then
              has_triangle = true
            end
          end
        end
      end
    end

    if has_triangle then return i end
  end

  return 0
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
