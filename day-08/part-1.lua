-- Day 08 - Part 1

local params = {...}
local day    = '08'
local part   = '1'

function run(input)
  local sum       = 0

  local grid_width     = 0
  local grid_height    = 0
  local antenna_groups = {}
  local antinodes      = {}

  do -- Parse input into antennas
    local row_index = 0

    for line in input:lines() do
      row_index = row_index + 1

      if row_index == 1 then
        grid_width = #line
      end

      for col_index = 1, #line do
        local value = string.sub(line, col_index, col_index)

        if value ~= '.' then
          if antenna_groups[value] == nil then
            antenna_groups[value] = {}
          end

          antenna = { col = col_index, row = row_index }
          table.insert(antenna_groups[value], antenna)
        end
      end
    end

    grid_height = row_index
  end

  function is_in_grid(row, col)
    if row < 1 or row > grid_height then
      return false
    end

    if col < 1 or col > grid_width then
      return false
    end

    return true
  end

  function add_antinode(antinode)
    if is_in_grid(antinode.row, antinode.col) then
      local key = antinode.row .. '-' .. antinode.col

      if antinodes[key] == nil then
        antinodes[key] = true
        sum = sum + 1
      end
    end
  end

  do -- Process each group of antennas
    for _, antennas in pairs(antenna_groups) do
      for i = 1, #antennas do
        local first = antennas[i]

        for j = i+1, #antennas do
          local second    = antennas[j]
          local delta_row = first.row - second.row
          local delta_col = first.col - second.col
          local antinode  = {}

          antinode.row = first.row + delta_row
          antinode.col = first.col + delta_col

          add_antinode(antinode)

          antinode.row = second.row - delta_row
          antinode.col = second.col - delta_col

          add_antinode(antinode)
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
