-- Day 15 - Part 2

local params = {...}
local day    = '15'
local part   = '2'

function run(input)
  local sum   = 0
  local grid  = {}
  local moves = {}
  local robot = {}

  do -- build grid, locate robot,  and list moves
    local row_index  = 1
    local input_type = 'grid'

    local mapping = {
      ['#'] = {'#', '#'},
      ['O'] = {'[', ']'},
      ['.'] = {'.', '.'},
      ['@'] = {'@', '.'}
    }

    for line in input:lines() do
      if line == '' then
        input_type = 'moves'
      elseif input_type == 'grid' then
        grid[row_index] = {}

        for col_index = 1, #line do
          local value = string.sub(line, col_index, col_index)
          local cell  = mapping[value][1]

          grid[row_index][col_index * 2 - 1] = cell

          if cell == '@' then
            robot = { row = row_index, col = col_index * 2 - 1 }
          end

          cell = mapping[value][2]

          grid[row_index][col_index * 2] = cell
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
    local swap_cells              = nil
    local move_box_vertically     = nil
    local move_box_horizontally   = nil
    local move_robot_vertically   = nil
    local move_robot_horizontally = nil

    swap_cells = function(a_row, a_col, b_row, b_col)
      grid[a_row][a_col], grid[b_row][b_col] = grid[b_row][b_col], grid[a_row][a_col]
    end

    move_box_vertically = function(row, col, delta, do_the_move)
      local can_move = false

      if do_the_move == nil then do_the_move = true end

      local block = grid[row + delta][col] .. grid[row + delta][col + 1]

      if block == '##' then
        can_move = false
      elseif block == '..' then
        can_move = true
      elseif block == '.[' then
        can_move = move_box_vertically(row + delta, col + 1, delta, do_the_move)
      elseif block == '[]' then
        can_move = move_box_vertically(row + delta, col, delta, do_the_move)
      elseif block == '].' then
        can_move = move_box_vertically(row + delta, col - 1, delta, do_the_move)
      elseif block == '][' then
        can_move = move_box_vertically(row + delta, col - 1, delta, do_the_move)
        can_move = can_move and move_box_vertically(row + delta, col + 1, delta, do_the_move)
      end

      if can_move and do_the_move then
        swap_cells(row, col,     row + delta, col)
        swap_cells(row, col + 1, row + delta, col + 1)
      end

      return can_move
    end

    move_box_horizontally = function(row, col, delta)
      local can_move = false

      local cell = grid[row][col + delta * 2]

      if cell == '#' then
        return false
      elseif cell == '.' then
        can_move = true
      elseif cell == '[' or cell == ']' then
        can_move = move_box_horizontally(row, col + delta * 2, delta)
      end

      if can_move then
        swap_cells(row, col + delta, row, col + delta * 2)
        swap_cells(row, col + delta, row, col)
      end

      return can_move
    end

    move_robot_vertically = function(row, col, delta)
      local can_move = false

      local cell = grid[row + delta][col]

      if cell == '#' then
        can_move = false
      elseif cell == '.' then
        can_move = true
      elseif cell == '[' then
        if move_box_vertically(row + delta, col,  delta, false) then
          can_move = move_box_vertically(row + delta, col,  delta, true)
        end
      elseif cell == ']' then
        if move_box_vertically(row + delta, col - 1,  delta, false) then
          can_move = move_box_vertically(row + delta, col - 1,  delta, true)
        end
      end

      if can_move then
        swap_cells(row, col, row + delta, col)

        robot.row = robot.row + delta
      end
    end

    move_robot_horizontally = function(row, col, delta)
      local can_move = false

      local cell = grid[row][col + delta]

      if cell == '#' then
        can_move = false
      elseif cell == '.' then
        can_move = true
      else
        can_move = move_box_horizontally(row, col + delta, delta)
      end

      if can_move then
        swap_cells(row, col, row, col + delta)

        robot.col = robot.col + delta
      end
    end

    for i, move in ipairs(moves) do
      if move == '^' then
        move_robot_vertically(robot.row, robot.col, -1)
      elseif move == 'v' then
        move_robot_vertically(robot.row, robot.col, 1)
      elseif move == '<' then
        move_robot_horizontally(robot.row, robot.col, -1)
      elseif move == '>' then
        move_robot_horizontally(robot.row, robot.col, 1)
      end
    end
  end

  do -- compute result
    for row_index, row in ipairs(grid) do
      for col_index, cell in ipairs(row) do
        if cell == '[' then
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
