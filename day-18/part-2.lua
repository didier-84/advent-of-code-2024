-- Day 18 - Part 2

local params = {...}
local day    = '18'
local part   = '2'

function run(input)
  local result = ''
  local grid   = {}

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
        table.insert(row, tostring(symbol))
      end

      table.insert(grid, row)
    end
  end

  do -- add falling bytes and find way after
    local count = 1

    for line in input:lines() do
      if line ~= '' then
        local col = string.match(line, '(%d+),')
        local row = string.match(line, ',(%d+)')
        grid[row + 2][col + 2] = '#'
      end

      count   = count + 1
      blocked = true

      local visited = {}

      do -- find best path
        function build_cell(row, col)
          return { row = row, col = col }
        end

        local nexts    = { build_cell(start.row, start.col) }
        local continue = true

        while #nexts > 0 and continue do
          local cell = table.remove(nexts, #nexts)

          local cardinals = {
            build_cell(cell.row - 1, cell.col   ),
            build_cell(cell.row,     cell.col - 1),
            build_cell(cell.row + 1, cell.col   ),
            build_cell(cell.row,     cell.col + 1)
          }

          for _, cardinal in ipairs(cardinals) do
            if grid[cardinal.row][cardinal.col] == 'E' then
              blocked  = false
              continue = false
            elseif grid[cardinal.row][cardinal.col] == '.' then
              if visited[cardinal.row .. '-' .. cardinal.col] == nil then
                visited[cardinal.row .. '-' .. cardinal.col] = true
                table.insert(nexts, cardinal)
              end
            end
          end
        end
      end

      if blocked then
        result = line
        break
      end
    end
  end

  return result
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
