-- Day 09 - Part 1

grid_helper = require('helpers/grid_helper')

local params = {...}
local day    = '09'
local part   = '1'

function run(input)
  local sum    = 0
  local blocks = {}

  local DOT    = '.'
  local SPACE  = ' '

  do -- Parse line into array of blocks
    for line in input:lines() do
      local file_id = 0
      local block   = nil

      for index = 1, #line do
        local file_length = string.sub(line, index, index)

        if index % 2 == 0 then
          block = DOT
        else
          block   = file_id
          file_id = file_id + 1
        end

        for j = 1, file_length do
          table.insert(blocks, block)
        end
      end
    end
  end

  do -- Move blocks from end to empty start positions
    local start_cursror = 1

    for end_cursor = #blocks, 1, -1 do
      if blocks[end_cursor] == DOT then
        blocks[end_cursor] = SPACE
      else
        while blocks[start_cursror] ~= DOT do
          start_cursror = start_cursror + 1

          if start_cursror > end_cursor then break end
        end

        if start_cursror > end_cursor then break end

        blocks[end_cursor], blocks[start_cursror] = SPACE, blocks[end_cursor]
      end
    end
  end

  do -- Checksum of re-arranged blocks
    for index, block in ipairs(blocks) do
      if block == SPACE then break end

      sum = sum + (index - 1) * block
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
