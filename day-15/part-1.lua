-- Day 15 - Part 1

local params = {...}
local day    = '15'
local part   = '1'

function run(input)
  local sum   = 0
  local grid  = {}
  local moves = {}
  local robot = {}

  do -- build grid, locate robot,  and list moves
    local row_index  = 1
    local input_type = 'grid'

    for line in input:lines() do
      if line == '' then
        input_type = 'moves'
      elseif input_type == 'grid' then
        grid[row_index] = {}

        for col_index = 1, #line do
          local cell = string.sub(line, col_index, col_index)

          grid[row_index][col_index] = cell

          if cell == '@' then
            robot = { row = row_index, col = col_index }
          end
        end

        row_index = row_index + 1
      elseif input_type == 'moves' then
        for i = 1, #line do
          table.insert(moves, string.sub(line, i, i))
        end
      end
    end
  end

  do -- move the robot and boxes
    local switch_cells = nil
    local move_to      = nil

    switch_cells = function(a_row, a_col, b_row, b_col)
      grid[a_row][a_col], grid[b_row][b_col] = grid[b_row][b_col], grid[a_row][a_col]
    end

    move_to = function(row, col, row_delta, col_delta)
      local cell = grid[row + row_delta][col + col_delta]

      if cell == '.' then
        switch_cells(row, col, row + row_delta, col + col_delta)

        if robot.row == row and robot.col == col then
          robot.row = robot.row + row_delta
          robot.col = robot.col + col_delta
        end

        return true
      end

      if cell == 'O' then
        if move_to(row + row_delta, col + col_delta, row_delta, col_delta) then
          return move_to(row, col, row_delta, col_delta)
        end
      end

      return false
    end

    for _, move in ipairs(moves) do
      if move == '^' then
        move_to(robot.row, robot.col, -1, 0)
      elseif move == 'v' then
        move_to(robot.row, robot.col, 1, 0)
      elseif move == '<' then
        move_to(robot.row, robot.col, 0, -1)
      elseif move == '>' then
        move_to(robot.row, robot.col, 0, 1)
      end
    end
  end

  do -- compute result
    for row_index, row in ipairs(grid) do
      for col_index, cell in ipairs(row) do
        if cell == 'O' then
          sum = sum + 100 * (row_index - 1) + col_index - 1
        end
      end
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
